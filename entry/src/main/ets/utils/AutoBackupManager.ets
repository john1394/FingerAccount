import { PreferenceKeys, PreferenceStores } from './PreferenceKeys';
import { preferences } from '@kit.ArkData';
import { DatabaseHelper } from './DatabaseHelper';
import dayjs from 'dayjs';
import { fileUri, fileIo as fs, ListFileOptions, picker } from '@kit.CoreFileKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { BizConstants } from './BizConstants';

export class AutoBackupManager {
  //static store_name: string = "pref_store_name"
  context: Context

  constructor(context: Context) {
    this.context = context
  }

  getBackupDbFileName() {
    let fileName = "bak_" + dayjs(new Date()).format("YYYYMMDDHHmmss") + BizConstants.Rdb_backup_file_suffix
    return fileName
  }

  async createDownloadPackageDir(context: Context): Promise<string> {

    const documentViewPicker = new picker.DocumentViewPicker(context);
    const documentSaveOptions = new picker.DocumentSaveOptions();
    documentSaveOptions.pickerMode = picker.DocumentPickerMode.DOWNLOAD;

    let savePromise = await documentViewPicker.save(documentSaveOptions)
    let uri = savePromise[0]
    console.info('documentViewPicker.save succeed and uri is:' + uri);

    //1. download/包名 目录下建立bak目录
    const bakDirPath = new fileUri.FileUri(uri + '/bak').path;
    let check = fs.accessSync(bakDirPath, fs.AccessModeType.EXIST)
    if (!check) {
      fs.mkdirSync(bakDirPath)
      console.log("mylog", `create dir:${bakDirPath}`)
    } else {
      console.log("mylog", `exist dir:${bakDirPath}`)
    }

    return bakDirPath

  }


  async backup(backupDir: string) {


    try {

      let pref_store_name = PreferenceStores[PreferenceStores.default_pref_store]
      let store = preferences.getPreferencesSync(this.context, {
        // 仓库的名称
        name: pref_store_name
      })

      let backup_key = PreferenceKeys[PreferenceKeys.backup_key]
      // let val = store.getSync(backup_key, "")
      let val = "" //debug only

      if (val !== "") {
        console.log("mylog", backup_key + " exist");
      } else {
        let backupFileName = this.getBackupDbFileName()

        //1. download/包名 目录下建立bak目录
        let applicationContext = this.context.getApplicationContext();
        // 获取应用文件路径
        let filesDir = applicationContext.databaseDir;

        let bakSrcDirPath = new fileUri.FileUri(filesDir + "/rdbbak").path

        if (!fs.accessSync(bakSrcDirPath, fs.AccessModeType.EXIST)) {
          fs.mkdirSync(bakSrcDirPath)
        }


        let srcFilePath = bakSrcDirPath + "/" + backupFileName
        await DatabaseHelper.getInstance().backupDb(srcFilePath)

        let srcExist = fs.accessSync(bakSrcDirPath, fs.AccessModeType.EXIST)

        let listFileOption: ListFileOptions = {
          recursion: false,
          filter: {
            suffix: [BizConstants.Rdb_backup_file_suffix],
            // displayName: ["*.backup"],
            fileSizeOver: 0,
          }
        };


        //  let fileoperation1 = fs.listFileSync(bakSrcDirPath, listFileOption)

        // .filter(
        //   (item) => {
        //     let path = bakSrcDirPath + "/" + item
        //     let stat = fs.statSync(path)
        //     return stat.isFile()
        //   }
        // );


        if (srcExist) {
          console.log("mylog", "src file exist", srcFilePath)
          let toFilePath = backupDir + "/" + backupFileName
          fs.copyFileSync(srcFilePath, toFilePath)

          console.log("mylog", "copyFileSync", srcFilePath, "->", toFilePath)
          fs.unlink(srcFilePath)
        } else {
          console.log("mylog", "src file not exist", srcFilePath)
        }

        //完成之后写标记
        //保留最新的5个备份

        store.putSync(backup_key, "1")
        store.flush()
      }
    } catch (err) {

      const error = err as BusinessError;
      console.error("mylog", `backup failed, code: ${error.code}, message: ${error.message}`);
    }
    //console.log("mylog", PreferenceKeys.backup_key + ""); // 输出: "backup_key"
    //console.log("mylog", "begin check backup ", PreferenceKeys.backup_key, PreferenceKeys[PreferenceKeys.backup_key])
  }

  restore() {

  }
}