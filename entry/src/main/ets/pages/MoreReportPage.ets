import { router } from '@kit.ArkUI';
import { Options } from '@mcui/mccharts';
import { TimeBarChart } from '../components/TimeBarChart';

@Entry
@Component
struct MoreReportPage {
  @State message: string = 'Hello World';
  @State
  barDefOption: Options = new Options({
    title: {
      show: true,
      text: '数据',
      right: 20,
      top: 30
    },
    xAxis: {
      data: ['周一', '周二', '周三', '周四', '周五', '周六', '周日']
    },
    yAxis: {
      name: '元'
    },
    series: [
      {
        data: [11, 11, 15, 13, 12, 130, 10]
      }
    ]
  })
  @State
  isVisible: boolean = true

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
        }
        .visibility(this.isVisible ? Visibility.Visible : Visibility.None)

      }.width("100%")
      .padding(10)

    }.backgroundColor($r("app.color.back_color"))

    .height('100%')
    .width('100%')
  }
}
