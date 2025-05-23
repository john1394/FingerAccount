import { McBarChart, Options } from '@mcui/mccharts'

@Component
export struct TimeBarChart {
  @State
  isVisible: boolean = false
  @Prop defOption: Options = new Options({
    animation: true,
    // title: {
    //   show: true,
    //   text: '更新数据',
    //   right: 20,
    //   top: 30
    // },
    legend:
    {
      show: false
    },

    xAxis: {
      data: ['周一', '周二', '周三', '周四', '周五', '周六', '周日']
    },
    yAxis: {
      name: '温度'
    },
    series: [
      {
        name: '最高气温',
        data: [11, 11, 15, 13, 12, 130, 10]
      }
    ]
  })

  build() {

    Column() {
      Row({ space: 5 }) {
        Image($r("app.media.route_plan"))
          .width(24)
          .aspectRatio(1)
        Text("柱状图")
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
      }.width("100%")
      .padding(
        {
          left: 10,
          top: 5

        }
      ).onClick(
        () => {
        //  this.isVisible = !this.isVisible
        }
      )

      Row() {
        McBarChart({
          options: this.defOption
        })
      }
      .height('100%')
      .height(240)
      .visibility(this.isVisible ? Visibility.Visible : Visibility.None)
    }.width("100%")
    .backgroundColor($r("app.color.white"))
    .borderRadius(8)
  }
}