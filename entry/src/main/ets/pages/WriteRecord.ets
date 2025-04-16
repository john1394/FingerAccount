import {
  formatFen,
  getDayIncomeSum,
  getDayOutcomeSum,
  getIconCategoryBackcolor,
  getMonthBoundaries,
  groupRecordItemInfoByTimestamp
} from '../utils/Util'
import { promptAction, router } from '@kit.ArkUI'
import { DatabaseHelper } from '../utils/DatabaseHelper'
import { BillTypeEnum, RecordItemInfo } from '../models/RecordList'
import CategoryMapSingleton from '../models/CategoryMapSingleton'
import { RoundImage } from './RoundImage'


@Preview
@Entry
@Component
struct WriteRecord {
  @State
  recordList: RecordItemInfo[] = []
  @State
  groupedRecordList: Map<string, RecordItemInfo[]> = new Map();
  @State
  firstAppear: boolean = false
  @State
  currentMonthBegin: Date = new Date();
  @State
  currentMonthIncome: number = 0;
  @State
  currentMonthOutcome: number = 0;
  @State
  currentMonthSaved: number = 0;
  @State
  currentMonthBudget: number = 0;

  loadAllData() {

    let dayPair = getMonthBoundaries(this.currentMonthBegin)

    let allItems: RecordItemInfo[] =
      DatabaseHelper.getInstance().getBillRecordMonth(dayPair.begin.getTime(), dayPair.end.getTime());
    //DatabaseHelper.getInstance().getAllBillRecord();

    allItems.forEach((item: RecordItemInfo) => {

      item.category_image =
        $r(CategoryMapSingleton.getInstance().get(item.category_name, item.bill_type)!.category_image)
      //$r("app.media.ic_edit")
    }
    )

    let outcomeSumData =
      DatabaseHelper.getInstance()
        .getMonthSum(dayPair.begin.getTime(), dayPair.end.getTime(), BillTypeEnum.Outcome);
    if (outcomeSumData.length > 0) {
      this.currentMonthOutcome = outcomeSumData[0].amount
    }

    let incomeSumData =
      DatabaseHelper.getInstance()
        .getMonthSum(dayPair.begin.getTime(), dayPair.end.getTime(), BillTypeEnum.Income);

    if (incomeSumData.length > 0) {
      this.currentMonthIncome = incomeSumData[0].amount
    }

    this.currentMonthSaved = this.currentMonthIncome - this.currentMonthOutcome;


    //this.recordList = allItems;

    this.groupedRecordList = groupRecordItemInfoByTimestamp(allItems);


  }

  aboutToAppear(): void {
    this.loadAllData();

    // if(!this.firstAppear) {
    //   this.firstAppear = true
    //
    // }

  }

