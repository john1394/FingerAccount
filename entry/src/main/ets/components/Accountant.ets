import { ReportTimeRangeEnum } from '../models/BillReportModel';
import { DayPair, getDateDiffInDays, getMonthDiff } from '../utils/Util';

@Component
export struct Accountant {
  @Prop outcome: number;
  @Prop income: number;

  @Prop
  reportTimeRangeEnum: ReportTimeRangeEnum
  @Prop
  isOutput: boolean;
  @Prop
  dayBoundary: DayPair;

  getAverageValue(): string {

    let count = 0

    if (this.reportTimeRangeEnum === ReportTimeRangeEnum.Week) {
      count = getDateDiffInDays(this.dayBoundary.begin, this.dayBoundary.end)
    } else if (this.reportTimeRangeEnum === ReportTimeRangeEnum.Month) {
      count = getDateDiffInDays(this.dayBoundary.begin, this.dayBoundary.end)
    } else if (this.reportTimeRangeEnum === ReportTimeRangeEnum.Year) {
      count = getMonthDiff(this.dayBoundary.begin, this.dayBoundary.end)
    } else if (this.reportTimeRangeEnum === ReportTimeRangeEnum.Custom) {
      count = getDateDiffInDays(this.dayBoundary.begin, this.dayBoundary.end)
    }

    let average = 0
    if (this.isOutput) {
      average = count > 0 ? this.outcome / count : 0
    } else {
      average = count > 0 ? this.income / count : 0
    }

    return (average / 100).toFixed(2).toString()
  }

  getAverageHeaderText() {
    let result = ""

    if (this.reportTimeRangeEnum === ReportTimeRangeEnum.Week) {
      result += "日均"
    } else if (this.reportTimeRangeEnum === ReportTimeRangeEnum.Month) {
      result += "日均"
    } else if (this.reportTimeRangeEnum === ReportTimeRangeEnum.Year) {
      result += "月均"
    } else if (this.reportTimeRangeEnum === ReportTimeRangeEnum.Custom) {
      result += "日均"
    }

    if (this.isOutput) {
      result += "支出"
    } else {
      result += "收入"
    }

    return result;
  }

  build() {

    Column({ space: 10 }) {
      Row({ space: 5 }) {
        Image("/assets/accountant.svg")
          .width(24)
          .aspectRatio(1)
        Text("收支统计")
      }.width("100%")

      Row() {
        Column() {
          Text("收入").layoutWeight(1)
            .fontSize(16)
            .fontColor($r("app.color.text_second"))
          Text((this.income / 100).toFixed(2)).layoutWeight(1)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
        }.layoutWeight(1)
        .padding(
          {
            left: 20
          }
        )
        .alignItems(HorizontalAlign.Start)

        //.backgroundColor(Color.Pink)

        Column() {
          Text("支出").layoutWeight(1)
            .fontSize(16)
            .fontColor($r("app.color.text_second"))
          Text((this.outcome / 100).toFixed(2)).layoutWeight(1)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
        }.layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
        .padding(
          {
            left: 20
          }
        )

        //.backgroundColor(Color.Yellow)
      }.width("100%")
      .height(50)

      Row() {
        Column() {
          Text(this.getAverageHeaderText()).layoutWeight(1)
            .fontSize(16)
            .fontColor($r("app.color.text_second"))
          Text(this.getAverageValue()).layoutWeight(1)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
        }.layoutWeight(1)
        .padding(
          {
            left: 20
          }
        )
        .alignItems(HorizontalAlign.Start)

        Column() {
          Text("结余").layoutWeight(1)
            .fontSize(16)
            .fontColor($r("app.color.text_second"))
          Text(((this.income - this.outcome) / 100).toFixed(2)).layoutWeight(1)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
        }.layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
        .padding(
          {
            left: 20
          }
        )

        //.backgroundColor(Color.Yellow)
      }.width("100%")
      .height(50)
    }
    .width("100%")

    .backgroundColor($r("app.color.white"))
    .borderRadius(5)
    .padding(
      {
        left: 10,
        right: 10,
        top: 10,
        bottom: 10
      }
    )

  }
}