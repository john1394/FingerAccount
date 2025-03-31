import { DEFAULT } from '@ohos/hypium';
import { ColumnData } from '../models/BillReportModel'

import { McLineChart, McPieChart, Options } from '@mcui/mccharts'
import {
  getWeekBoundaries,
  DayPair,
  formatDateYMDHan,
  getMonthBoundaries,
  getYearBoundaries,
  shiftWeek,
  shiftMonth,
  shiftYear,
  formatDateYMD1,
  formatDateYM1,
  formatFen,
  roundAmountFen2Yuan
} from '../utils/Util';
import { DatabaseHelper } from '../utils/DatabaseHelper';
import { BillTypeEnum } from '../models/RecordList';


@Preview
@Entry
@Component
struct BillReport {
  @Prop
  dayBoundary: DayPair;
  @State
  fromBeginDateStr: string = "";
  @State
  lineOption: Options = new Options({})
  @State pieOption: Options = new Options({

    title: {
      show: true,
      left: 50,
      top: 20,
      text: "类别统计", // 标题文本
      textStyle: { fontSize: 40 }

    }
  ,

    series: [
      {
        data: [
          { value: 435, name: '其它' },
          { value: 310, name: '餐饮' },
          { value: 234, name: '我心澎湃' },
          { value: 135, name: '蓝河' },
          { value: 548, name: '鸿蒙' }
        ]
      }
    ]
  })
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
    //currentDate.setDate(currentDate.getDate()-28)
    this.dayBoundary = getWeekBoundaries(currentDate);
    // this.weekPair = getWeekBoundaries(currentDate)

    //this.fromBeginDateStr = this.formatWeekPair();
    //this.fromBeginDateStr = this.formatWeekPair(getMonthBoundaries( currentDate));
    //getYearBoundaries( currentDate)
    this.fromBeginDateStr = this.formatDayBoundary(this.dayBoundary);

    this.updateWeekData();
  }

  private updateYearData() {
    let bill_type = this.isOutput ? BillTypeEnum.Outcome : BillTypeEnum.Income;
    let monthCount: number = this.dayBoundary.end.getMonth() - this.dayBoundary.begin.getMonth() + 1;

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
      series: [
        {
          name: yTitle,
          data: yShowNumber
        }
      ],
      yAxis: {
        name: '金额'
      },
      xAxis:
      {
        data: xData
      , axisLabel:
      {
        interval: 1
      }
      }
    })
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
    let dayCount: number = this.dayBoundary.end.getDate() - this.dayBoundary.begin.getDate() + 1;

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

    let yTitle = bill_type === BillTypeEnum.Outcome ? "支出金额" : "收入金额";
    this.lineOption.setVal({
      series: [
        {
          name: '支出金额',
          data: yShowNumber
        }
      ],
      yAxis: {
        name: yTitle
      },
      xAxis:
      {
        data: xData
      , axisLabel:
      {
        interval: 5
      }
      }

    })

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
      series: [
        {
          name: yTitle,
          data: yShowNumber
        }
      ],
      yAxis: {
        name: '金额'
      },
      xAxis:
      {
        data: xData
      , axisLabel:
      {
        interval: 0
      }
      }
    })

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


      //第四行 折线图

      Row() {
        McLineChart({
          options: this.lineOption
        })
      }
      .height('40%')
      //.backgroundColor(Color.Pink)
      .margin(
        {
          bottom: 10
        }
      )

      //第五行 饼图
      Row() {
        McPieChart({
          options: this.pieOption
        })
      }
      //.backgroundColor(Color.Gray)
      .height('40%')

    }
    .width("100%")
    .height("100%")
    //.backgroundColor(Color.Pink)
    .backgroundColor($r("app.color.back_color"))

  }
}

export default BillReport



