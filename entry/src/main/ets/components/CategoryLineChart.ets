import { McLineChart, Options } from '@mcui/mccharts';
import { ReportTimeRangeEnum, SumData } from '../models/BillReportModel';
import { BillTypeEnum } from '../models/RecordList';
import { DatabaseHelper } from '../utils/DatabaseHelper';
import { DayPair, formatDateYM1, formatDateYMD1, getDateDiffInDays, roundAmountFen2Yuan } from '../utils/Util';

const yAxisText: string = "元";

export class LineCharDataController {
  updateData = (dayBoundary: DayPair, bill_type: BillTypeEnum, reportTimeRangeEnum: ReportTimeRangeEnum) => {

    console.log("i am controller")
  }
}

@Component
export struct CategoryLineChart {
  lineCharDataController: LineCharDataController = new LineCharDataController();
  @State
  bill_type: BillTypeEnum = BillTypeEnum.Outcome
  @State
  yShowNumber: number[] = [1, 2, 3]
  @State
  xData: string[] = ['周一', '周二', '周三', '周四', '周五', '周六', '周日']
  @State
  lineOption: Options = new Options(
    {
      animation: true,
      series: [
        {
          name: (this.bill_type === BillTypeEnum.Outcome ? "支出金额" : "收入金额"),
          label:
          {
            fontSize: 36,
          },
          data: this.yShowNumber
        }
      ],
      yAxis: {
        name: yAxisText
      },
      xAxis:
      {
        data: this.xData
      , axisLabel:
      {
        interval: 5
      , fontSize: 36
      }
      }

    }
  )

  public updateData(dayBoundary: DayPair, bill_type: BillTypeEnum, reportTimeRangeEnum: ReportTimeRangeEnum) {


    let sumData: SumData[] = []
    let map: Map<string, number> = new Map<string, number>();

    let xData: string[] = []
    let yData: number[] = [];

    if (reportTimeRangeEnum === ReportTimeRangeEnum.Week) {


      sumData = DatabaseHelper.getInstance()
        .getDaySum(dayBoundary.begin.getTime(), dayBoundary.end.getTime(), bill_type);
      sumData.map(u => {
        map.set(u.timeBase, u.amount);
      });

      for (let i = 0; i < 7; i++) {
        yData.push(0);
      }

      for (let i = 0; i < 7; i++) {
        let dateItem: Date = new Date(dayBoundary.begin);
        dateItem.setDate(dateItem.getDate() + i);

        let dateStr = formatDateYMD1(dateItem);
        if (map.has(dateStr)) {
          yData[i] = map.get(dateStr) ?? 0;
        }
      }

      xData = ['周一', '周二', '周三', '周四', '周五', '周六', '周日']

    } else if (reportTimeRangeEnum === ReportTimeRangeEnum.Month) {
      sumData = DatabaseHelper.getInstance()
        .getDaySum(dayBoundary.begin.getTime(), dayBoundary.end.getTime(), bill_type);
      sumData.map(u => {
        map.set(u.timeBase, u.amount);
      });

      let dayCount: number = getDateDiffInDays(new Date(dayBoundary.begin.getTime())
        , new Date(dayBoundary.end.getTime()))

      for (let i = 0; i < dayCount; i++) {
        xData.push(i.toString());
      }

      for (let i = 0; i < dayCount; i++) {
        yData.push(0);
      }

      for (let i = 0; i < dayCount; i++) {
        let dateItem: Date = new Date(dayBoundary.begin);
        dateItem.setDate(dateItem.getDate() + i);

        let dateStr = formatDateYMD1(dateItem);
        if (map.has(dateStr)) {
          yData[i] = map.get(dateStr) ?? 0;
        }
      }

    } else if (reportTimeRangeEnum === ReportTimeRangeEnum.Year) {

      sumData =
        DatabaseHelper.getInstance()
          .getMonthSum(dayBoundary.begin.getTime(), dayBoundary.end.getTime(), bill_type);
      sumData.map(u => {
        map.set(u.timeBase, u.amount);
      });

      let monthCount: number = 12
      for (let i = 0; i < monthCount; i++) {
        xData.push((i + 1).toString() + "月");
      }

      for (let i = 0; i < monthCount; i++) {
        yData.push(0);
      }

      for (let i = 0; i < monthCount; i++) {
        let dateItem: Date = new Date(dayBoundary.begin);
        dateItem.setMonth(dateItem.getMonth() + i);

        let dateStr = formatDateYM1(dateItem);
        if (map.has(dateStr)) {
          yData[i] = map.get(dateStr) ?? 0;
        }
      }
    }

    let yShowNumber: number[] = []
    yData.forEach((item) => {
      yShowNumber.push(roundAmountFen2Yuan(item));
    })


    let yTitle = this.bill_type === BillTypeEnum.Outcome ? "支出金额" : "收入金额";
    this.lineOption.setVal({

      series: [
        {
          name: yTitle,
          data: yShowNumber
        }
      ],
      xAxis:
      {
        data: xData
      }
    })
  }

  aboutToAppear(): void {

    if (this.lineCharDataController) {
      //重要!!,用拉姆达表达式,否则this 还是controller,而不是本组件类
      this.lineCharDataController.updateData =
        //= this.updateData
        (dayBoundary: DayPair, bill_type: BillTypeEnum, reportTimeRangeEnum: ReportTimeRangeEnum) => {
          this.updateData(dayBoundary, bill_type, reportTimeRangeEnum);
        }
    }
  }

  build() {
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

  }
}