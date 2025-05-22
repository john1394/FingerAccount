import {
  AccountantData,
  BillReportData,
  CategoryListData,
  ColumnData,
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
import { CategoryLineChart, LineCharDataController } from '../components/CategoryLineChart';
import { Accountant } from '../components/Accountant';
import { systemDateTime } from '@kit.BasicServicesKit';
import { taskpool } from '@kit.ArkTS';
import { getAccountantData, getCategoryData, getLineChartData, getTopListData } from '../utils/BillReportBiz';


@Component
struct BillReport {
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
      Scroll() {
        Column({ space: 10 }) {

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


          //第6行 排行列表
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
          .padding(10)


          //第五行 饼图
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
          )


          //折线图
          if (this.reportTimeRangeEnum !== ReportTimeRangeEnum.Custom) {
            Column() {
              CategoryLineChart(
                {
                  lineChartData: this.lineChartData,
                  lineCharDataController: this.lineCharDataController
                }
              )
            }.width("100%")
            .padding(
              {
                left: 10,
                right: 10
              }
            ).visibility(Visibility.None)
          }


        }.width("100%")
        .padding(10)

      }
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.Off)
      .width("100%")
      //非常重要,解决了scroll不适应的问题!!!
      .layoutWeight(1)

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
        context)) as BillReportData
    //收支统计
    this.totalOutcome = total.accountantData.outcome
    this.totalIncome = total.accountantData.income
    //折线图
    let dbDuration = systemDateTime.getTime(false) - startTime
    //  this.lineCharDataController.updateData(total.lineChartData);
    //饼图
    this.pieDataController.updateData(total.pieData);
    //排行榜

    this.categoryTopList = total.categoryListData

    let duration = systemDateTime.getTime(false) - startTime
    //  let mockSleepMs = 250
    // let sleepMs = 200 - duration
    console.log(`mylog duration  cost：${duration} ms,dbDuration:${dbDuration}`);
    if (dbDuration > 20) {

      // await mockLongTime(mockSleepMs)
    }


    this.isLoading = false
  }
}


@Concurrent
async function getReportDataTaskPool(dayBoundary: DayPair,
  bill_type: BillTypeEnum, reportTimeRangeEnum: ReportTimeRangeEnum,
  context: Context): Promise<BillReportData> {
  await DatabaseHelper.getInstance().initDatabase(context)
  let categorySum = DatabaseHelper.getInstance()
    .getCategorySum(dayBoundary.begin.getTime(), dayBoundary.end.getTime(), bill_type
    );

  let accountantData: AccountantData = getAccountantData(dayBoundary, context)
  let lineChartData: LineChartData = getLineChartData(dayBoundary, bill_type, reportTimeRangeEnum)
  let pieData: PieData[] = getCategoryData(categorySum)

  //console.log("mylog get1")

  let categoryListData: CategoryListData[] = getTopListData(categorySum, bill_type)

  let billReportData: BillReportData =
    new BillReportData(accountantData, lineChartData, pieData, categoryListData)

  //console.log("mylog get2")
  return billReportData


}

export default BillReport


