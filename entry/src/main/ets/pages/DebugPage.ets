import { emitter, systemDateTime } from '@kit.BasicServicesKit'
import { taskpool } from '@kit.ArkTS'
import { DatabaseHelper } from '../utils/DatabaseHelper'
import CategoryMapSingleton from '../models/CategoryMapSingleton'
import { mockBillRecords } from '../utils/Util'
import { BillDbRecord } from '../models/RecordList'
import { BizConstants } from '../utils/BizConstants'

@Entry
@Component
struct DebugPage {
  @State
  isProcessing: boolean = false

  build() {
    Column() {

      Column() {
        Button("test")

        Button("模拟生成帐单数据")
          .onClick(async () => {

            this.isProcessing = true
            const startTime = systemDateTime.getTime(false);

            let count = await taskpool.execute(new taskpool.Task(mockInsertBills,
              getContext(this)))

            let duration = systemDateTime.getTime(false) - startTime
            console.log(`mylog taskpool    cost：${duration} ms ,count:${count} `);

            emitter.emit(BizConstants.Month_reload_data_key)
            emitter.emit(BizConstants.Report_reload_data_key)
            this.isProcessing = false
          })
          .visibility(Visibility.Visible)

        if (this.isProcessing) {
          Row({ space: 10 }) {
            LoadingProgress().width(30).height(30)
            Text("正在处理中...")
              .fontSize(12)
              .fontColor($r("app.color.text_second"))
          }
        }

      }.width("100%")
      .height("100%")

    }
    .padding(10)
    .height('100%')
    .width('100%')
  }
}

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