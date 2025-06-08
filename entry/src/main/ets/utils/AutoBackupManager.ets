import { DatabaseHelper } from './DatabaseHelper';
import dayjs from 'dayjs';
import { fileUri, fileIo as fs, ListFileOptions, picker } from '@kit.CoreFileKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { BizConstants } from './BizConstants';
import { PreferenceStore } from './PreferenceStore';
import { BackupInfoRecord } from '../models/BackupModel';

export class AutoBackupManager {
  context: Context

  constructor(context: Context) {
    this.context = context
  }

  getBackupDbFileName() {
    let fileName = BizConstants.Rdb_backup_name_suffix + dayjs(this.getCurrentDate()).format("YYYYMMDDHHmmss") +
    BizConstants.Rdb_backup_file_suffix
    return fileName
  }

  async createDownloadPackageDir(): Promise<string> {

    let bakDirPath = ""
    try {
      const documentViewPicker = new picker.DocumentViewPicker(this.context);
      const documentSaveOptions = new picker.DocumentSaveOptions();
      documentSaveOptions.pickerMode = picker.DocumentPickerMode.DOWNLOAD;

      let savePromise = await documentViewPicker.save(documentSaveOptions)
      let uri = savePromise[0]
      console.info('documentViewPicker.save succeed and uri is:' + uri);

      //1. download/包名 目录下建立bak目录
      bakDirPath = new fileUri.FileUri(uri + '/bak').path;
      let check = fs.accessSync(bakDirPath, fs.AccessModeType.EXIST)
      if (!check) {
        fs.mkdirSync(bakDirPath)
        console.log("mylog", `create dir:${bakDirPath}`)
      } else {
        console.log("mylog", `exist dir:${bakDirPath}`)
      }


    } catch (err) {
      const error = err as BusinessError;
      console.error("mylog",
        `createDownloadPackageDirfailed, code: ${error.code}, message: ${error.message}`);
    }

    return bakDirPath


  }

  getCurrentDate() {
    //let str = "2025-06-07 00:" + Math.floor(Math.random() * 60) + ":" + Math.floor(Math.random() * 60)
    //return dayjs(str).toDate()
    return new Date()
    //return mockRandomCurrentDay("2025-06-08")
  }


  async getAllBackupFiles(): Promise<BackupInfoRecord[]> {
    let backupDir: string = await this.createDownloadPackageDir()
    let dirExist = fs.accessSync(backupDir, fs.AccessModeType.EXIST)

    let result: BackupInfoRecord[] = []
    if (dirExist) {

      let listFileOption: ListFileOptions = {
        recursion: false,
        filter: {
          suffix: [BizConstants.Rdb_backup_file_suffix],
          fileSizeOver: 0,
        }
      };

      let fileArray = fs.listFileSync(backupDir, listFileOption)

      if (fileArray.length > 0) {
        fileArray.sort((a, b) => {

          let path1 = new fileUri.FileUri(backupDir + "/" + a).path
          let path2 = new fileUri.FileUri(backupDir + "/" + b).path

          let stat1 = fs.statSync(path1)
          let stat2 = fs.statSync(path2)
          let minus = stat1.mtime - stat2.mtime

          return minus
        }
        )

        for (let item of fileArray) {

          let filePath = new fileUri.FileUri(backupDir + "/" + item).path

          let timePart = this.getFileNameTimeStr(item)
          let timeStr = dayjs(timePart, "YYYYMMDDHHmmss").format("YYYY-MM-DD HH:mm:ss")
          let backupInfoRecord: BackupInfoRecord =
            {
              timeStr: timeStr,
              backupFilePath: filePath
            }
          result.push(backupInfoRecord)
        }
      }
    }

    return result


  }


  async getLatestBackup(): Promise<string> {
    let backupDir: string = await this.createDownloadPackageDir()
    let dirExist = fs.accessSync(backupDir, fs.AccessModeType.EXIST)

    let result = ""
    if (dirExist) {

      let listFileOption: ListFileOptions = {
        recursion: false,
        filter: {
          suffix: [BizConstants.Rdb_backup_file_suffix],
          // displayName: ["*.backup"],
          fileSizeOver: 0,
        }
      };

      let fileArray = fs.listFileSync(backupDir, listFileOption)

      if (fileArray.length > 0) {
        fileArray.sort((a, b) => {

          let path1 = new fileUri.FileUri(backupDir + "/" + a).path
          let path2 = new fileUri.FileUri(backupDir + "/" + b).path

          let stat1 = fs.statSync(path1)
          let stat2 = fs.statSync(path2)
          let minus = stat1.mtime - stat2.mtime

          return minus
        }
        )

        let latestFileName = fileArray[fileArray.length-1]
        result = new fileUri.FileUri(backupDir + "/" + latestFileName).path
      }

    }

    return result

  }

