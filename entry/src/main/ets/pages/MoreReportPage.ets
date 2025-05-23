import { router } from '@kit.ArkUI';
import { Options } from '@mcui/mccharts';
import { TimeBarChart } from '../components/TimeBarChart';

@Entry
@Component
struct MoreReportPage {
  @State message: string = 'Hello World';
  @State
  barDefOption: Options = {} as Options
  @State
  isVisible: boolean = false

  aboutToAppear(): void {

    this.barDefOption = router.getParams() as Options;
    this.isVisible = true
  }

  build() {
    Column() {


      //第一行
      Row({ space: 0 }) {
        Image($r("app.media.ic_public_arrow_left"))
          .width(24)
          .height(24)
          .onClick(() => {
            router.back()
          })

        Text("图表") {
        }
        .fontSize(16)
        .layoutWeight(1)
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Center)
      }
      .padding(
        {
          right: 24
        }
      )
      .width("100%")
      .height(48)
      .backgroundColor($r("app.color.white"))

      Column() {
        Column() {
          TimeBarChart(
            {
              defOption: this.barDefOption,
              isVisible: this.isVisible
            }
          )
        }.visibility(this.isVisible ? Visibility.Visible : Visibility.None)

      }.width("100%")
      .padding(10)

    }.backgroundColor($r("app.color.back_color"))

    .height('100%')
    .width('100%')
  }
}

// Column() {
//   CategoryLineChart(
//     {
//       lineChartData: this.lineChartData,
//       lineCharDataController: this.lineCharDataController
//     }
//   )
// }.width("100%")
// .padding(
//   {
//     left: 10,
//     right: 10
//   }
// )
// .visibility(Visibility.None)


//柱状图
// if (this.reportTimeRangeEnum !== ReportTimeRangeEnum.Custom) {
//   Column() {
//     TimeBarChart(
//       {
//         defOption: this.barDefOption
//       }
//     )
//
//   }.width("100%")
//   .padding(
//     {
//       left: 10,
//       right: 10
//     }
//   )
//
// }