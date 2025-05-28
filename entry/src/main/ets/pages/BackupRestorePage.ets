import { BackHeader } from '../components/RenderItem';
import { router } from '@kit.ArkUI';
import { fileIo as fs, picker } from '@kit.CoreFileKit';
import { BusinessError, emitter } from '@kit.BasicServicesKit';
import { DatabaseHelper } from '../utils/DatabaseHelper';
import { util } from '@kit.ArkTS';
import { BillDbRecord } from '../models/RecordList';
import { BudgetStore } from '../utils/BudgetStore';
import { BizConstants } from '../utils/BizConstants';

function stringToArray(str: string): Uint8Array {
  let textEncoder = new util.TextEncoder();
  return textEncoder.encodeInto(str);
}


// function assetAdd() {
//
//
//   let attr: asset.AssetMap = new Map();
//   // attr.set(asset.Tag("aa"), stringToArray('demo_pwd'));
//   // attr.set(asset.Tag.ALIAS, stringToArray('demo_alias'));
//   //attr.set(asset.Tag.de, "myval")
//   // attr.set(asset.Tag.ACCESSIBILITY, asset.Accessibility.DEVICE_FIRST_UNLOCKED);
//   // attr.set(asset.Tag.DATA_LABEL_NORMAL_1, stringToArray('demo_label'));
//   try {
//     asset.addSync(attr);
//   } catch (error) {
//     let err = error as BusinessError;
//     console.error(`Failed to add Asset. Code is ${err.code}, message is ${err.message}`);
//   }
// }
//
// function assetQuery() {
//   let query: asset.AssetMap = new Map();
//   query.set(asset.Tag.ALIAS, stringToArray('demo_alias'));
//   try {
//     let res: Array<asset.AssetMap> = asset.querySync(query);
//     let accessibility: number;
//     for (let i = 0; i < res.length; i++) {
//       // parse the attribute.
//       if (res[i] != null) {
//         accessibility = res[i].get(asset.Tag.ACCESSIBILITY) as number;
//       }
//     }
//   } catch (error) {
//     let err = error as BusinessError;
//     console.error(`Failed to query Asset. Code is ${err.code}, message is ${err.message}`);
//   }
//
// }

@Entry
@Component
struct BackupRestorePage {
  @State
  isProcessing: boolean = false

  async restore() {

    try {
      let documentSelectOptions = new picker.DocumentSelectOptions();

      let documentPicker = new picker.DocumentViewPicker(getContext(this));
      documentPicker.select(documentSelectOptions).then((documentSelectResult: Array<string>) => {
        console.info('DocumentViewPicker.select successfully, documentSelectResult uri: ' +
        JSON.stringify(documentSelectResult));

        try {
          let path = documentSelectResult[0]
          let file = fs.openSync(path, fs.OpenMode.READ_ONLY);
          let stat = fs.statSync(file.fd)


          fs.readText(path,)
          console.info('tag file fd: ' + file.fd + 'url:' + file.path);
          let buffer = new ArrayBuffer(stat.size);
          let readLen = fs.readSync(file.fd, buffer);
          console.info('tag readSync data to file succeed and buffer size is:' + readLen);
          //读取完成后关闭fd。
          fs.closeSync(file);
          let decoder = util.TextDecoder.create('utf-8');
          let str = decoder.decodeToString(new Uint8Array(buffer));

          let parsedObj: BillDbRecord[] = JSON.parse(str)

          if (parsedObj.length > 0) {
            DatabaseHelper.getInstance().insertAllBillRecord(parsedObj)
          }

          emitter.emit(BizConstants.Month_reload_data_key)
          console.log("mylog:", str)

        } catch (error1) {
          console.error(`mylogfailed   , Error code: ${error1.code}, message: ${error1.message}`);
        }


      }).catch((err: BusinessError) => {
        console.error('DocumentViewPicker.select failed with err: ' + JSON.stringify(err));
      });
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      console.error('DocumentViewPicker failed with err: ' + JSON.stringify(err));
    }


  }

  backupData() {
    //this.isProcessing = true

    try {
      let documentSaveOptions = new picker.DocumentSaveOptions();
      documentSaveOptions.newFileNames = ['DocumentViewPicker01.txt'];
      let documentPicker = new picker.DocumentViewPicker(getContext(this));
      documentPicker.save(documentSaveOptions).then((documentSaveResult: Array<string>) => {
        console.info('DocumentViewPicker.save successfully, documentSaveResult uri: ' +
        JSON.stringify(documentSaveResult));

        let path = documentSaveResult[0]

        let allRecord = DatabaseHelper.getInstance().getAllBillRecord()

        let fileContent = JSON.stringify(allRecord)

        let file = fs.openSync(path, fs.OpenMode.READ_WRITE);

        fs.writeSync(file.fd, fileContent)
        // console.info('file fd: ' + file.fd);
      }).catch((err: BusinessError) => {
        console.error('DocumentViewPicker.save failed with err: ' + JSON.stringify(err));
      });
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      console.error('DocumentViewPicker failed with err: ' + JSON.stringify(err));
    }
    return

  }

