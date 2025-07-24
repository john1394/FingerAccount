import { BackHeader } from '../components/RenderItem';
import { router } from '@kit.ArkUI';
import { fileUri, fileIo as fs, picker } from '@kit.CoreFileKit';
import { BusinessError, emitter, systemDateTime } from '@kit.BasicServicesKit';
import { DatabaseHelper } from '../utils/DatabaseHelper';
import { taskpool, util } from '@kit.ArkTS';
import { BillDbRecord, BillTypeEnum } from '../models/RecordList';
import { BizConstants } from '../utils/BizConstants';
import dayjs from 'dayjs';
import { formatSimpleDate } from '../utils/Util';
// import ExcelJS from '@archermind/exceljs';
import { CSVWriter } from '@ohos/opencsv';

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

  async export2Json() {


    try {
      let documentSaveOptions = new picker.DocumentSaveOptions();

      let fileName = "导出_" + dayjs(new Date()).format("YYYYMMDDHHmmss") + ".json"
      documentSaveOptions.newFileNames = [fileName];
      let documentPicker = new picker.DocumentViewPicker(getContext(this));
      let documentSaveResult = await documentPicker.save(documentSaveOptions)
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
        AlertDialog.show(
          {
            message: "导出完成！",
          }
        )

      }

    } catch (error) {
      let err: BusinessError = error as BusinessError;
      console.error('DocumentViewPicker failed with err: ' + JSON.stringify(err));
    }


  }

  async export2Excel() {

    try {
      let documentSaveOptions = new picker.DocumentSaveOptions();

      let fileName = "export_" + dayjs(new Date()).format("YYYYMMDDHHmmss") + ".csv"
      documentSaveOptions.newFileNames = [fileName];
      let documentPicker = new picker.DocumentViewPicker(getContext(this));
      let documentSaveResult = await documentPicker.save(documentSaveOptions)

      let path = documentSaveResult[0]

      if (path !== undefined) {

        //await mockLongTime(300)
        this.isProcessing = true
        let startTime = systemDateTime.getTime(false)
        let allRecord = DatabaseHelper.getInstance().getAllBillRecord()

        //改为异步

        let savePath = new fileUri.FileUri(path).path
        await taskpool.execute(new taskpool.Task(record2Csv, allRecord, savePath))

        let duration = systemDateTime.getTime(false) - startTime
        //mylog save export file cost：7 ms ,fileContent length:43283
        console.log(`mylog save export file cost：${duration} ms ,allRecord count:${allRecord.length} `);


        animateTo({ duration: 300 }, () => {
          AlertDialog.show(
            {
              message: "导出操作完成!"
            }
          )

        })
      }

      this.isProcessing = false

    } catch (error) {
      let err: BusinessError = error as BusinessError;
      console.error('DocumentViewPicker failed with err: ' + JSON.stringify(err));
      this.isProcessing = false
    }
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
          Column({ space: 10 }) {
            Button("导出为 json 文件", { type: ButtonType.Normal })
              .width("100%")
              .height(36)
              .border({ width: 1, color: Color.Black })// 蓝色细边框
              .fontColor($r("app.color.text_primary"))
              .fontWeight(FontWeight.Medium)
              .fontSize(20)
              .backgroundColor(Color.Transparent)
              .borderRadius(8)
              .onClick(async () => {
                this.isProcessing = true
                await this.export2Json()
                this.isProcessing = false
              })
              .enabled(!this.isProcessing)
              .visibility(Visibility.None)

            Button("导出为 csv 文件", { type: ButtonType.Normal })
              .width("100%")
              .height(36)
              .border({ width: 1, color: Color.Black })// 蓝色细边框
              .fontColor($r("app.color.text_primary"))
              .fontWeight(FontWeight.Medium)
              .fontSize(20)
              .backgroundColor(Color.Transparent)
              .borderRadius(8)
              .onClick(async () => {
                this.isProcessing = true
                await this.export2Excel()

                console.log('mylog:', "after async call export2Excel");
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


        }
        .width("100%")
        .padding(10)

      }
      .height('100%')
      .width('100%')
      .backgroundColor($r('app.color.back_color'))
    }
  }

  pageTransition() {
    // 定义页面进入时的效果，从右侧滑入，时长为1000ms，页面栈发生push操作时该效果才生效
    PageTransitionEnter({ type: RouteType.Push, duration: 300 })
      .slide(SlideEffect.Right)
    // 定义页面进入时的效果，从左侧滑入，时长为1000ms，页面栈发生pop操作时该效果才生效
    PageTransitionEnter({ type: RouteType.Pop, duration: 300 })
      .slide(SlideEffect.Left)
    // 定义页面退出时的效果，向左侧滑出，时长为1000ms，页面栈发生push操作时该效果才生效
    PageTransitionExit({ type: RouteType.Push, duration: 300 })
      .slide(SlideEffect.Left)
    // 定义页面退出时的效果，向右侧滑出，时长为1000ms，页面栈发生pop操作时该效果才生效
    PageTransitionExit({ type: RouteType.Pop, duration: 300 })
      .slide(SlideEffect.Right)
  }
}


@Concurrent
async function record2Csv(billDbRecords: BillDbRecord[], filePath: string) {
  try {

    const file = fs.openSync(filePath, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE);

    let writer = new CSVWriter(file.fd);

    writer.writeNext(["ID", '帐本名称', '类别', '收支类型', '金额', '时间', '备注'], true)

    for (let billItem of billDbRecords) {

      writer.writeNext([
        billItem.id + "",
        billItem.bill_book_id === 1 ? "基本帐本" : "其它帐本",
        billItem.category,
        (billItem.bill_type === BillTypeEnum.Outcome) ? "支出" : "收入",
        (billItem.amount / 100).toFixed(2),

        formatSimpleDate(billItem.timestamp),

        billItem.notes
      ],
        true);

    }
    writer.close(); // 写入关闭

  } catch (error) {
    console.error("mylog", '文件保存失败:', error);
  }

}