  getFileNameTimeStr(item: string) {
    let timePart = ""
    try {
      timePart = item.split(".")[0].split("_")[1]

    } catch (err1) {
      const error = err1 as BusinessError;
      console.error("mylog",
        `getFileNameTimeStr parse timePart failed, code: ${error.code}, message: ${error.message}`);
    }

    return timePart
  }

  isDayBackupFileOverLimits(backupDir: string): boolean {

    try {
      let currentYmd = dayjs(this.getCurrentDate()).format("YYYY-MM-DD")

      let listFileOption: ListFileOptions = {
        recursion: false,
        filter: {
          suffix: [BizConstants.Rdb_backup_file_suffix],
          fileSizeOver: 0,
        }
      };

      let fileArray = fs.listFileSync(backupDir, listFileOption)

      let findArray = fileArray.filter((item) => {

        try {
          let timePart = item.split(".")[0].split("_")[1]
          if (timePart !== undefined) {
            let date = dayjs(timePart, "YYYYMMDDHHmmss")
            let ymd = date.format("YYYY-MM-DD")
            if (ymd === currentYmd) {
              return true
            }
          }

        } catch (err1) {
          const error = err1 as BusinessError;
          console.error("mylog",
            `isDayBackupFileOverLimits parse timePart failed, code: ${error.code}, message: ${error.message}`);
        }

        return false
      }
      )

      if (findArray && findArray.length >= BizConstants.Rdb_backup_max_day_count) {
        return true
      }

      return false
    } catch (err) {
      const error = err as BusinessError;
      console.error("mylog", `isDayBackupFileOverLimits failed, code: ${error.code}, message: ${error.message}`);
      return false
    }


  }

  reserveLatestBackupFiles(backupDir: string) {
    let listFileOption: ListFileOptions = {
      recursion: false,
      filter: {
        suffix: [BizConstants.Rdb_backup_file_suffix],
        fileSizeOver: 0,
      }
    };

    let fileArray = fs.listFileSync(backupDir, listFileOption)

    if (fileArray.length > 0) {
      fileArray.sort((a, b) => {

        let path1 = new fileUri.FileUri(backupDir + "/" + a).path
        let path2 = new fileUri.FileUri(backupDir + "/" + b).path

        let stat1 = fs.statSync(path1)
        let stat2 = fs.statSync(path2)
        let minus = stat1.mtime - stat2.mtime

        return minus
      }
      )
    }

    let removeCount = fileArray.length - BizConstants.Rdb_backup_file_max_total_count

    for (let i = 0; i < removeCount; i++) {
      let removeFilePath = new fileUri.FileUri(backupDir + "/" + fileArray[i]).path
      fs.unlink(removeFilePath)
    }

  }

  async backup(backupDir: string) {
    try {


      if (!PreferenceStore.getHasNewData()) {
        console.log("mylog", "no new data")
        return
      }

      let currentYmd = dayjs(this.getCurrentDate()).format("YYYY-MM-DD")

      if (this.isDayBackupFileOverLimits(backupDir)) {
        console.log("mylog", "has backed up at :", currentYmd)
        return
      }

      await this.backupInner(backupDir)
      this.reserveLatestBackupFiles(backupDir)

    } catch (err) {
      const error = err as BusinessError;
      console.error("mylog", `backup failed, code: ${error.code}, message: ${error.message}`);
    }

  }

  async manualBackup(backupDir: string): Promise<boolean> {

    if (this.isDayBackupFileOverLimits(backupDir)) {
      let currentYmd = dayjs(this.getCurrentDate()).format("YYYY-MM-DD")
      console.log("mylog", "has backed up at :", currentYmd)
      AlertDialog.show(
        {
          message: "超出日备份上限数!"
        }
      )

      return false
    }

    this.backupInner(backupDir)

    return true
  }

  async backupInner(backupDir: string) {
    try {

      if (!backupDir) {
        console.log("mylog", "backupDir is empty")
        return
      }


      let backupFileName = this.getBackupDbFileName()
      //1. download/包名 目录下建立bak目录
      let applicationContext = this.context.getApplicationContext();
      let filesDir = applicationContext.databaseDir;
      let bakSrcDirPath = new fileUri.FileUri(filesDir + "/rdbbak").path

      if (!fs.accessSync(bakSrcDirPath, fs.AccessModeType.EXIST)) {
        fs.mkdirSync(bakSrcDirPath)
      }

      let srcFilePath = bakSrcDirPath + "/" + backupFileName
      await DatabaseHelper.getInstance().backupDb(srcFilePath)

      let srcExist = fs.accessSync(bakSrcDirPath, fs.AccessModeType.EXIST)

      //清理沙箱数据库备份文件
      if (srcExist) {
        console.log("mylog", "src file exist", srcFilePath)
        let toFilePath = backupDir + "/" + backupFileName
        fs.copyFileSync(srcFilePath, toFilePath)

        PreferenceStore.setHasNewData(false)

        console.log("mylog", "copyFileSync", srcFilePath, "->", toFilePath)
        fs.unlink(srcFilePath)

      } else {
        console.log("mylog", "src file not exist", srcFilePath)
      }

      //this.reserveLatestBackupFiles(backupDir)


    } catch (err) {
      const error = err as BusinessError;
      console.error("mylog", `backup failed, code: ${error.code}, message: ${error.message}`);
    }

  }