  build() {
    Column({ space: 5 }) {
      BackHeader(
        {
          click: () => {
            router.back()
          }

        })

      Column() {
        Column({ space: 10 }) {
          Column() {
            Button("备份", { type: ButtonType.Normal })
              .width("100%")
              .height(36)
              .border({ width: 1, color: Color.Black })// 蓝色细边框
              .fontColor($r("app.color.text_primary"))
              .fontWeight(FontWeight.Medium)
              .fontSize(24)
              .backgroundColor(Color.Transparent)
              .borderRadius(8)
              .onClick(() => {
                this.backupData()
              })

          }
          .backgroundColor($r("app.color.white"))
          .borderRadius(8)

          Column() {
            Button("恢复", { type: ButtonType.Normal })
              .width("100%")
              .height(36)
              .border({ width: 1, color: Color.Black })// 蓝色细边框
              .fontColor($r("app.color.text_primary"))
              .fontWeight(FontWeight.Medium)
              .fontSize(24)
              .backgroundColor(Color.Transparent)
              .borderRadius(8)
              .onClick(() => {
                this.restore()
              })

          }
          .backgroundColor($r("app.color.white"))
          .borderRadius(8)

          if (this.isProcessing) {
            Row({ space: 10 }) {
              LoadingProgress().width(30).height(30)
              Text("正在处理中...")
                .fontSize(12)
                .fontColor($r("app.color.text_second"))
            }
          }


          Column() {

            Column() {
              Text("备份列表")
            }.width("100%")
            .backgroundColor(Color.Grey)

            List({ space: 10 }) {
              ForEach([1, 2, 3], (item: number) => {

                ListItem() {


                  Column() {

                    Column() {
                      Text(item.toString())
                    }.height(36).width("100%")

                    Divider().strokeWidth(1)
                      .width("95%")
                  }
                }

              })
            }

          }.backgroundColor($r("app.color.white"))
          .borderRadius(8)

        }.width("100%")

      }
      .width("100%")
      .padding(10)

    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.back_color'))
  }
}


// let path = "file://docs/storage/Users/currentUser/Documents/DocumentViewPicker01.txt"
// const content = "这是要写入文件的内容";
// try {
//
//
//   let file = fs.openSync(path, fs.OpenMode.READ_WRITE);
//   fs.writeSync(file.fd, "hello")
//   console.info('file fd: ' + file.fd);
// } catch (error) {
//   console.error(`mylogfailed to  , Error code: ${error.code}, message: ${error.message}`);
// }
// try {
//
//   if (!canIUse('SystemCapability.FileManagement.File.Environment.FolderObtain')) {
//     console.error('this api is not supported on this device');
//     return;
//   }
//
//   // 文件路径
//   const filePath = 'file://docs/storage/Users/currentUser/Documents/DocumentViewPicker01.txt';
//
//   // 要写入的内容
//   const content = "这是要写入文件的内容";
//   //  let filePath = pathDir + "/test.txt";
//
//   let file = fs.openSync(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
//   let str: string = "hello, world";
//   let writeLen = fs.writeSync(file.fd, str);
//   console.info("write data to file succeed and size is:" + writeLen);
//   fs.closeSync(file);
//   // 写入文件
//   //  await fs.writeSync(filePath, content);
//
//   console.log('文件写入成功');
// } catch (err) {
//   console.error('文件写入失败:', err);
// }

// try {
//
//   let documentSaveOptions = new picker.DocumentSaveOptions();
//   documentSaveOptions.newFileNames = ['DocumentViewPicker01.txt'];
//   let documentPicker = new picker.DocumentViewPicker(getContext(this));
//   documentPicker.save(documentSaveOptions).then((documentSaveResult: Array<string>) => {
//     console.info('DocumentViewPicker.save successfully, documentSaveResult uri: ' +
//     JSON.stringify(documentSaveResult));
//   }).catch((err: BusinessError) => {
//     console.error('DocumentViewPicker.save failed with err: ' + JSON.stringify(err));
//   });
// } catch (error) {
//   let err: BusinessError = error as BusinessError;
//   console.error('DocumentViewPicker failed with err: ' + JSON.stringify(err));
// }
// assetQuery()


// try {
//   //let pathDir = Environment.getUserDocumentDir();
//   ///storage/Users/currentUser/Documents
//   let filePath = "/storage/Users/currentUser/Documents/test.txt"
//   //pathDir + "/test.txt";
//   let file = fs.openSync(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
//   let str: string = "hello, world";
//   let writeLen = fs.writeSync(file.fd, str);
//   console.info("write data to file succeed and size is:" + writeLen);
//   fs.closeSync(file);
// } catch (error) {
//   console.error(`failed to getUserDocumentDir, Error code: ${error.code}, message: ${error.message}`);
// }

//DatabaseHelper.getInstance().restore(getContext(this))
//todo db操作 await
// 获取应用文件路径
//const documentsPath = Environment.getUserDocumentDir();
//let pubDir = "/storage/media/100/local/files"


// 直接拼接路径

//let context = getContext(this) as common.UIAbilityContext;
// let filesDir = context.filesDir;
// let dbDir = context.databaseDir + "/rdb/dbdir"
// let listFileOption: ListFileOptions = {
//   recursion: false,
//   // listNum: 0,
//   filter:
//   {
//     displayName: ["bill*"],
//     fileSizeOver: 0
//   }
//   // filter: {
//   //   suffix: [".png", ".jpg", ".txt"],
//   //   displayName: ["test*"],
//
//   //   lastModifiedAfter: new Date(0).getTime()
//   // }
// };


//
// let files = fs.listFileSync(dbDir, listFileOption);
// for (let i = 0; i < files.length; i++) {
//   console.info(`The name of file: ${files[i]}`);
// }
// //const bundleName = context.abilityInfo.bundleName;
// //const dbPath = `/data/app/el2/100/database/${bundleName}/entry/rdb`;
// //console.log(`数据库路径: ${dbPath}`);
//
// try {
//   let documentSaveOptions = new picker.DocumentSaveOptions();
//   documentSaveOptions.newFileNames = ['DocumentViewPicker01.txt'];
//   let documentPicker = new picker.DocumentViewPicker(context);
//   documentPicker.save(documentSaveOptions).then((documentSaveResult: Array<string>) => {
//     console.info('DocumentViewPicker.save successfully, documentSaveResult uri: ' +
//     JSON.stringify(documentSaveResult));
//   }).catch((err: BusinessError) => {
//     console.error(`DocumentViewPicker.save failed with err, code is: ${err.code}, message is: ${err.message}`);
//   });
// } catch (error) {
//   let err: BusinessError = error as BusinessError;
//   console.error(`DocumentViewPicker failed with err, code is: ${err.code}, message is: ${err.message}`);
// }


// try {
//
//
//   //  const getUserDesktopDir = Environment.getUserDesktopDir();
//   let documentPicker = new picker.DocumentViewPicker(context);
//
//   // const downloadPath = Environment.getUserDownloadDir();
//   // console.info(`success to getUserDownloadDir: ${downloadPath}`);
//   const documentsPath = Environment.getUserDocumentDir();
//   console.info(`success to getUserDocumentDir: ${documentsPath}`);
//
//   let file = fs.openSync(documentsPath + '/test.txt', fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
//   // 写入一段内容至文件
//   let writeLen = fs.writeSync(file.fd, "Try to write str.");
//   console.info("The length of str is: " + writeLen);
// } catch (error) {
//   const err: BusinessError = error as BusinessError;
//   console.error(`failed to get user dir, Error code: ${err.code}, message: ${err.message}`);
// }

//this.isProcessing = false


// try {
//   let DocumentSelectOptions = new picker.DocumentSelectOptions();
//   let documentPicker = new picker.DocumentViewPicker();
//   documentPicker.select(DocumentSelectOptions, (err, DocumentSelectResult) => {
//     if (err) {
//       console.error('DocumentViewPicker.select failed with err: ' + err);
//       return;
//     }
//
//     try {
//
//
//       let path = DocumentSelectResult[0]
//
//       let readTextOptions: ReadTextOptions = {
//         encoding: 'utf-8'
//       };
//
//       let stat = fs.statSync(path);
//       // readTextOptions.length = stat.size;
//
//       //let file = fs.openSync(path, fs.OpenMode.READ_WRITE);
//       let file = fs.openSync(path, fs.OpenMode.READ_WRITE);
//       let buf = new ArrayBuffer(stat.size);
//       fs.readSync(file.fd, buf);
//       fs.closeSync(file);
//       let str = ArrayBuffer.toString()
//       //let str = fs.readTextSync(path, readTextOptions);
//       let parsedObj: BillDbRecord[] = JSON.parse(str)
//       console.info("readText succeed:" + str);
//     } catch (error) {
//       console.error(`mylogfailed   , Error code: ${error.code}, message: ${error.message}`);
//     }
//
//
//   });
// } catch (err) {
//   console.error('DocumentViewPicker failed with err: ' + err);
// }
