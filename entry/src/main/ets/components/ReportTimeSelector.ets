import { ColumnData, ReportTimeRangeEnum } from '../models/BillReportModel';
import { BizConstants } from '../utils/BizConstants';
import {
  DayPair,
  formatDateYMDHan,
  getMonthBoundaries,
  getWeekBoundaries,
  getYearBoundaries,
  shiftMonth,
  shiftWeek,
  shiftYear
} from '../utils/Util';

@Component
export struct ReportTimeSelector {
  @State
  isOutput: boolean = true
  @State columns: ColumnData[] = [
    new ColumnData('week', "周", true),
    new ColumnData('month', "月", false),
    new ColumnData('year', "年", false),
    new ColumnData('custom', "自定义", false),
  ];

  @Link
  reportTimeRangeEnum: ReportTimeRangeEnum ;
  @State
  DateSelectBorderWidth: number = 2;
  @State
  fromBeginDateStr: string = "";
  @Prop
  dayBoundary: DayPair;
  updateReport: () => void = () => {
  }
  updateWeekData: () => void = () => {
  }
  updateMonthData: () => void = () => {
  }
  updateYearData: () => void = () => {
  }
  updateTimeRange: (reportTimeRangeEnum: ReportTimeRangeEnum, dayBoundary: DayPair
    , isOutput: boolean
  ) => void = () => {
  }

  shiftDate(left: boolean) {

    if (this.dayBoundary.begin.getFullYear() >= BizConstants.Max_Support_year
      || this.dayBoundary.begin.getFullYear() <= BizConstants.Min_Support_year
    ) {
      console.log("not support time range")
      return
    }

    if (this.columns[0].selected) {
      this.dayBoundary = shiftWeek(this.dayBoundary, left);
      //this.updateWeekData();
      //this.reportTimeRangeEnum=ReportTimeRangeEnum.Week
      this.updateTimeRange(this.reportTimeRangeEnum, this.dayBoundary, this.isOutput)
    } else if (this.columns[1].selected) {

      this.dayBoundary = shiftMonth(this.dayBoundary, left);
      //this.updateMonthData();
      //this.reportTimeRangeEnum=ReportTimeRangeEnum.Month
      this.updateTimeRange(this.reportTimeRangeEnum, this.dayBoundary, this.isOutput)

    } else if (this.columns[2].selected) {
      this.dayBoundary = shiftYear(this.dayBoundary, left);
      //this.updateYearData();

      // this.reportTimeRangeEnum=ReportTimeRangeEnum.Year
      this.updateTimeRange(this.reportTimeRangeEnum, this.dayBoundary, this.isOutput)
    }

    this.fromBeginDateStr = this.formatDayBoundary(this.dayBoundary);
  }

  formatDayBoundary(boundary: DayPair) {
    //周,月 ，年

    return formatDateYMDHan(boundary.begin) + "-" + formatDateYMDHan(boundary.end);
  }

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
      //this.updateWeekData()

      this.reportTimeRangeEnum = ReportTimeRangeEnum.Week


    } else if (this.columns[1].selected) {
      this.dayBoundary = getMonthBoundaries(new Date());
      //this.updateMonthData();

      this.reportTimeRangeEnum = ReportTimeRangeEnum.Month
      // this.updateTimeRange(ReportTimeRangeEnum.Month, this.dayBoundary, this.isOutput)
    } else if (this.columns[2].selected) {
      this.dayBoundary = getYearBoundaries(new Date());
      //this.updateYearData();

      this.reportTimeRangeEnum = ReportTimeRangeEnum.Year
      // this.updateTimeRange(ReportTimeRangeEnum.Month, this.dayBoundary, this.isOutput)
    }

    this.updateTimeRange(this.reportTimeRangeEnum, this.dayBoundary, this.isOutput)
    this.fromBeginDateStr = this.formatDayBoundary(this.dayBoundary);
  }

  aboutToAppear(): void {

    this.updateSelectColumn(this.columns[0]);
  }

  build() {
    Column() {

      //第一行
      Column() {

        Row({ space: 10 }) {

          Column() {
            Text("支出")
              .fontSize(18)
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
            //this.updateReport()
            this.updateTimeRange(this.reportTimeRangeEnum, this.dayBoundary, this.isOutput)
          })


          Column() {
            Text("收入")
              .fontSize(18)
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
            //this.updateReport()
            this.updateTimeRange(this.reportTimeRangeEnum, this.dayBoundary, this.isOutput)
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

      //第二行
      Row() {

        Row() {

          ForEach(this.columns, (item: ColumnData, index: number) => {

            Column() {
              Text(item.txt)
                .fontColor(item.getFontColor())
                .fontSize(18)
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
            .width(35)
            .height(35)
        }.height("100%")
        .justifyContent(FlexAlign.Center)
        .layoutWeight(1)
        .onClick(() => {

          this.shiftDate(true);
        })


        Column() {
          Text(this.fromBeginDateStr)// Text("2025年03月")
            .fontSize(15)

        }.layoutWeight(5)


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
    }.padding(
      {
        left: 10,
        right: 10

      }
    )
  }
}