import {
  AccountantData,
  CategoryListData,
  CategorySumData,
  LineChartData,
  PieData,
  ReportTimeRangeEnum,
  SumData
} from '../models/BillReportModel';
import CategoryMapSingleton from '../models/CategoryMapSingleton';
import { BillTypeEnum } from '../models/RecordList';
import { BizConstants } from './BizConstants';
import { DatabaseHelper } from './DatabaseHelper';
import { DayPair, formatDateYM1, formatDateYMD1, getDateDiffInDays, roundAmountFen2Yuan } from './Util';
import { Options } from '@mcui/mccharts';

export function getAccountantData(dayBoundary: DayPair, context: Context): AccountantData {

  //DatabaseHelper.getInstance().initDatabase(context)
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

  let accountantData: AccountantData =
    {
      outcome: totalOutcome,
      income: totalInCome,
    }

  return accountantData


}

export function getLineChartData(dayBoundary: DayPair, bill_type: BillTypeEnum,
  reportTimeRangeEnum: ReportTimeRangeEnum): LineChartData {
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
      xData.push((i + 1).toString());
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

  let lineChartData: LineChartData =
    {
      yTitle: yTitle,
      yShowNumber: yShowNumber,
      xData: xData,
      interval: interval
    }

  return lineChartData
}


export function getCategoryData(categorySum: CategorySumData[]): PieData[] {

  let pieData: PieData[] = categorySum.map(item => ({
    value: item.amount / 100,
    name: item.category // 将 category 映射为 name
  } as PieData
  ))
    .sort((a, b) => (b.value - a.value))
    .slice(0, BizConstants.Category_TOP5_Limit);
  return pieData;

}


export function getTopListData(categorySum: CategorySumData[], bill_type: BillTypeEnum): CategoryListData[] {

  const totalAmount: number = categorySum.reduce(
    (sum: number, currentItem: CategorySumData) =>
    (sum + currentItem.amount),
    0
  );

  let categoryTopList =
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

  return categoryTopList
}


export function mockBarData() {

  let countRange = [7, 30, 12]

  let xCount = countRange[Math.floor(Math.random() * countRange.length)]
  let yNumbers: number[] = []

  for (let i = 0; i < xCount; i++) {
    yNumbers.push(Math.floor(Math.random() * 100))
  }

  let xValues: string[] = []

  for (let i = 0; i < xCount; i++) {

    let xValue = ""
    if (xCount === 7) {
      xValue = "周"
    }

    xValues.push(xValue + i.toString())
  }

  let defOption: Options = new Options({
    animation: false,
    legend:
    {
      show: false
    },
    // title: {
    //   show: true,
    //   text: '更新数据',
    //   right: 20,
    //   top: 30
    // },
    xAxis: {
      data: xValues,
      axisLabel:
      { fontSize: 36 }
    },
    yAxis: {
      name: '元',
      nameTextStyle:
      {
        fontSize: 36
      },
      axisLabel:
      { fontSize: 36 }
    },
    series: [
      {
        // name: '最高气温',
        data: yNumbers,
        label:
        { fontSize: 36 }
      }
    ]
  })

  return defOption
}


export function getBarReportData(linetCharData: LineChartData) {

  let defOption: Options = new Options({
    animation: true,
    legend:
    {
      show: false
    },

    xAxis: {
      data: linetCharData.xData,
      axisLabel:
      { fontSize: 36 }
    },
    yAxis: {
      name: '元',
      nameTextStyle:
      {
        fontSize: 36
      },
      axisLabel:
      { fontSize: 36 }
    },
    series: [
      {
        data: linetCharData.yShowNumber,
        label:
        { fontSize: 36 }
      }
    ]
  })

  return defOption
}

