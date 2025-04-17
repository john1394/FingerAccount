import { ColumnData, PieData } from '../models/BillReportModel';

import { McLineChart, Options } from '@mcui/mccharts';
import {
  DayPair,
  formatDateYM1,
  formatDateYMD1,
  formatDateYMDHan,
  getDateDiffInDays,
  getMonthBoundaries,
  getWeekBoundaries,
  getYearBoundaries,
  roundAmountFen2Yuan,
  shiftMonth,
  shiftWeek,
  shiftYear
} from '../utils/Util';
import { DatabaseHelper } from '../utils/DatabaseHelper';
import { BillTypeEnum } from '../models/RecordList';
import { CategoryPieChart, PieDataController } from '../components/CategoryPieChart';
import { BizConstants } from '../utils/BizConstants';
import { CategoryTopList } from '../components/CategoryTopList';

const yAxisText: string = "元";

// @Preview
// @Entry
@Component
struct BillReport {
  pieDataController: PieDataController = new PieDataController();
  @State
  pieData: PieData[] = []
  @Prop
  dayBoundary: DayPair;
  @State
  fromBeginDateStr: string = "";
  @State
  lineOption: Options = new Options({})
  @Prop
  isOutput: boolean = true
  @State
  DateSelectBorderWidth: number = 3;
  @State columns: ColumnData[] = [
    new ColumnData('week', "周", true),
    new ColumnData('month', "月", false),
    new ColumnData('year', "年", false),
    new ColumnData('custom', "自定义", false),
  ];

  updateSelectColumn(selectedItem: ColumnData) {

    let newColumns: ColumnData[] = [];

    this.columns.forEach((item) => {
      if (item.uid === selectedItem.uid) {
        item.selected = true;
        //this.selectedColumn=item.uid;
      } else {
        item.selected = false;
      }

      newColumns.push(item);
    })

    this.columns = newColumns;

    //
    if (this.columns[0].selected) {
      this.dayBoundary = getWeekBoundaries(new Date());
      this.updateWeekData()
    } else if (this.columns[1].selected) {
      this.dayBoundary = getMonthBoundaries(new Date());
      this.updateMonthData();
    } else if (this.columns[2].selected) {
      this.dayBoundary = getYearBoundaries(new Date());
      this.updateYearData();
    }

    this.fromBeginDateStr = this.formatDayBoundary(this.dayBoundary);
  }

  shiftDate(left: boolean) {
    //todo 限制边界
    if (this.columns[0].selected) {
      this.dayBoundary = shiftWeek(this.dayBoundary, left);
      this.updateWeekData();
    } else if (this.columns[1].selected) {

      this.dayBoundary = shiftMonth(this.dayBoundary, left);
      this.updateMonthData();

    } else if (this.columns[2].selected) {
      this.dayBoundary = shiftYear(this.dayBoundary, left);
      this.updateYearData();
    }

    this.fromBeginDateStr = this.formatDayBoundary(this.dayBoundary);
  }

  aboutToAppear(): void {
    let currentDate = new Date();
    this.dayBoundary = getWeekBoundaries(currentDate);
    this.fromBeginDateStr = this.formatDayBoundary(this.dayBoundary);

    this.updateWeekData();
  }

  formatDayBoundary(boundary: DayPair) {
    //周,月 ，年

    return formatDateYMDHan(boundary.begin) + "-" + formatDateYMDHan(boundary.end);
  }

