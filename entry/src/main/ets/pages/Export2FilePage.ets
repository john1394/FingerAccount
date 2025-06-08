import { BackHeader } from '../components/RenderItem';
import { router } from '@kit.ArkUI';
import { fileIo as fs, picker } from '@kit.CoreFileKit';
import { BusinessError, emitter, systemDateTime } from '@kit.BasicServicesKit';
import { DatabaseHelper } from '../utils/DatabaseHelper';
import { util } from '@kit.ArkTS';
import { BillDbRecord } from '../models/RecordList';
import { BizConstants } from '../utils/BizConstants';
import dayjs from 'dayjs';
import { mockLongTime } from '../utils/Util';


@Entry
@Component
struct Export2FilePage {
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

            //await mockLongTime(10 * 1000)
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
            emitter.emit(BizConstants.Report_reload_data_key)

            // mylog restore data cost：1405 ms ,fileContent length:43283
            let duration = systemDateTime.getTime(false) - startTime
            console.log(`mylog restore data cost：${duration} ms ,fileContent length:${str.length} `);

          }

          this.isProcessing = false
        } catch (error1) {
          console.error(`mylogfailed   , Error code: ${error1.code}, message: ${error1.message}`);
          this.isProcessing = false
        }


      }).catch((err: BusinessError) => {
        console.error('DocumentViewPicker.select failed with err: ' + JSON.stringify(err));
        this.isProcessing = false
      });

    } catch (error) {
      let err: BusinessError = error as BusinessError;
      console.error('DocumentViewPicker failed with err: ' + JSON.stringify(err));
      this.isProcessing = false
    }


  }

  backupData() {


    try {
      let documentSaveOptions = new picker.DocumentSaveOptions();

      let fileName = "备份" + dayjs(new Date()).format("YYYYMMDDHHmmss") + ".json"
      documentSaveOptions.newFileNames = [fileName];
      let documentPicker = new picker.DocumentViewPicker(getContext(this));
      documentPicker.save(documentSaveOptions).then(async (documentSaveResult: Array<string>) => {
        console.info('DocumentViewPicker.save successfully, documentSaveResult uri: ' +
        JSON.stringify(documentSaveResult));

        let path = documentSaveResult[0]

        if (path !== undefined) {

          this.isProcessing = true
          await mockLongTime(300)
          let startTime = systemDateTime.getTime(false)
          let allRecord = DatabaseHelper.getInstance().getAllBillRecord()

          let fileContent = JSON.stringify(allRecord)

          let file = fs.openSync(path, fs.OpenMode.READ_WRITE);
          fs.writeSync(file.fd, fileContent)

          let duration = systemDateTime.getTime(false) - startTime
          //mylog save export file cost：7 ms ,fileContent length:43283
          console.log(`mylog save export file cost：${duration} ms ,fileContent length:${fileContent.length} `);

          AlertDialog.show(
            {
              message: "导出完成！",
            }
          )

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
            Button("导出为 json 文件", { type: ButtonType.Normal })
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


          if (this.isProcessing) {
            Row({ space: 10 }) {
              LoadingProgress().width(30).height(30)
              Text("正在处理中...")
                .fontSize(12)
                .fontColor($r("app.color.text_second"))
            }
          }


          // Column({ space: 10 }) {
          //
          //   Text("1.升级或者重装之前备份为文件").fontSize(18)
          //     .width("100%")
          //   Text("2.升级或者重装之后从备份文件中恢复").fontSize(18)
          //     .width("100%")
          //
          // }.backgroundColor($r("app.color.white"))
          // .borderRadius(8)
          // .padding(10)

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