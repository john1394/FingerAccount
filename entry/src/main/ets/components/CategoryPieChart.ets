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
  // [
  // // { value: 435, name: 'IOS' },
  // // { value: 310, name: '安卓' },
  // // { value: 234, name: '我心澎湃' },
  // // { value: 135, name: '蓝河' },
  // // { value: 1548, name: '鸿蒙' }
  // ]
  @State legendOption: Options = new Options({
    title: {
      show: true,
      text: '类别',
      left: 15,
      top: 25,
      textStyle: { fontSize: 50 }
    },
    legend: {
      show: true,
      left: 50,
      top: 20,
      orient: 'horizontal',
      itemGap: 10,
      itemTextGap: 10,
      itemWidth: 8,
      itemHeight: 8,
      textStyle: {
        color: '#000',
        fontWeight: 'normal',
        fontFamily: 'sans-serif',
        fontSize: 45
      }
    },
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
        labelLine:
        {
          style:
          { fontSize: 45 }
        }
      }
    ]
  })

  aboutToAppear(): void {
    if (this.controller) {
      this.controller.updateData = this.updateData;
    }
  }

  build() {
    Column() {


      Column() {
        McPieChart({
          options: this.legendOption
        })

        Text("test1")
          .onClick(() => {
            // this.legendOption.setVal(
            //   {
            //     series: [
            //       {
            //         data: [
            //           { value: 435, name: 'IOS' },
            //           { value: 310, name: '安卓' },
            //           { value: 234, name: '我心澎湃' },
            //           { value: 135, name: '蓝河' },
            //           { value: 1548, name: '鸿蒙' }
            //         ]
            //       }
            //     ]
            //   }
            // )
          }
          )
      }
      .width("100%")
      .height("100%")

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