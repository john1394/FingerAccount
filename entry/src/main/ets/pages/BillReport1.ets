import { CategoryListData, CategorySumData, ColumnData, PieData, ReportTimeRangeEnum } from '../models/BillReportModel';

import { Options } from '@mcui/mccharts';
import { DayPair, formatDateYMDHan, getWeekBoundaries, } from '../utils/Util';
import { DatabaseHelper } from '../utils/DatabaseHelper';
import { BillTypeEnum } from '../models/RecordList';
import { CategoryPieChart, PieDataController } from '../components/CategoryPieChart';
import { CategoryTopList } from '../components/CategoryTopList';
import CategoryMapSingleton from '../models/CategoryMapSingleton';
import { BizConstants } from '../utils/BizConstants';
import { ReportTimeSelector } from '../components/ReportTimeSelector';
import { CategoryLineChart, LineCharDataController } from '../components/CategoryLineChart';


@Component
struct BillReport {
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

  aboutToAppear(): void {
    let currentDate = new Date();
    this.dayBoundary = getWeekBoundaries(currentDate);
    this.fromBeginDateStr = this.formatDayBoundary(this.dayBoundary);

    this.updateTimeRange(this.dayBoundary, this.isOutput)
  }

  formatDayBoundary(boundary: DayPair) {
    //周,月 ，年
    return formatDateYMDHan(boundary.begin) + "-" + formatDateYMDHan(boundary.end);
  }

  build() {

    Column() {

      ReportTimeSelector(
        {
          reportTimeRangeEnum: this.reportTimeRangeEnum,

          updateTimeRange: (reportTimeRangeEnum: ReportTimeRangeEnum, dayBoundary: DayPair,
            isOutput: boolean
          ) => {
            this.updateTimeRange(dayBoundary, isOutput)
          }
        }
      )
      //.backgroundColor(Color.Orange)

      //报表
      Scroll() {
        Column({ space: 10 }) {

          //折线图
          CategoryLineChart(
            {
              bill_type: BillTypeEnum.Outcome,
              lineCharDataController: this.lineCharDataController
            }
          )
          //.visibility(Visibility.None)

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
          .padding(10)

          // .visibility(Visibility.None)


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

  private updateTimeRange(dayBoundary: DayPair,
    isOutput: boolean
  ) {

    this.dayBoundary = dayBoundary
    this.isOutput = isOutput
    let biz_type = isOutput ? BillTypeEnum.Outcome : BillTypeEnum.Income
    this.updateLineCharData(biz_type)
    this.updateCategoryData(biz_type)

  }

  private updateLineCharData(bill_type: BillTypeEnum) {

    this.lineCharDataController.updateData(this.dayBoundary, bill_type, this.reportTimeRangeEnum);
  }

  private updateCategoryData(bill_type: BillTypeEnum) {
    let categorySum = DatabaseHelper.getInstance()
      .getCategorySum(this.dayBoundary.begin.getTime(), this.dayBoundary.end.getTime(), bill_type
      );

    this.pieData = categorySum.map(item => ({
      value: item.amount / 100,
      name: item.category // 将 category 映射为 name
    } as PieData
    ))
      .sort((a, b) => (b.value - a.value))
      .slice(0, BizConstants.Category_TOP5_Limit);

    this.pieDataController.updateData(this.pieData);

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
}

export default BillReport