  // async backupxx(backupDir: string) {
  //
  //
  //   try {
  //
  //     if (!PreferenceStore.getHasNewData()) {
  //
  //       console.log("mylog", "no new data")
  //       return
  //     }
  //
  //     let pref_store_name = PreferenceStoreNames[PreferenceStoreNames.default_pref_store]
  //     let store = preferences.getPreferencesSync(this.context, {
  //       // 仓库的名称
  //       name: pref_store_name
  //     })
  //
  //     let backup_key = PreferenceKeys[PreferenceKeys.backup_key]
  //
  //     let backup_info: BackupInfoRecord[] = []
  //
  //     let val: string = store.getSync(backup_key, "") as string
  //     if (val !== "") {
  //       console.log("mylog", backup_key + " exist");
  //       backup_info = JSON.parse(val)
  //     }
  //
  //
  //     let currentYmd = dayjs(this.getCurrentDate()).format("YYYY-MM-DD")
  //
  //     let sameYmdArray = backup_info.filter((item) => {
  //       let hisYmd = dayjs(item.timeStr).format("YYYY-MM-DD")
  //       return currentYmd === hisYmd
  //     })
  //
  //     if (sameYmdArray.length >= BizConstants.Rdb_backup_max_day_count) {
  //       console.log("mylog", "has backed up at :", currentYmd)
  //       return
  //     }
  //
  //
  //     let backupFileName = this.getBackupDbFileName()
  //
  //     //1. download/包名 目录下建立bak目录
  //     let applicationContext = this.context.getApplicationContext();
  //     // 获取应用文件路径
  //     let filesDir = applicationContext.databaseDir;
  //
  //     let bakSrcDirPath = new fileUri.FileUri(filesDir + "/rdbbak").path
  //
  //     if (!fs.accessSync(bakSrcDirPath, fs.AccessModeType.EXIST)) {
  //       fs.mkdirSync(bakSrcDirPath)
  //     }
  //
  //     let srcFilePath = bakSrcDirPath + "/" + backupFileName
  //     await DatabaseHelper.getInstance().backupDb(srcFilePath)
  //
  //     let srcExist = fs.accessSync(bakSrcDirPath, fs.AccessModeType.EXIST)
  //
  //
  //
  //     if (srcExist) {
  //       console.log("mylog", "src file exist", srcFilePath)
  //       let toFilePath = backupDir + "/" + backupFileName
  //       fs.copyFileSync(srcFilePath, toFilePath)
  //
  //       PreferenceStore.setHasNewData(false)
  //
  //       let newItem: BackupInfoRecord =
  //         {
  //
  //           timeStr: dayjs(this.getCurrentDate()).format("YYYY-MM-DD HH:mm:ss"),
  //           backupFilePath: toFilePath
  //         }
  //
  //       backup_info.push(newItem)
  //
  //       console.log("mylog", "copyFileSync", srcFilePath, "->", toFilePath)
  //       fs.unlink(srcFilePath)
  //
  //
  //       //完成之后写标记
  //       //保留最新的N 个备份
  //       if (backup_info.length > 0 && backup_info.length > BizConstants.Rdb_backup_file_max_total_count) {
  //         backup_info.sort((a, b) => {
  //           let aDate = dayjs(a.timeStr)
  //           let bDate = dayjs(b.timeStr)
  //           return aDate.unix() - bDate.unix()
  //
  //         })
  //
  //         let shiftItem = backup_info[0]
  //         let shiftFileExist = fs.accessSync(shiftItem.backupFilePath, fs.AccessModeType.EXIST)
  //         if (shiftFileExist) {
  //           fs.unlinkSync(shiftItem.backupFilePath)
  //         }
  //
  //         backup_info.shift()
  //       }
  //
  //       let objectStr = JSON.stringify(backup_info)
  //
  //
  //       store.putSync(backup_key, objectStr)
  //       store.flush()
  //     } else {
  //       console.log("mylog", "src file not exist", srcFilePath)
  //     }
  //
  //
  //   } catch (err) {
  //     const error = err as BusinessError;
  //     console.error("mylog", `backup failed, code: ${error.code}, message: ${error.message}`);
  //   }
  //
  // }
}