  build() {
    Column() {
      Column() {
        Row() {
          Stack({ alignContent: Alignment.End }) {
            Text("指尖记帐")
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor($r("app.color.text_primary"))
              .width("100%")
              .textAlign(TextAlign.Start)


            Image($r("app.media.search_24dp_1F1F1F"))
              .width(20)
              .height(20)//.fillColor($r("app.color.white"))
              .margin({
                right: 30
              })

          }
          .width("100%")

        }
        .padding(
          {
            left: 20
          }
        )
        .width("100%")
        .justifyContent(FlexAlign.End)
        .height(40)

      }.width("100%")
      //.backgroundColor($r("app.color.start_window_background"))
      //.backgroundColor("#fff")
      .backgroundColor($r("app.color.second_back_color"))

      Column()
        .height(10)
        .width("100%")


      //第一节
      Column() {

        Column({ space: 10 }) {


          Row() {
            Text("X月支出")
              .fontSize(16)

            Image($r("sys.media.ohos_ic_public_arrow_down"))
              .width(24)
              .height(24)
          }.width("100%")
          .height(40)

          //行1
          Row({ space: 10 }) {
            Row() {

              Text("本月支出:")
                .fontSize(16)
                .fontColor($r("app.color.text_primary"))
              Text("￥" + Math.round(this.currentMonthOutcome / 100).toFixed(2))
                .fontSize(18).fontWeight(FontWeight.Bold)
            }.layoutWeight(1)

            Row() {


              Text("本月收入:")
                .fontSize(16)
              Text(Math.round(this.currentMonthIncome / 100).toFixed(2))
                .fontSize(14).fontWeight(FontWeight.Bold)
                .fontColor($r("app.color.text_second"))

            }.layoutWeight(1)

          }
          .width("100%")

          //行2
          Row({ space: 10 }) {
            Row() {

              Text("预算剩余:")
                .fontSize(16)
              Text("" + this.currentMonthBudget)
                .fontSize(14).fontWeight(FontWeight.Bold)

            }.layoutWeight(1)
            .onClick(() => {
              AlertDialog.show(
                {
                  message: "编辑预算"
                }
              )
            })

            Row() {

              Text("本月结余:")
                .fontSize(16)
              Text("" + Math.round(this.currentMonthSaved / 100).toFixed(2))
                .fontSize(14).fontWeight(FontWeight.Bold)

            }.layoutWeight(1)

          }.width("100%")

        }
        .borderRadius(5)
        .height("100%")
        .width("100%")
        .backgroundColor($r("app.color.white"))
        .padding(
          {
            left: 10,
            top: 10,
            right: 10,
            bottom: 10
          }
        )

      }
      .height(140)
      .width("100%")
      .padding(
        {
          left: 10,
          right: 10,
          top: 10,
          bottom: 10
        }
      )
      .backgroundColor($r("app.color.back_color"))

      //第2节
      // Column() {
      //
      //   Column() {
      //
      //
      //     Row() {
      //
      //       Text("今日支出:")
      //         .fontSize(16)
      //         .fontColor($r("app.color.text_primary"))
      //       Text("￥100.00")
      //         .fontSize(18).fontWeight(FontWeight.Bold)
      //
      //
      //     }.width("100%")
      //
      //     Row() {
      //
      //       Text("今日收入:")
      //         .fontSize(16)
      //       Text("￥200.00")
      //         .fontSize(18).fontWeight(FontWeight.Bold)
      //         .fontColor($r("app.color.text_second"))
      //
      //     }.width("100%")
      //     .margin(
      //       {
      //         top: 10
      //       }
      //     )
      //
      //   }
      //   .borderRadius(5)
      //   .height("100%")
      //   .width("100%")
      //   .backgroundColor($r("app.color.white"))
      //   .padding(
      //     {
      //       left: 10,
      //       top: 10,
      //       right: 10,
      //       bottom: 10
      //     }
      //   )
      //
      // }
      // .height(100)
      // .width("100%")
      // .padding(
      //   {
      //     left: 10,
      //     right: 10,
      //     top: 10,
      //     bottom: 10
      //   }
      // )
      // .backgroundColor($r("app.color.back_color"))


      //列表

      Column() {


        List() {


          ForEach(Array.from(this.groupedRecordList.keys()), (itemKey: string) => {
            ListItem() {

              //表头
              Column() {
                Row() {
                  Text(itemKey)
                    .fontColor($r("app.color.text_second"))
                    .fontSize(14)
                  Text("支出:" + Math.round(getDayOutcomeSum(this.groupedRecordList.get(itemKey)) / 100).toFixed(2))
                    .fontColor($r("app.color.text_second"))
                    .fontSize(14)
                  Text("收入:" + Math.round(getDayIncomeSum(this.groupedRecordList.get(itemKey)) / 100).toFixed(2))
                    .fontColor($r("app.color.text_second"))
                    .fontSize(14)
                }.width("100%")
                .height(30)
                //.backgroundColor(Color.Pink)
                .backgroundColor($r("app.color.back_color"))
                .justifyContent(FlexAlign.SpaceAround)

                //分组下的子行
                ForEach(this.groupedRecordList.get(itemKey), (item: RecordItemInfo) => {
                  Row({ space: 10 }) {

                    Row() {

                      RoundImage(
                        {
                          contentWidth: 30,
                          imageUrl: item.category_image,
                          backColor:
                          getIconCategoryBackcolor(item, item.category_name)
                        }
                      ).margin(
                        {
                          left: 10,
                          right: 10
                        }
                      )

                      Text(item.category_name)
                        .fontSize(16)
                    }.justifyContent(FlexAlign.Start)
                    .padding(
                      {
                        left: 10,
                        top: 10,
                        right: 10,
                        bottom: 10
                      }
                    )

                    //右侧块
                    Column() {
                      Text((item.bill_type == BillTypeEnum.Income ? "+" : "-") + `￥${formatFen(item.amount)}`)
                        .margin(
                          {
                            bottom: 10
                          }
                        )
                        .textAlign(TextAlign.End)
                        .fontWeight(FontWeight.Bold)// .backgroundColor(Color.Pink)
                        .fontColor(item.bill_type == BillTypeEnum.Income ? Color.Green :
                        $r("app.color.danger"))//"//.text_primary"))
                        .fontSize(14)


                    }.width(120)
                    .alignItems(HorizontalAlign.End)

                    .padding(
                      {
                        top: 10,
                        right: 10,
                        bottom: 10
                      }
                    )

                    // .backgroundColor(Color.Red)


                  }.justifyContent(FlexAlign.SpaceBetween)
                  .width("100%")
                  .onClick(() => {

                    promptAction.showToast(
                      {
                        message: "detail"
                      }
                    )
                    router.pushUrl(
                      {
                        url: "pages/BillDetail",
                        params: item
                      }
                    )

                  })
                }
                )


              }
              .width("100%")

            }

            //.backgroundColor(Color.Yellow)


          }
          )
        }.alignListItem(ListItemAlign.Start)
        .backgroundColor($r("app.color.white"))
        //.backgroundColor(Color.Pink)
        .borderRadius(5)
        .scrollBar(BarState.Off)

      }
      .padding(
        {
          left: 10,
          top: 10,
          right: 10,
          bottom: 10
        }
      ).layoutWeight(1)

      //底部加号按钮

      Row({ space: 8 }) {
        Image($r("app.media.edit_48dp_FFFFFF"))
          .width(24)
          .height(24)// .backgroundColor($r("app.color.white"))

          .margin(
            {
              left: 10,
              top: 10,
              right: 0,
              bottom: 10
            }
          )

        Text("记一笔").fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor($r("app.color.white"))
      }
      .width(110)
      .height(38)
      .borderRadius(8)
      .backgroundColor(Color.Green)
      .margin(
        {
          bottom: 10
        }
      )
      .onClick(() => {
        router.pushUrl(
          {
            url: "pages/EditAccount",
            params: "params"
          }

        )

      })

    }
    .width("100%")
    .height("100%")
    .backgroundColor($r("app.color.back_color"))
  }
}

export default WriteRecord