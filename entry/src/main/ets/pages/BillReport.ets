import {
  AccountantData,
  CategoryListData,
  ColumnData,
  IBillReportData,
  LineChartData,
  PieData,
  ReportTimeRangeEnum,
  SumData
} from '../models/BillReportModel';
import { Options } from '@mcui/mccharts';
import {
  DayPair,
  formatDateYM1,
  formatDateYMD1,
  formatDayBoundary,
  getDateDiffInDays,
  getWeekBoundaries,
  roundAmountFen2Yuan
} from '../utils/Util';
import { DatabaseHelper } from '../utils/DatabaseHelper';
import { BillTypeEnum } from '../models/RecordList';
import { CategoryPieChart, PieDataController } from '../components/CategoryPieChart';
import { CategoryTopList } from '../components/CategoryTopList';
import { BizConstants } from '../utils/BizConstants';
import { ReportTimeSelector } from '../components/ReportTimeSelector';
import { LineCharDataController } from '../components/CategoryLineChart';
import { Accountant } from '../components/Accountant';
import { systemDateTime } from '@kit.BasicServicesKit';
import { taskpool } from '@kit.ArkTS';
import {
  getAccountantData,
  getBarReportData,
  getCategoryData,
  getLineChartData,
  getTopListData
} from '../utils/BillReportBiz';
import { router } from '@kit.ArkUI';


