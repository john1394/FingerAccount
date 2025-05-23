import { ChartOptions, hmChart, hmChartType } from '@wuyan/hm_chart';

@Component
export struct ETimeBarChart {
  @State myChart: hmChartType | null = null
  @State Options: ChartOptions = {
    xAxis: {
      type: 'category',
      data: ['Mon1', 'Tue1', 'Wed1', 'Thu1', 'Fri1', 'Sat1',
        'Sun1', 'Mon2', 'Tue2', 'Wed2', 'Thu2', 'Fri2', 'Sat2', 'Sun2',
        'Mon3',
        'Tue3', 'Wed2', 'Thu', 'Fri', 'Sat', 'Sun'
        , 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
    },
    yAxis: {
      type: 'value',


    },
    tooltip: {
      trigger: 'axis'
    },
    series: [
      {
        data: [200, 932, 901, 934, 1290, 1330, 1320, 820, 932, 901, 934, 1290, 1330, 1320,
          820, 932, 901, 934, 1290, 1330, 1320, 820, 932, 901, 934, 1290, 1330, 1400],
        type: 'bar',
        smooth: true
      }
    ]
  };

  build() {
    Column() {
      Row() {
        Button('异步加载')
          .onClick(() => {
            const Options: ChartOptions = {
              tooltip: {
                trigger: 'axis',
                axisPointer: {
                  type: 'cross',
                  label: {
                    backgroundColor: '#6a7985'
                  }
                }
              },
              legend: {
                data: ['Email', 'Union Ads', 'Video Ads', 'Direct', 'Search Engine']
              },
              // toolbox: {
              //   feature: {
              //     saveAsImage: {}
              //   }
              // },
              grid: {
                left: '3%',
                right: '4%',
                bottom: '3%',
                containLabel: true
              },
              xAxis: [
                {
                  type: 'category',
                  boundaryGap: false,
                  data: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                }
              ],
              yAxis: [
                {
                  type: 'value'
                }
              ],
              series: [
                {
                  name: 'Email',
                  type: 'bar',
                  stack: 'Total',
                  areaStyle: {},
                  emphasis: {
                    focus: 'series'
                  },
                  data: [120, 132, 101, 134, 90, 230, 2010]
                },
              // {
              //   name: 'Union Ads',
              //   type: 'line',
              //   stack: 'Total',
              //   areaStyle: {},
              //   emphasis: {
              //     focus: 'series'
              //   },
              //   data: [220, 182, 191, 234, 290, 330, 310]
              // },
              // {
              //   name: 'Video Ads',
              //   type: 'line',
              //   stack: 'Total',
              //   areaStyle: {},
              //   emphasis: {
              //     focus: 'series'
              //   },
              //   data: [150, 232, 201, 154, 190, 330, 410]
              // },
              // {
              //   name: 'Direct',
              //   type: 'line',
              //   stack: 'Total',
              //   areaStyle: {},
              //   emphasis: {
              //     focus: 'series'
              //   },
              //   data: [320, 332, 301, 334, 390, 330, 320]
              // },
              // {
              //   name: 'Search Engine',
              //   type: 'line',
              //   stack: 'Total',
              //   label: {
              //     show: true,
              //     position: 'top'
              //   },
              //   areaStyle: {},
              //   emphasis: {
              //     focus: 'series'
              //   },
              //   data: [820, 932, 901, 934, 1290, 1330, 1320]
              // }
              ]
            }
            if (this.myChart) {
              this.myChart.setOption(Options)
            }
          })
      }

      Column() {
        hmChart({ Options: this.Options, myChart: this.myChart })
      }.width('90%')
      .height('400')
    }
    .height('100%')
    .width('100%')
  }
}