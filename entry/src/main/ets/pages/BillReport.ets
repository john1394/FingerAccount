import { CategoryListData, CategorySumData, ColumnData, PieData, ReportTimeRangeEnum } from '../models/BillReportModel';
import { Options } from '@mcui/mccharts';
import { DayPair, formatDayBoundary, getWeekBoundaries } from '../utils/Util';
import { DatabaseHelper } from '../utils/DatabaseHelper';
import { BillTypeEnum } from '../models/RecordList';
import { CategoryPieChart, PieDataController } from '../components/CategoryPieChart';
import { CategoryTopList } from '../components/CategoryTopList';
import CategoryMapSingleton from '../models/CategoryMapSingleton';
import { BizConstants } from '../utils/BizConstants';
import { ReportTimeSelector } from '../components/ReportTimeSelector';
import { CategoryLineChart, LineCharDataController } from '../components/CategoryLineChart';
import { Accountant } from '../components/Accountant';
import { systemDateTime } from '@kit.BasicServicesKit';
import { taskpool } from '@kit.ArkTS';


@Component
struct BillReport {
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

  // timeoutId: number = -1

  aboutToAppear(): void {
    //this.isLoading = true
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

    //clearTimeout(this.timeoutId)
  }

  build() {

    Column() {

      ReportTimeSelector(
        {
          reportTimeRangeEnum: this.reportTimeRangeEnum,

          updateTimeRange: (dayBoundary: DayPair,
            isOutput: boolean
          ) => {

            const startTime = systemDateTime.getTime(true);
            this.updateTimeRange(dayBoundary, isOutput)


            console.log(`mylog updateTimeRange 执行时间 cost：${(systemDateTime.getTime(true) - startTime) /
              1000} 微秒`);
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


          //折线图
          if (this.reportTimeRangeEnum !== ReportTimeRangeEnum.Custom) {
            CategoryLineChart(
              {
                reportTimeRangeEnum: this.reportTimeRangeEnum,
                dayBoundary: this.dayBoundary,
                bill_type: BillTypeEnum.Outcome,
                lineCharDataController: this.lineCharDataController
              }
            )
          }
          // .visibility(Visibility.None)

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
          }
          .width("100%")
          .height(280)
          .padding(
            {
              left: 10,
              right: 10
            }
          )

          //.visibility(Visibility.None)


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

        }.width("100%")

        .padding(10)

        //.backgroundColor(Color.Pink)

      }
      // .backgroundColor(Color.Pink)
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.Off)
      .width("100%")
      //非常重要,解决了scroll不适应的问题!!!
      .layoutWeight(1)

    }
    .width("100%")
    .backgroundColor($r("app.color.back_color"))

  }

  private async accountantCalc() {
    const startTime = systemDateTime.getTime(true);

    let dayPair: DayPair =
      {
        begin: this.dayBoundary.begin,
        end: this.dayBoundary.end
      }

    let total =
      await taskpool.execute(new taskpool.Task(accountantCalcAsync, dayPair, getContext(this))) as number[]
    this.totalOutcome = total[0]
    //totalOutcome;
    this.totalIncome = total[1]
    //totalInCome;
    console.log(`mylog 执行时间：${(systemDateTime.getTime(true) - startTime) / 1000} 微秒`);

    //await mockLongTime(1)
  }

  private async updateTimeRange(dayBoundary: DayPair,
    isOutput: boolean
  ) {

    this.dayBoundary = dayBoundary
    this.isOutput = isOutput
    let bill_type = isOutput ? BillTypeEnum.Outcome : BillTypeEnum.Income
    let categorySum = DatabaseHelper.getInstance()
      .getCategorySum(this.dayBoundary.begin.getTime(), this.dayBoundary.end.getTime(), bill_type
      );

    //收支统计
    await this.accountantCalc();

    //折线图
    this.updateLineCharData(bill_type)

    //饼图
    this.updateCategoryData(categorySum, bill_type)
    this.pieDataController.updateData(this.pieData);

    //排行榜
    this.updateTopListData(categorySum, bill_type)


    this.isLoading = false
  }

  private updateTopListData(categorySum: CategorySumData[], bill_type: BillTypeEnum) {

    const totalAmount: number = categorySum.reduce(
      (sum: number, currentItem: CategorySumData) =>
      (sum + currentItem.amount),
      0
    );

    this.categoryTopList =
      categorySum.map(item =>
      (
        {
          categoryName: item.category,
          categoryImage: $r(`app.media.${CategoryMapSingleton.getInstance()
            .get(item.category, bill_type)?.category_image}`),
          percentValue: totalAmount > 0 ? item.amount * 100 / totalAmount : 0,
          count: item.rows,
          amount: item.amount,
          imageBackColor: bill_type === BillTypeEnum.Income ? BizConstants.SelectedIncomeCategoryIconBackColor :
          BizConstants.SelectedOutComeCategoryIconBackColor

        } as CategoryListData
      )
      ).sort((a, b) => (b.amount - a.amount)
      ).slice(0, BizConstants.Category_Top10_Limit);
  }

  private updateLineCharData(bill_type: BillTypeEnum) {

    this.lineCharDataController.updateData(this.dayBoundary, bill_type, this.reportTimeRangeEnum);
  }

  private updateCategoryData(categorySum: CategorySumData[], bill_type: BillTypeEnum) {

    this.pieData = categorySum.map(item => ({
      value: item.amount / 100,
      name: item.category // 将 category 映射为 name
    } as PieData
    ))
      .sort((a, b) => (b.value - a.value))
      .slice(0, BizConstants.Category_TOP5_Limit);

  }
}


@Concurrent
async function accountantCalcAsync(dayBoundary: DayPair, context: Context): Promise<number[]> {

  await DatabaseHelper.getInstance().initDatabase(context)
  let outComeCategorySum = DatabaseHelper.getInstance()
    .getCategorySum(dayBoundary.begin.getTime(), dayBoundary.end.getTime(), BillTypeEnum.Outcome
    );

  const totalOutcome: number = outComeCategorySum.reduce(
    (sum: number, currentItem: CategorySumData) => (sum + currentItem.amount),
    0
  );

  let incomeCategorySum = DatabaseHelper.getInstance()
    .getCategorySum(dayBoundary.begin.getTime(), dayBoundary.end.getTime(), BillTypeEnum.Income
    );

  const totalInCome: number = incomeCategorySum.reduce(
    (sum: number, currentItem: CategorySumData) => (sum + currentItem.amount),
    0
  );

  let result: number[] = [];

  result.push(totalOutcome)
  result.push(totalInCome)


  return result


}


@Concurrent
function getCategorySumAsync1(dayBoundary: DayPair): number[] {


  let result: number[] = [];

  // result.push(totalOutcome)
  //result.push(totalInCome)

  return result


}

export default BillReport


