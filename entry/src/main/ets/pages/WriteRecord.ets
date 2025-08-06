import {
  formatFen,
  getDayIncomeSum,
  getDayOutcomeSum,
  getIconCategoryBackcolor,
  getMonthBoundaries,
  groupRecordItemInfoByTimestamp
} from '../utils/Util'
import { router } from '@kit.ArkUI'
import { DatabaseHelper } from '../utils/DatabaseHelper'
import { BillTypeEnum, RecordItemInfo } from '../models/RecordList'
import CategoryMapSingleton from '../models/CategoryMapSingleton'
import { RoundImage } from './RoundImage'
import { PreferenceStore } from '../utils/PreferenceStore'
import { emitter } from '@kit.BasicServicesKit'
import { MonthPicker } from '../components/MonthPicker'
import { BizConstants } from '../utils/BizConstants'


@Preview
@Entry
@Component
struct WriteRecord {
  @State
  searchTotalIncome: number = 0
  @State
  searchTotalOutcome: number = 0
  @State
  searchText: string = ""
  @State
  groupedRecordList: Map<string, RecordItemInfo[]> = new Map();
  @State
  groupedRecordListBackup: Map<string, RecordItemInfo[]> = new Map();
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
  monthBudget: number = 0;
  @State
  monthBudgetRemain: number = 0;
  @State
  monthBudgetInputText: string = "";
  @State
  isShowBudgetSheet: boolean = false;

  searchBill(searchText: string) {

    if (searchText === "") {
      this.loadMonthData(this.currentMonthBegin);
      return
    }

    this.loadMonthData(this.currentMonthBegin);

    let totalOutCome = 0
    let totalInCome = 0
    let map: Map<string, RecordItemInfo[]> = new Map();

    this.groupedRecordList.forEach((value, key) => {

      value.forEach((item) => {

        let valid: boolean = false
        if (item.notes.includes(searchText)) {
          valid = true
        } else if (item.category_name.includes(searchText)) {
          valid = true
        } else {
          let tempSearchAmount = Number(searchText)
          if (!Number.isNaN(tempSearchAmount)) {
            tempSearchAmount = Math.round(tempSearchAmount * 100)
            if (item.amount >= tempSearchAmount) {
              valid = true
            }
          }
        }

        if (valid) {
          if (map.get(key) === undefined) {
            map.set(key, [])
          }
          map.get(key)?.push(item)

          if (item.bill_type === BillTypeEnum.Outcome) {
            totalOutCome += item.amount
          } else if (item.bill_type === BillTypeEnum.Income) {
            totalInCome += item.amount
          }
        }

      })
    })


    this.groupedRecordList = map
    this.searchTotalOutcome = totalOutCome
    this.searchTotalIncome = totalInCome


  }

  loadMonthData(monthDate: Date) {

    let dayPair = getMonthBoundaries(monthDate)
    let allItems: RecordItemInfo[] =
      DatabaseHelper.getInstance()
        .getBillRecordMonth(BizConstants.Default_bill_book_id, dayPair.begin.getTime(), dayPair.end.getTime());

    allItems.forEach((item: RecordItemInfo) => {

      try {
        item.category_image =
          $r(CategoryMapSingleton.getInstance().get(item.category_name, item.bill_type)!.category_image)
      } catch (e) {

        console.log("mylog", e)
      }


    }
    )

    let outcomeSumData =
      DatabaseHelper.getInstance()
        .getMonthSum(BizConstants.Default_bill_book_id, dayPair.begin.getTime(), dayPair.end.getTime(),
          BillTypeEnum.Outcome);
    if (outcomeSumData.length > 0) {
      this.currentMonthOutcome = outcomeSumData[0].amount
    } else {
      this.currentMonthOutcome = 0
    }

    let incomeSumData =
      DatabaseHelper.getInstance()
        .getMonthSum(BizConstants.Default_bill_book_id, dayPair.begin.getTime(), dayPair.end.getTime(),
          BillTypeEnum.Income);

    if (incomeSumData.length > 0) {
      this.currentMonthIncome = incomeSumData[0].amount
    } else {
      this.currentMonthIncome = 0;
    }

    this.currentMonthSaved = this.currentMonthIncome - this.currentMonthOutcome;
    this.groupedRecordList = groupRecordItemInfoByTimestamp(allItems);
  }

