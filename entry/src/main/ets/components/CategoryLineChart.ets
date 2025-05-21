import { McLineChart, Options } from '@mcui/mccharts';
import { LineChartData, ReportTimeRangeEnum } from '../models/BillReportModel';
import { BillTypeEnum } from '../models/RecordList';
import { DayPair } from '../utils/Util';

const yAxisText: string = "元";

export class LineCharDataController {
  updateData = (lineChartData: LineChartData) => {

    console.log("i am LineCharDataController")
  }
}

@Component
export struct CategoryLineChart {
  @Prop
  lineChartData: LineChartData
  @Prop
  dayBoundary: DayPair;
  @Prop
  reportTimeRangeEnum: ReportTimeRangeEnum
  lineCharDataController: LineCharDataController = new LineCharDataController();
  @State
  bill_type: BillTypeEnum = BillTypeEnum.Outcome
  @State
  yShowNumber: number[] = []
  @State
  xData: string[] = ['周一', '周二', '周三', '周四', '周五', '周六', '周日']
  @State
  lineOption: Options = new Options(
    {
      animation: true,
      series: [
        {

          name: this.lineChartData.yTitle,
          label:
          {
            fontSize: 36,
          },
          data: this.lineChartData.yShowNumber
        }
      ],
      yAxis: {
        name: yAxisText
      },
      xAxis:
      {
        data: this.lineChartData.xData
      , axisLabel:
      {
        interval: this.lineChartData.interval
      , fontSize: 36
      }
      }

    }
  )

  aboutToAppear(): void {

    if (this.lineCharDataController) {
      //重要!!,用拉姆达表达式,否则this 还是controller,而不是本组件类
      this.lineCharDataController.updateData =

        (lineChartData: LineChartData) => {
          this.updateData(lineChartData);
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

  private updateData = (lineChartData: LineChartData) => {


    this.lineOption.setVal(

      {
        animation: false,
        series: [
          {

            name: lineChartData.yTitle,

            label:
            {
              fontSize: 36,
            },
            data: lineChartData.yShowNumber
          }
        ],
        yAxis: {
          name: yAxisText
        },
        xAxis:
        {
          data: lineChartData.xData
        , axisLabel:
        {
          interval: lineChartData.interval
        , fontSize: 36
        }
        }

      }

    )
  }
}