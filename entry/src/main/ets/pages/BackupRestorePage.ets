import { BackHeader } from '../components/RenderItem';
import { router } from '@kit.ArkUI';
import { fileIo as fs, picker } from '@kit.CoreFileKit';
import { BusinessError, emitter, systemDateTime } from '@kit.BasicServicesKit';
import { DatabaseHelper } from '../utils/DatabaseHelper';
import { taskpool, util } from '@kit.ArkTS';
import { BillDbRecord } from '../models/RecordList';
import { BizConstants } from '../utils/BizConstants';
import { mockBillRecords } from '../utils/Util';
import CategoryMapSingleton from '../models/CategoryMapSingleton';
import dayjs from 'dayjs';

// function stringToArray(str: string): Uint8Array {
//   let textEncoder = new util.TextEncoder();
//   return textEncoder.encodeInto(str);
// }

@Concurrent
async function mockInsertBills(context: Context): Promise<number> {
  await DatabaseHelper.getInstance().initDatabase(context)
  CategoryMapSingleton.getInstance().initializeMap()
  let billRecords: BillDbRecord[] = mockBillRecords(2025, 10, 12, 3, 5000, 1)

  for (let billRecord of billRecords) {
    DatabaseHelper.getInstance().insertOneBill(billRecord)
  }

  return billRecords.length

}

@Entry
@Component
struct BackupRestorePage {
  @State
  isProcessing: boolean = false

  async restore() {

    try {

      let documentSelectOptions = new picker.DocumentSelectOptions();

      let documentPicker = new picker.DocumentViewPicker(getContext(this));
      documentPicker
        .select(documentSelectOptions).then(async (documentSelectResult: Array<string>) => {
        console.info('DocumentViewPicker.select successfully, documentSelectResult uri: ' +
        JSON.stringify(documentSelectResult));

        try {
          this.isProcessing = true
          let startTime = systemDateTime.getTime(false)

          if (documentSelectResult.length > 0) {
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

            //await mockLongTime(10 * 1000)

            emitter.emit(BizConstants.Month_reload_data_key)
            emitter.emit(BizConstants.Report_reload_data_key)

            // mylog restore data cost：1405 ms ,fileContent length:43283
            let duration = systemDateTime.getTime(false) - startTime
            console.log(`mylog restore data cost：${duration} ms ,fileContent length:${str.length} `);

          }

          this.isProcessing = false
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

  // async requestMediaPermission() {
  //   let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
  //   let context: Context = getContext(this) as common.UIAbilityContext;
  //   atManager.requestPermissionsFromUser(context, ['ohos.permission.WRITE_MEDIA'],
  //     (err: BusinessError, data: PermissionRequestResult) => {
  //       if (err) {
  //         console.error(`requestPermissionsFromUser fail, err->${JSON.stringify(err)}`);
  //       } else {
  //         console.info('data:' + JSON.stringify(data));
  //         console.info('data permissions:' + data.permissions);
  //         console.info('data authResults:' + data.authResults);
  //         console.info('data dialogShownResults:' + data.dialogShownResults);
  //       }
  //     });
  // }

  backupData() {


    try {
      let documentSaveOptions = new picker.DocumentSaveOptions();

      let fileName = "备份" + dayjs(new Date()).format("YYYYMMDDHHmmss") + ".json"
      documentSaveOptions.newFileNames = [fileName];
      let documentPicker = new picker.DocumentViewPicker(getContext(this));
      documentPicker.save(documentSaveOptions).then((documentSaveResult: Array<string>) => {
        console.info('DocumentViewPicker.save successfully, documentSaveResult uri: ' +
        JSON.stringify(documentSaveResult));

        let path = documentSaveResult[0]

        if (path !== undefined) {

          this.isProcessing = true
          let startTime = systemDateTime.getTime(false)
          let allRecord = DatabaseHelper.getInstance().getAllBillRecord()

          let fileContent = JSON.stringify(allRecord)

          let file = fs.openSync(path, fs.OpenMode.READ_WRITE);
          fs.writeSync(file.fd, fileContent)

          let duration = systemDateTime.getTime(false) - startTime
          //mylog save export file cost：7 ms ,fileContent length:43283
          console.log(`mylog save export file cost：${duration} ms ,fileContent length:${fileContent.length} `);

        }
        this.isProcessing = false

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
              .fontSize(20)
              .backgroundColor(Color.Transparent)
              .borderRadius(8)
              .onClick(() => {
                this.backupData()
              })
              .enabled(!this.isProcessing)

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
              .fontSize(20)
              .backgroundColor(Color.Transparent)
              .borderRadius(8)
              .onClick(() => {
                this.restore()
              })
              .enabled(!this.isProcessing)

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


          Column({ space: 10 }) {

            Text("1.升级或者重装之前备份为文件").fontSize(18)
              .width("100%")
            Text("2.升级或者重装之后从备份文件中恢复").fontSize(18)
              .width("100%")

          }.backgroundColor($r("app.color.white"))
          .borderRadius(8)
          .padding(10)


          Button("模拟生成帐单数据")
            .onClick(async () => {

              this.isProcessing = true
              const startTime = systemDateTime.getTime(false);

              let count = await taskpool.execute(new taskpool.Task(mockInsertBills,
                getContext(this)))

              let duration = systemDateTime.getTime(false) - startTime
              console.log(`mylog taskpool    cost：${duration} ms ,count:${count} `);

              this.isProcessing = false
            })
            .visibility(Visibility.Visible)


        }
        .width("100%")
        .padding(10)

      }
      .height('100%')
      .width('100%')
      .backgroundColor($r('app.color.back_color'))
    }
  }
}