  aboutToAppear(): void {

    // 订阅
    emitter.on(PreferenceStore.emit_budget, () => {
      this.getBudgetFromStore()
    })

    emitter.on(BizConstants.Month_reload_data_key, () => {
      this.loadMonthData(this.currentMonthBegin)
    }
    )

    this.currentMonthBegin = new Date()
    this.loadMonthData(this.currentMonthBegin);

    this.getBudgetFromStore()


  }

  updateMonthData(yearPicked: string, monthPicked: string) {

    let yearNumber = Number(yearPicked.substring(0, yearPicked.length - 1));
    let monthNumber = Number(monthPicked.substring(0, monthPicked.length - 1)) - 1;

    if (!Number.isNaN(yearNumber) && !Number.isNaN(monthNumber)) {
      this.currentMonthBegin = new Date(yearNumber, monthNumber, 1)
      this.loadMonthData(this.currentMonthBegin);
      this.getBudgetFromStore()
    }

  }

  @Builder
  BudgetSheetBuilder() {
    Column({ space: 10 }) {

      Row({ space: 5 }) {
        Text("￥")
        TextInput({
          placeholder: "请输入本月预算",
          text: $$this.monthBudgetInputText
        }
        ).defaultFocus(true)
          .type(InputType.Number)
          .maxLength(10)
          .layoutWeight(1)

      }.width("100%")
      //.backgroundColor(Color.Pink)
      .padding(10)

      Row() {
        Button("确定")
          .type(ButtonType.Normal)
          .backgroundColor(Color.Green)
          .borderRadius(8)
          .height(30)
          .width("100%")
          .onClick(() => {

            let tempNum = Number(this.monthBudgetInputText)

            //分单位
            this.monthBudget = isNaN(tempNum) ? 0 : tempNum * 100
            //emit 接收

            PreferenceStore.addMonthBudget(this.monthBudget)

            this.isShowBudgetSheet = false
          })

      }.width("100%")
      .padding(10)
      .justifyContent(FlexAlign.Center)

    }.width('100%').height(300)
    .padding(10)

    // .backgroundColor(Color.Pink)
  }

