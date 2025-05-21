import { McPieChart, Options } from '@mcui/mccharts';
import { PieData } from '../models/BillReportModel';

export class PieDataController {
  updateData = (value: PieData[]) => {
  }
}

@Component
export struct CategoryPieChart {
  controller: PieDataController = new PieDataController();
  @Link
  pieData: PieData[];
  @State legendOption: Options = new Options({

    animation: false,
    // title: {
    //   show: false,
    //   text: '类别饼图',
    //   left: 15,
    //   top: 25,
    //   textStyle: { fontSize: 50 }
    // },

    // legend: {
    //   show: false,
    //   left: 20,
    //   selectAble: false,
    //   top: 20,
    //   orient: 'horizontal',
    //   itemGap: 10,
    //   itemTextGap: 10,
    //   itemWidth: 16,
    //   itemHeight: 16,
    //   textStyle: {
    //     color: '#000',
    //     fontWeight: 'normal',
    //     fontFamily: 'sans-serif',
    //     fontSize: 38
    //   }
    // },


    tooltip: {
      borderColor: '#f72659f5',
      borderWidth: 1,
      backgroundColor: '#fff',
      textStyle: {
        // 文本样式配置
        color: '#000',
        fontSize: 14
      }
    },
    series: [
      {
        center: ['50%', '50%'], // 饼图中心位置
        //roseType: false,
        data: this.pieData
      ,
        radius: ["", "60%"],
        labelLine:
        {
          style:
          { fontSize: 50 }
        }
      }
    ]
  })

  aboutToAppear(): void {
    if (this.controller) {
      this.controller.updateData = (value: PieData[]) => {
        this.updateData(value)
      }
    }

    //this.updateData(this.pieData)
  }

  build() {
    Column() {


      Column() {
        Row({ space: 5 }) {
          Image($r("app.media.category_pie"))
            .width(24)
            .aspectRatio(1)
          Text("类别饼图")
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
        }.width("100%")

        McPieChart({
          options: this.legendOption
        })


      }
      .width("100%")

    }
  }

  private updateData = (value: PieData[]) => {
    this.legendOption.setVal(
      {
        series: [
          {
            data: value
          }
        ]
      })
  }
}