@Component
struct BillReport {
  @State
  barDefOption: Options = new Options({
    title: {
      show: true,
      text: '更新数据',
      right: 20,
      top: 30
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
  @State
  lineChartData: LineChartData = {

    yTitle: "支出金额",
    yShowNumber: [],
    xData: ['周一', '周二', '周三', '周四', '周五', '周六', '周日'],
    interval: 0

  } as LineChartData;
  @Prop totalOutcome: number;
  @Prop totalIncome: number;
  pieDataController: PieDataController = new PieDataController();
  lineCharDataController: LineCharDataController = new LineCharDataController();
  @State
  reportTimeRangeEnum: ReportTimeRangeEnum = ReportTimeRangeEnum.Week
  @State
  categoryTopList: CategoryListData[] = []
  @State
  pieData: PieData[] = []
  @Prop
  dayBoundary: DayPair;
  @State
  fromBeginDateStr: string = "";
  @State
  lineOption: Options = new Options({})
  @Prop
  isOutput: boolean = true
  @State columns: ColumnData[] = [
    new ColumnData('week', "周", true),
    new ColumnData('month', "月", false),
    new ColumnData('year', "年", false),
    new ColumnData('custom', "自定义", false),
  ];
  @State
  isLoading: boolean = false;
  scroller: Scroller = new Scroller();

  aboutToAppear(): void {

    let currentDate = new Date();
    this.dayBoundary = getWeekBoundaries(currentDate);
    this.fromBeginDateStr = formatDayBoundary(this.dayBoundary);

    let biz_type = this.isOutput ? BillTypeEnum.Outcome : BillTypeEnum.Income
    let categorySum = DatabaseHelper.getInstance()
      .getCategorySum(this.dayBoundary.begin.getTime(), this.dayBoundary.end.getTime(), biz_type
      );

    this.pieData = categorySum.map(item => ({
      value: item.amount / 100,
      name: item.category // 将 category 映射为 name
    } as PieData
    ))
      .sort((a, b) => (b.value - a.value))
      .slice(0, BizConstants.Category_TOP5_Limit);

  }

  aboutToDisappear(): void {

  }

  build() {

    Column() {

      ReportTimeSelector(
        {
          reportTimeRangeEnum: this.reportTimeRangeEnum,

          updateTimeRange: (dayBoundary: DayPair,
            isOutput: boolean
          ) => {

            this.updateTimeRange(dayBoundary, isOutput)


            // console.log(`mylog updateTimeRange 执行时间 cost：${(systemDateTime.getTime(true) - startTime) /
            //   1000} 微秒`);
          }
        , isLoading: this.isLoading
        }
      )
      //.backgroundColor(Color.Orange)

      if (this.isLoading) {
        Row({ space: 10 }) {
          LoadingProgress().width(30).height(30)
          Text("拼命计算中...")
            .fontSize(12)
            .fontColor($r("app.color.text_second"))
        }

      }
      //报表
      Scroll(
        this.scroller
      ) {
        Column({ space: 10 }) {

          //收支统计
          Accountant(
            {
              outcome: this.totalOutcome,
              income: this.totalIncome,

              reportTimeRangeEnum: this.reportTimeRangeEnum,
              isOutput: this.isOutput,
              dayBoundary: this.dayBoundary
            }

          )
            .padding(
              {
                left: 10,
                right: 10
              }
            )

          //排行榜
          Column() {
            CategoryTopList(
              {
                categoryList: this.categoryTopList
              }

            )
              .backgroundColor($r("app.color.white"))// .backgroundColor(Color.Gray)
              .borderRadius(8)
          }
          .width("100%")
          .padding(
            {
              left: 10,
              right: 10
            }
          )
          .visibility(Visibility.Visible)


          //类别饼图
          Column() {

            CategoryPieChart
            (
              {
                controller: this.pieDataController,
                pieData: this.pieData
              }
            )
              .backgroundColor($r("app.color.white"))// .height(280)
              .borderRadius(8)
              .padding(10)
            // .height(280)
          }
          .width("100%")
          .padding(
            {
              left: 10,
              right: 10
            }
          ).visibility(Visibility.Visible)


          //折线图
          if (this.reportTimeRangeEnum !== ReportTimeRangeEnum.Custom) {

            Column() {
              Row({ space: 5 }) {
                Image($r("app.media.route_plan"))
                  .width(24)
                  .aspectRatio(1)
                Text("更多图表")
                  .fontSize(14)
                  .fontWeight(FontWeight.Bold)
              }
              .width("100%")
              .padding(
                {
                  left: 10,
                  right: 10,
                  top: 10,
                  bottom: 10
                }
              )
              .onClick(
                () => {
                  router.pushUrl({
                    url: "pages/MoreReportPage",
                    params: this.barDefOption
                  })
                }
              )
              .backgroundColor($r("app.color.white"))
              .borderRadius(8)
            }
            .padding(
              {
                left: 10,
                right: 10
              })

          }


        }.width("100%")
        .padding(10)

        //

      }
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.Off)
      .width("100%")
      //非常重要,解决了scroll不适应的问题!!!
      .layoutWeight(1)
      //.backgroundColor(Color.Pink)
      .align(Alignment.Top)

    }
    .width("100%")
    .backgroundColor($r("app.color.back_color"))

  }

  public updateLineChartData(dayBoundary: DayPair, bill_type: BillTypeEnum, reportTimeRangeEnum: ReportTimeRangeEnum) {

    let interval: number = 5

    let sumData: SumData[] = []
    let map: Map<string, number> = new Map<string, number>();

    let xData: string[] = []
    let yData: number[] = [];

    if (reportTimeRangeEnum === ReportTimeRangeEnum.Week) {

      interval = 0
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
      interval = 5

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
      interval = 1

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


    let yTitle = bill_type === BillTypeEnum.Outcome ? "支出金额" : "收入金额";

    this.lineChartData =
      {
        yTitle: yTitle,
        yShowNumber: yShowNumber,
        xData: xData,
        interval: interval
      }

  }

  private async updateTimeRange(dayBoundary: DayPair,
    isOutput: boolean
  ) {


    const startTime = systemDateTime.getTime(false);
    this.dayBoundary = dayBoundary
    this.isOutput = isOutput
    let bill_type = isOutput ? BillTypeEnum.Outcome : BillTypeEnum.Income

    let reportTimeRangeEnum = this.reportTimeRangeEnum

    let dayPair: DayPair =
      {
        begin: this.dayBoundary.begin,
        end: this.dayBoundary.end
      }
    let context: Context = getContext(this)
    let total =
      await taskpool.execute(new taskpool.Task(getReportDataTaskPool, dayPair, bill_type, reportTimeRangeEnum,
        context)) as IBillReportData
    //收支统计
    this.totalOutcome = total.accountantData.outcome
    this.totalIncome = total.accountantData.income

    let dbDuration = systemDateTime.getTime(false) - startTime

    //更多图表
    this.barDefOption =
      getBarReportData(total.lineChartData)

    this.categoryTopList = total.categoryListData

    this.pieDataController.updateData(total.pieData)
    let duration = systemDateTime.getTime(false) - startTime

    console.log(`mylog duration  cost：${duration} ms,dbDuration:${dbDuration}`);
    if (dbDuration > 20) {

      // await mockLongTime(mockSleepMs)
    }

    this.isLoading = false

    this.scroller.scrollEdge(Edge.Top);
  }
}


@Concurrent
async function getReportDataTaskPool(dayBoundary: DayPair,
  bill_type: BillTypeEnum, reportTimeRangeEnum: ReportTimeRangeEnum,
  context: Context): Promise<IBillReportData> {

  const startTime = systemDateTime.getTime(false);
  await DatabaseHelper.getInstance().initDatabase(context)
  let categorySum = DatabaseHelper.getInstance()
    .getCategorySum(dayBoundary.begin.getTime(), dayBoundary.end.getTime(), bill_type
    );

  let accountantData: AccountantData = getAccountantData(dayBoundary, context)
  let lineChartData: LineChartData = getLineChartData(dayBoundary, bill_type, reportTimeRangeEnum)
  let pieData: PieData[] = getCategoryData(categorySum)

  let categoryListData: CategoryListData[] = getTopListData(categorySum, bill_type)

  let billReportData: IBillReportData = {
    accountantData: accountantData,
    lineChartData: lineChartData,
    pieData: pieData,
    categoryListData: categoryListData
  }
  const functionDuration = systemDateTime.getTime(false) - startTime
  console.log(`mylog getReportDataTaskPool cost ,functionDuration:${functionDuration}`);
  return billReportData


}

export default BillReport