  build() {
    Column() {
      Column() {

        Row({ space: 10 }) {
          Text("基本帐本")
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor($r("app.color.text_primary"))
            .textAlign(TextAlign.Start)

          Search({
            value: $$this.searchText, placeholder: '输入类别/备注/金额',
          })
            .enableKeyboardOnFocus(false)
            .height(40)//.backgroundColor('#F5F5F5')//.placeholderColor(Color.Grey)

            .placeholderFont({ size: 14, weight: 400 })
            .textFont({ size: 14, weight: 400 })
            .onSubmit((value: string) => {

              console.log("mylog", "submit", value)
              //this.searchBill(value)

            })

            .onWillInsert((insertVal: InsertValue) => {

              if (this.searchText.length >= BizConstants.Max_Search_char_count) {
                return false
              } else {
                return true
              }
            }
            )

            .onChange((value: string) => {

              console.log("mylog", "change", value)
              this.searchBill(this.searchText)

              if (value === "") {

                this.getUIContext().getFocusController().clearFocus()
              }

            })
            .layoutWeight(1)
        }
        .padding(
          {
            left: 10,
            right: 10
          }
        )
        .width("100%")
        .justifyContent(FlexAlign.SpaceBetween)
        .height(40)

      }.width("100%")
      .padding(
        {
          left: 10,
          right: 10,
          top: 10,
          bottom: 10
        }
      )
      .backgroundColor($r("app.color.back_color"))


      //第一节

      if (this.searchText === "") {
        Column() {

          Column({ space: 10 }) {


            Row({
              space: 0
            }) {

              //月份选择
              MonthPicker(
                {
                  currentMonthBegin: this.currentMonthBegin,
                  updateMonthData: (yearPicked, monthPicked) => {
                    this.updateMonthData(yearPicked, monthPicked)
                  }
                }
              )
            }


            //行1
            Row({ space: 10 }) {
              Row() {

                Text("￥" + (this.currentMonthOutcome / 100).toFixed(2))
                  .fontSize(18).fontWeight(FontWeight.Bold)
                  .fontColor($r("app.color.danger"))
              }.layoutWeight(1)

              Row() {


                Text("本月收入:")
                  .fontSize(16)
                Text((this.currentMonthIncome / 100).toFixed(2))
                  .fontSize(14).fontWeight(FontWeight.Bold)
                  .fontColor(Color.Green)

              }.layoutWeight(1)

            }
            .width("100%")

            //行2
            Row({ space: 10 }) {
              Row() {

                Text("预算剩余:")
                  .fontSize(16)
                Text(this.monthBudget === 0 ? "未设置预算" : (this.monthBudgetRemain / 100).toFixed(2))
                  .fontSize(14).fontWeight(FontWeight.Bold)


              }.layoutWeight(1)
              .onClick(() => {

                this.isShowBudgetSheet = !this.isShowBudgetSheet
              })
              .bindSheet($$this.isShowBudgetSheet, this.BudgetSheetBuilder(), {
                detents: [SheetSize.MEDIUM],
                preferType: SheetType.CENTER,
                title: { title: "设置预算" },
              })


              Row() {

                Text("本月结余:")
                  .fontSize(16)
                Text("" + (this.currentMonthSaved / 100).toFixed(2))
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

      } else {
        //搜索后
        Row({ space: 20 }) {
          Text("总支出:" + (this.searchTotalOutcome / 100).toFixed(2))
            .fontColor($r("app.color.danger"))
            .fontWeight(FontWeight.Bold)
            .fontSize(16)

          Text("总收入:" + (this.searchTotalIncome / 100).toFixed(2))
            .fontColor(Color.Green)
            .fontWeight(FontWeight.Bold)
            .fontSize(16)
        }.width("100%")
        .justifyContent(FlexAlign.Start)
        .padding(
          {
            left: 40,
            top: 10
          }
        )

      }

      //列表

      Column() {


        Stack() {
          List() {


            ForEach(Array.from(this.groupedRecordList.keys()), (itemKey: string) => {
              ListItem() {

                //表头
                Column() {
                  Row() {
                    Text(itemKey)
                      .fontColor($r("app.color.text_second"))
                      .fontSize(14)
                    Text("支出:" + (getDayOutcomeSum(this.groupedRecordList.get(itemKey)) / 100).toFixed(2))
                      .fontColor($r("app.color.text_second"))
                      .fontSize(14)
                    Text("收入:" + (getDayIncomeSum(this.groupedRecordList.get(itemKey)) / 100).toFixed(2))
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

                        Column() {
                          Text(item.category_name)
                            .fontSize(16)
                          Text(item.notes)
                            .textOverflow(
                              {
                                overflow: TextOverflow.Ellipsis
                              }
                            )
                            .width(120)//  .backgroundColor(Color.Pink)
                            .maxLines(1)
                            .fontSize(14)
                            .fontColor($r("app.color.text_second"))
                        }.alignItems(HorizontalAlign.Start)

                        // .backgroundColor(Color.Orange)

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


                      }
                      .layoutWeight(1)
                      // .backgroundColor(Color.Pink)

                      .alignItems(HorizontalAlign.End)

                      .padding(
                        {
                          top: 10,
                          right: 10,
                          bottom: 10
                        }
                      )

                    }.justifyContent(FlexAlign.SpaceBetween)
                    .width("100%")
                    .onClick(() => {

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

            }
            )
          }
          .alignListItem(ListItemAlign.Start)
          .width("100%")
          .height("100%")
          .backgroundColor($r("app.color.white"))
          //.backgroundColor(Color.Pink)
          .borderRadius(5)
          .scrollBar(BarState.Off)

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

        }.width("100%")
        .height("100%")
        .alignContent(Alignment.Bottom)

      }
      .padding(
        {
          left: 10,
          top: 10,
          right: 10,
          bottom: 10
        }
      ).layoutWeight(1)

    }
    .width("100%")
    .height("100%")
    .backgroundColor($r("app.color.back_color"))
  }

  private getBudgetFromStore() {
    this.monthBudget = PreferenceStore.getMonthBudget()
    this.monthBudgetInputText = (this.monthBudget / 100).toString();
    this.monthBudgetRemain = this.monthBudget + this.currentMonthSaved
  }
}

export default WriteRecord
