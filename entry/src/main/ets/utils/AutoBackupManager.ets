import { PreferenceKeys, PreferenceStoreNames } from './PreferenceKeys';
import { preferences } from '@kit.ArkData';
import { DatabaseHelper } from './DatabaseHelper';
import dayjs from 'dayjs';
import { fileUri, fileIo as fs, picker } from '@kit.CoreFileKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { BizConstants } from './BizConstants';
import { backupInfoRecord as BackupInfoRecord } from '../models/BackupModel';
import { PreferenceStore } from './PreferenceStore';

export class AutoBackupManager {
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

  getCurrentDate() {
    //return dayjs("2025-06-06 00:12:12").toDate()
    return new Date()
  }


  async backup(backupDir: string) {

    //todo 有新数据才backup,has 新数据

    try {

      if (!PreferenceStore.getHasNewData()) {

        console.log("mylog", "no new data")
        return
      }

      let pref_store_name = PreferenceStoreNames[PreferenceStoreNames.default_pref_store]
      let store = preferences.getPreferencesSync(this.context, {
        // 仓库的名称
        name: pref_store_name
      })

      let backup_key = PreferenceKeys[PreferenceKeys.backup_key]

      let backup_info: BackupInfoRecord[] = []

      let val: string = store.getSync(backup_key, "") as string
      if (val !== "") {
        console.log("mylog", backup_key + " exist");
        backup_info = JSON.parse(val)
      }


      let currentYmd = dayjs(this.getCurrentDate()).format("YYYY-MM-DD")

      let sameYmdArray = backup_info.filter((item) => {
        let hisYmd = dayjs(item.timeStr).format("YYYY-MM-DD")
        return currentYmd === hisYmd
      })

      if (sameYmdArray.length >= BizConstants.Rdb_backup_max_day_count) {
        console.log("mylog", "has backed up at :", currentYmd)
        return
      }


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

      // let listFileOption: ListFileOptions = {
      //   recursion: false,
      //   filter: {
      //     suffix: [BizConstants.Rdb_backup_file_suffix],
      //     // displayName: ["*.backup"],
      //     fileSizeOver: 0,
      //   }
      // };


      if (srcExist) {
        console.log("mylog", "src file exist", srcFilePath)
        let toFilePath = backupDir + "/" + backupFileName
        fs.copyFileSync(srcFilePath, toFilePath)

        PreferenceStore.setHasNewData(false)

        let newItem: BackupInfoRecord =
          {

            timeStr: dayjs(this.getCurrentDate()).format("YYYY-MM-DD HH:mm:ss"),
            backupFilePath: toFilePath
          }

        backup_info.push(newItem)

        console.log("mylog", "copyFileSync", srcFilePath, "->", toFilePath)
        fs.unlink(srcFilePath)


        //完成之后写标记
        //保留最新的N 个备份
        if (backup_info.length > 0 && backup_info.length > BizConstants.Rdb_backup_file_max_total_count) {
          backup_info.sort((a, b) => {
            let aDate = dayjs(a.timeStr)
            let bDate = dayjs(b.timeStr)
            return aDate.unix() - bDate.unix()

          })

          let shiftItem = backup_info[0]
          let shiftFileExist = fs.accessSync(shiftItem.backupFilePath, fs.AccessModeType.EXIST)
          if (shiftFileExist) {
            fs.unlinkSync(shiftItem.backupFilePath)
          }

          backup_info.shift()
        }

        let objectStr = JSON.stringify(backup_info)


        store.putSync(backup_key, objectStr)
        store.flush()
      } else {
        console.log("mylog", "src file not exist", srcFilePath)
      }


    } catch (err) {
      const error = err as BusinessError;
      console.error("mylog", `backup failed, code: ${error.code}, message: ${error.message}`);
    }

  }

  async restore(backupDir: string) {

  }
}


//test only
// backup_info = [
//   {
//     yyyyMMDDHHMMSS: "2025-06-04 01:12:13"
//   },
//   {
//     yyyyMMDDHHMMSS: "2025-06-04 01:12:14"
//   },
//   {
//     yyyyMMDDHHMMSS: "2025-06-04 01:12:15"
//   },
//   {
//     yyyyMMDDHHMMSS: "2025-06-04 01:12:16"
//   },
//
// ]