  build() {

    Column() {

      //第一行
      Column() {

        Row({ space: 10 }) {

          Column() {
            Text("支出")
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .margin(
                {
                  top: 10
                }
              )

            Column() {
            }
            .height("3vp")
            .width("56vp")
            .margin(
              {
                left: 10,
                right: 5,
                top: 5,
                bottom: 5
              }
            )
            .backgroundColor(this.isOutput ? Color.Black : Color.Transparent)
          }
          .height("100%")
          .alignItems(HorizontalAlign.Center)
          .justifyContent(FlexAlign.Center)
          //.backgroundColor(Color.Gray)
          .width("100%")
          .layoutWeight(1)
          .onClick(() => {
            this.isOutput = !this.isOutput
            this.updateReport()
          })


          Column() {
            Text("收入")
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .margin(
                {
                  top: 10
                }
              )

            Column() {
            }
            .height("3vp")
            .width("56vp")
            .margin(
              {
                left: 5,
                right: 10,
                top: 5,
                bottom: 5
              }
            )
            .backgroundColor(!this.isOutput ? Color.Black : Color.Transparent)
          }
          .height("100%")
          .alignItems(HorizontalAlign.Center)
          .justifyContent(FlexAlign.Center)
          //.backgroundColor(Color.Gray)
          .width("100%")
          .layoutWeight(1)
          .onClick(() => {
            this.isOutput = !this.isOutput
            this.updateReport()
          })

        }
        .width("150vp")
        .height("100%")
        //.backgroundColor(Color.Pink)
        .justifyContent(FlexAlign.Center)

        //.height("60vp")
      }.width("100%")
      .height("50vp")
      .alignItems(HorizontalAlign.Center)

      //.backgroundColor(Color.Orange)

      //第二行
      Row() {

        Row() {

          ForEach(this.columns, (item: ColumnData, index: number) => {

            Column() {
              Text(item.txt)
                .fontColor(item.getFontColor())
                .fontSize(20)
                .fontWeight(FontWeight.Normal)
            }
            .backgroundColor(item.getBackColor())
            .width("100%")
            .height("100%")
            .borderWidth(
              index != this.columns.length - 1 ? {
                left: this.DateSelectBorderWidth,
                top: this.DateSelectBorderWidth,
                bottom: this.DateSelectBorderWidth
              } :
                {
                  left: this.DateSelectBorderWidth,
                  top: this.DateSelectBorderWidth,
                  bottom: this.DateSelectBorderWidth,
                  right: this.DateSelectBorderWidth,
                }
            )
            .borderColor(Color.Black)
            .layoutWeight(1)
            .alignItems(HorizontalAlign.Center)
            .justifyContent(FlexAlign.Center)
            .onClick(() => {
              this.updateSelectColumn(item);
            })

          })


        }.width("100%")
        .height("100%")

      }.padding(
        {
          left: 10,
          right: 10,
          top: 10,
          bottom: 10
        }
      ).width("100%")
      .height(60)

      //第三行
      Row() {
        Column() {
          Image($r("app.media.arrow_circle_left_48dp_000000"))
            .width(40)
            .height(40)
        }.height("100%")
        .justifyContent(FlexAlign.Center)
        .layoutWeight(1)
        .onClick(() => {

          this.shiftDate(true);
        })


        Column() {
          Text(this.fromBeginDateStr)// Text("2025年03月")
            .fontSize(16)

        }.layoutWeight(4)


        Column() {
          Image($r("app.media.arrow_circle_right_48dp_000000"))
            .width(40)
            .height(40)
        }.height("100%")
        .justifyContent(FlexAlign.Center)
        .layoutWeight(1)
        .onClick(() => {

          this.shiftDate(false);
        })

      }
      .backgroundColor($r("app.color.back_color"))
      //.backgroundColor(Color.Pink)
      .width("100%")
      .alignItems(VerticalAlign.Center)
      .height(50)


      Scroll() {
        Column({ space: 10 }) {

          //第四行 折线图

          Column() {
            McLineChart({
              options: this.lineOption
            })
              .borderRadius(8)
              .backgroundColor($r("app.color.white"))
              .padding(
                {
                  left: 10,
                  right: 10,
                  bottom: 10,
                  top: 10
                }
              )
          }
          .height(240)
          .padding(10)


          //第五行 饼图
          Column() {
            CategoryPieChart
            (
              {
                controller: this.pieDataController,
                pieData: this.pieData
              }
            )
              .backgroundColor($r("app.color.white"))// .height(280)
              .borderRadius(8)
              .padding(10)
          }
          .width("100%")
          .height(280)
          .padding(10)
          .visibility(Visibility.Visible)


          //第6行 排行列表
          Column() {
            CategoryTopList()
              .backgroundColor($r("app.color.white"))// .backgroundColor(Color.Gray)
              .borderRadius(8)
          }
          .width("100%")
          .padding(10)

        }.width("100%")

        .padding(10)

        //.backgroundColor(Color.Pink)

      }
      // .backgroundColor(Color.Pink)
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.Off)
      .width("100%")
      //非常重要,解决了scroll不适应的问题!!!
      .layoutWeight(1)

    }
    .width("100%")
    .backgroundColor($r("app.color.back_color"))

  }

  private updateYearData() {
    let bill_type = this.isOutput ? BillTypeEnum.Outcome : BillTypeEnum.Income;
    let monthCount: number = 12

    let xData: string[] = []

    for (let i = 0; i < monthCount; i++) {
      xData.push((i + 1).toString() + "月");
    }

    let sumData =
      DatabaseHelper.getInstance()
        .getMonthSum(this.dayBoundary.begin.getTime(), this.dayBoundary.end.getTime(), bill_type);

    let map: Map<string, number> = new Map<string, number>();

    sumData.map(u => {
      map.set(u.timeBase, u.amount);
    });

    let yData: number[] = [];
    let i: number = 0;
    for (i = 0; i < monthCount; i++) {
      yData.push(0);
    }

    for (i = 0; i < monthCount; i++) {
      let dateItem: Date = new Date(this.dayBoundary.begin);
      dateItem.setMonth(dateItem.getMonth() + i);

      let dateStr = formatDateYM1(dateItem);
      if (map.has(dateStr)) {
        yData[i] = map.get(dateStr) ?? 0;
      }
    }

    let yShowNumber: number[] = []
    yData.forEach((item) => {
      yShowNumber.push(roundAmountFen2Yuan(item));
    })

    let yTitle = bill_type === BillTypeEnum.Outcome ? "支出金额" : "收入金额";
    this.lineOption.setVal({
      animation: false,
      series: [
        {
          name: yTitle,
          data: yShowNumber
        }
      ],
      yAxis: {
        name: yAxisText
      },
      xAxis:
      {
        data: xData
      , axisLabel:
      {
        interval: 1,
        fontSize: 36
      }
      }
    })

    //pie图
    this.updatePieData(bill_type)
  }

  private updateReport() {
    if (this.columns[0].selected) {
      this.updateWeekData()
    } else if (this.columns[1].selected) {
      this.updateMonthData();
    } else if (this.columns[2].selected) {
      this.updateYearData();
    }
  }

  private updateMonthData() {
    let bill_type = this.isOutput ? BillTypeEnum.Outcome : BillTypeEnum.Income;
    let dayCount: number = getDateDiffInDays(new Date(this.dayBoundary.begin.getTime())
      , new Date(this.dayBoundary.end.getTime()))

    let xData: string[] = []

    for (let i = 0; i < dayCount; i++) {
      xData.push(i.toString());
    }

    let sumData =
      DatabaseHelper.getInstance()
        .getDaySum(this.dayBoundary.begin.getTime(), this.dayBoundary.end.getTime(), bill_type);

    let map: Map<string, number> = new Map<string, number>();

    sumData.map(u => {
      map.set(u.timeBase, u.amount);
    });

    let yData: number[] = [];
    let i: number = 0;
    for (i = 0; i < dayCount; i++) {
      yData.push(0);
    }

    for (i = 0; i < dayCount; i++) {
      let dateItem: Date = new Date(this.dayBoundary.begin);
      dateItem.setDate(dateItem.getDate() + i);

      let dateStr = formatDateYMD1(dateItem);
      if (map.has(dateStr)) {
        yData[i] = map.get(dateStr) ?? 0;
      }
    }

    let yShowNumber: number[] = []
    yData.forEach((item) => {
      yShowNumber.push(roundAmountFen2Yuan(item));
    })

    let yTitle = (bill_type === BillTypeEnum.Outcome ? "支出金额" : "收入金额");
    this.lineOption.setVal({
      animation: false,
      series: [
        {
          name: yTitle,
          label:
          {
            fontSize: 36,
          },
          data: yShowNumber
        }
      ],
      yAxis: {
        name: yAxisText
      },
      xAxis:
      {
        data: xData
      , axisLabel:
      {
        interval: 5
      , fontSize: 36
      }
      }

    })

    //pie图
    this.updatePieData(bill_type)

  }

  private updateWeekData() {

    let bill_type = this.isOutput ? BillTypeEnum.Outcome : BillTypeEnum.Income;
    let sumData =
      DatabaseHelper.getInstance()
        .getDaySum(this.dayBoundary.begin.getTime(), this.dayBoundary.end.getTime(), bill_type);

    let map: Map<string, number> = new Map<string, number>();

    sumData.map(u => {

      map.set(u.timeBase, u.amount);
    });

    let yData: number[] = [];
    let i: number = 0;
    for (i = 0; i < 7; i++) {
      yData.push(0);
    }

    for (i = 0; i < 7; i++) {
      let dateItem: Date = new Date(this.dayBoundary.begin);
      dateItem.setDate(dateItem.getDate() + i);

      let dateStr = formatDateYMD1(dateItem);
      if (map.has(dateStr)) {
        yData[i] = map.get(dateStr) ?? 0;
      }
    }

    let yTitle = bill_type === BillTypeEnum.Outcome ? "支出金额" : "收入金额";
    let xData = ['周一', '周二', '周三', '周四', '周五', '周六', '周日']

    let yShowNumber: number[] = []
    yData.forEach((item) => {
      yShowNumber.push(roundAmountFen2Yuan(item));
    })

    this.lineOption.setVal({

      legend: {
        show: true,
        // align: 'right', // 图例与文本的对齐方式
        // left: '10%', // 距离左侧位置
        // itemGap: 10, // 图例每项之间的间隔。横向布局时为水平间隔，纵向布局时为纵向间隔。
        // itemTextGap: 5, // 图例图例之间的间隔。
        // itemWidth: 8, // 图例标记的图形高度。
        // itemHeight: 8, // 图例标记的图形高度。
        textStyle: {
          fontSize: 42
        },
        textUnselectedStyle:
        {
          fontSize: 42
        }
      },
      animation: false,
      series: [
        {
          name: yTitle,
          label:
          {
            fontSize: 36,
          },
          data: yShowNumber
        }
      ],
      yAxis: {
        name: yAxisText,
        nameTextStyle:
        {
          fontSize: 36
        },
        axisLabel:
        {
          fontSize: 36
        }
      },
      xAxis:
      {
        data: xData
      , axisLabel:
      {
        interval: 0,
        fontSize: 36
      }
      }
    })

    //更新饼图数据
    this.updatePieData(bill_type);


  }

  private updatePieData(bill_type: BillTypeEnum) {
    let categorySum = DatabaseHelper.getInstance()
      .getCategorySum(this.dayBoundary.begin.getTime(), this.dayBoundary.end.getTime(), bill_type,
        BizConstants.Category_Limit);

    this.pieData = categorySum.map(item => ({
      value: item.amount / 100,
      name: item.category // 将 category 映射为 name
    } as PieData
    ));

    this.pieDataController.updateData(this.pieData);
  }
}

export default BillReport


