import dayjs from 'dayjs';
import { CategoryItem } from '../models/CategoryList';
import CategoryMapSingleton from '../models/CategoryMapSingleton';
import { BillDbRecord, BillTypeEnum, RecordItemInfo } from '../models/RecordList';
import { BizConstants } from './BizConstants';

export function test1() {

  let o1: Record<string, string> = { "a": "b" }

  let a2 = 22.00;

  let b1 = a2.toFixed(2)

  console.log(b1)

  let arr1: string[] = []

  let arr2 = arr1
  let arr3 = [...arr1]
  arr1.push("1")


}

export function mockBillRecords(startYear: number = 2025, yearCount: number = 10, monthCount: number = 12
  , dayCount: number = 3, maxAmount: number = 10000, id: number = 1
) {

  let result: BillDbRecord[] = []

  for (let i = 0; i < yearCount; i++) {
    let year = startYear + i
    for (let j = 0; j < monthCount; j++) {
      let month = j

      let dt = new Date(year, month, 1)
      // 获取当前月份的天数
      let jsDate = dayjs(dt.getTime())
      const daysInCurrentMonth = jsDate.daysInMonth();

      for (let m = 0; m < daysInCurrentMonth; m++) {

        let day = m + 1

        let hourStep = 24 / dayCount
        for (let n = 0; n < dayCount; n++) {
          let hour = n * hourStep

          let opDate = new Date(year, month, day, hour)

          let timestamp = opDate.getTime()
          let bill_type = Math.floor(Math.random() * 2)
          let amount = Math.floor(Math.random() * maxAmount)
          let notes = "notes" + Math.random().toFixed(2)

          let category = "其它"
          let outCats: CategoryItem[] = [];

          for (const value of CategoryMapSingleton.getInstance().getOutComeMap().values()) {
            outCats.push(value);
          }

          let inCats: CategoryItem[] = [];

          for (const value of CategoryMapSingleton.getInstance().getInComeMap().values()) {
            inCats.push(value);
          }

          if (bill_type === 0) {
            category = outCats[Math.floor(Math.random() * outCats.length)].category_name
          } else {
            category = inCats[Math.floor(Math.random() * inCats.length)].category_name
          }


          let record: BillDbRecord =
            {
              // 用户id
              id: id,
              bill_book_id: BizConstants.Default_bill_book_id,
              // 类型名称
              category: category,
              //收支类型 0 为支出 ,1 为收入
              bill_type: bill_type,

              //金额
              amount: amount,
              //记帐时间
              timestamp: timestamp,

              //备注
              notes: notes,

              //扩展列
              extra_fields: ""
            }

          result.push(record)

          ++id

        }
      }

    }
  }


  return result

}

export interface DayPair {
  begin: Date;
  end: Date;
}

export async function mockLongTime(ms: number): Promise<string> {
  let pro = await new Promise<string>((resolve) => {
    setTimeout(() => {


      return resolve("result text");
    }, ms);
  });

  return pro
}

//2025-06-07
export function mockRandomCurrentDay(dayStr: string): Date {
  let str = dayStr + " " + Math.floor(Math.random() * 24).toString().padStart(2, "0") + ":" +
  Math.floor(Math.random() * 60).toString().padStart(2, "0") + ":" +
  Math.floor(Math.random() * 60).toString().padStart(2, "0")

  //YYYY-MM-DD HH:mm:ss
  return dayjs(str, "YYYY-MM-DD HH:mm:ss").toDate()
}

export function formatSimpleDate(time: number): string {

  let str = dayjs(time).format("YYYY-MM-DD HH:mm:ss")
  return str
}

export class DayPairImp implements DayPair {
  begin: Date;
  end: Date;

  constructor(begin: Date, end: Date) {
    this.begin = begin;
    this.end = end;
  }
}


export async function sleepTest() {
  console.log("开始执行");

  const a = new Promise<number | void>((resolve) => {
    setTimeout(() => {

      console.log("mylog", "setTimeout");


      resolve()
    }, 3000)

  });

  await a;

  console.log("mylog 10 毫秒后执行");
}

export function getDayOutcomeSum(list: RecordItemInfo[]) {
  const totalExpense: number = list.reduce(
    (sum: number, currentItem: RecordItemInfo) =>
    (currentItem.bill_type === BillTypeEnum.Outcome ? sum + currentItem.amount : sum),
    0
  );

  return totalExpense
}

export function getDayIncomeSum(list: RecordItemInfo[]) {
  const totalExpense: number = list.reduce(
    (sum: number, currentItem: RecordItemInfo) =>
    (currentItem.bill_type === BillTypeEnum.Income ? sum + currentItem.amount : sum),
    0
  );

  return totalExpense
}


export function groupRecordItemInfoByTimestamp(list: RecordItemInfo[]): Map<string, RecordItemInfo[]> {


  const groupedMap = new Map<string, RecordItemInfo[]>();

  for (const item of list) {
    const timeFormat = formatDateMDWeekHan(new Date(item.timestamp))

    if (groupedMap.has(timeFormat)) {
      // 如果已经有该 category_name 的分组，将当前 item 添加到对应的子列表中
      groupedMap.get(timeFormat)?.push(item);
    } else {
      // 如果没有该 category_name 的分组，创建一个新的子列表并添加当前 item
      groupedMap.set(timeFormat, [item]);
    }
  }

  return groupedMap;

}

// 获取当前年份的第一天和最后一天
export function getYearBoundaries(currentDate: Date): DayPair {

  const currentYear = currentDate.getFullYear();
  // 年的第一天（1月1日）
  const firstDay = new Date(currentYear, 0, 1); // 月份从 0 开始（0=1月）

  // 年的最后一天（12月31日）
  const lastDay = new Date(currentYear, 11, 31)
  //new Date(currentYear, 11, 31); // 12月=11
  lastDay.setHours(23, 59, 59, 999)

  return { begin: firstDay, end: lastDay };
}

// 将当前时间向前移动一周
export function shiftWeek(dayPair: DayPair, left: boolean): DayPair {
  let dayNumber = left ? -7 : 7;
  const begin = new Date(dayPair.begin); // 创建副本，避免修改原对象
  begin.setDate(begin.getDate() + dayNumber); // 增加 7 天

  const end = new Date(begin); // 创建副本，避免修改原对象
  end.setDate(end.getDate() + 6); // 增加 7 天
  end.setHours(23, 59, 59, 999)
  return { begin, end };
}

export function shiftMonth(dayPair: DayPair, left: boolean): DayPair {
  let deltaNumber = left ? -1 : 1;
  const begin = new Date(dayPair.begin); // 创建副本，避免修改原对象
  begin.setDate(1);
  begin.setMonth(begin.getMonth() + deltaNumber);

  const end = new Date(begin);
  end.setMonth(end.getMonth() + 1); // 跳到下个月
  end.setDate(0); // 设为上个月最后一天
  end.setHours(23, 59, 59, 999)

  return { begin, end };
}

export function formatDayBoundary(boundary: DayPair) {
  //周,月 ，年
  // let endDate = new Date(boundary.end.getTime() - 1)
  let endDate = new Date(boundary.end.getTime())
  return formatDateYMDHan(boundary.begin) + "-" + formatDateMDHan(endDate)
  //formatDateYMDHan(endDate);
}


export function shiftYear(dayPair: DayPair, left: boolean): DayPair {
  let deltaNumber = left ? -1 : 1;
  const beginYear = dayPair.begin.getFullYear() + deltaNumber;
  const begin = new Date(beginYear, 0, 1); // 月份从 0 开始（0=1月）

  //const end = new Date(beginYear + 1, 0, 1); // 12月=11
  const end = new Date(beginYear, 11, 31); // 12月=11
  end.setHours(23, 59, 59, 999)
  return { begin, end };
}

// 获取当前月份的第一天和最后一天
export function getMonthBoundaries(currentDateParam: Date): DayPair {
  let currentDate = new Date(currentDateParam)
  currentDate.setHours(0, 0, 0, 0)
  // 月份第一天（直接设为 1 号）
  const firstDay = new Date(currentDate);
  firstDay.setDate(1);

  // 月份最后一天：下个月的第 0 天即为本月最后一天
  const lastDay = new Date(firstDay);
  lastDay.setMonth(lastDay.getMonth() + 1); // 跳到下个月
  lastDay.setDate(0); // 设为上个月最后一天
  //let endDay = new Date(lastDay.getTime() - 1)
  lastDay.setHours(23, 59, 59, 999)
  return { begin: firstDay, end: lastDay };
}

export function getWeekBoundaries(currentDateParam: Date): DayPair {
  let currentDate = new Date(currentDateParam)
  currentDate.setHours(0, 0, 0, 0)
  const currentDay = currentDate.getDay(); // 0（周日）到 6（周六）

  // 计算到周一的天数差
  const diffToMonday = currentDay === 0 ? -6 : 1 - currentDay;
  const monday = new Date(currentDate);
  monday.setDate(currentDate.getDate() + diffToMonday);

  // 周日是周一加 6 天
  const sunday = new Date(monday);
  sunday.setDate(sunday.getDate() + 6);
  sunday.setHours(23, 59, 59, 999)

  return { begin: monday, end: sunday }
}

export function getDateDiffInDays(dateBegin: Date, dateEnd: Date): number {

  // 2. 计算时间戳差并转换为天数
  const timeDiff = Math.abs(dateEnd.getTime() - dateBegin.getTime());
  return Math.floor(timeDiff / (1000 * 60 * 60 * 24));
}

export function getMonthDiff(dateBegin: Date, dateEnd: Date): number {

  // 2. 计算时间戳差并转换为天数
  const timeDiff = Math.abs(dateEnd.getTime() - dateBegin.getTime());
  return Math.floor(timeDiff / (1000 * 60 * 60 * 24 * 30));
}


export function formatTime(time: number) {
  let dateTimeStamp = new Date(time).getTime()


  let minute = 1000 * 60;
  let hour = minute * 60;
  let day = hour * 24;

  let month = day * 30;
  let year = month * 12;
  let now = new Date().getTime();
  let diffValue = now - dateTimeStamp;
  let result = ""
  if (diffValue < 0) {
    return;
  }


  let monthC = diffValue / month;
  let weekC = diffValue / (7 * day);
  let dayC = diffValue / day;
  let hourC = diffValue / hour;
  let minC = diffValue / minute;
  let yearC = diffValue / year
  if (yearC >= 1) {
    return "" + parseInt(yearC.toString()) + "年前";
  }
  if (monthC >= 1) {
    result = "" + parseInt(monthC.toString()) + "月前";
  } else if (weekC >= 1) {
    result = "" + parseInt(weekC.toString()) + "周前";
  } else if (dayC >= 1) {
    result = "" + parseInt(dayC.toString()) + "天前";
  } else if (hourC >= 1) {
    result = "" + parseInt(hourC.toString()) + "小时前";
  } else if (minC >= 1) {
    result = "" + parseInt(minC.toString()) + "分钟前";
  } else {
    result = "刚刚";
  }

  return result;
}

/*
  2022/03/21 这样的
 */
export function formatDateYMD(date: Date): string {
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0'); // 月份从0开始，需要+1
  const day = String(date.getDate()).padStart(2, '0');
  return `${year}/${month}/${day}`;
}

export function formatDateYMD1(date: Date): string {
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0'); // 月份从0开始，需要+1
  const day = String(date.getDate()).padStart(2, '0');
  return `${year}-${month}-${day}`;
}

export function formatDateYM1(date: Date): string {
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0'); // 月份从0开始，需要+1

  return `${year}-${month}`;
}

export function formatDateYMDHan(date: Date): string {
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0'); // 月份从0开始，需要+1
  const day = String(date.getDate()).padStart(2, '0');
  return `${year}年${month}月${day}日`;
}


export function getDayOfWeek(date: Date): string {
  const daysOfWeek = ['周日', '周一', '周二', '周三', '周四', '周五', '周六'];
  return daysOfWeek[date.getDay()];
}

export function formatDateMDWeekHan(date: Date): string {
  // const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0'); // 月份从0开始，需要+1
  const day = String(date.getDate()).padStart(2, '0');
  const week = getDayOfWeek(date);
  return `${month}月${day}日 ${week}`;
}

export function formatDateYMHan(date: Date): string {
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0'); // 月份从0开始，需要+1
  return `${year}年${month}月`;
}

export function formatDateMDHan(date: Date): string {
  const month = String(date.getMonth() + 1).padStart(2, '0'); // 月份从0开始，需要+1
  const day = String(date.getDate()).padStart(2, '0');
  return `${month}月${day}日`;
}

export function trimEndZero(numberText: string): string {

  try {
    if (!numberText) {
      return numberText;
    }

    if (numberText.indexOf(".") == -1) {
      return numberText;
    }

    let length = numberText.length;
    let i = length - 1;
    for (; i > -1; --i) {
      if (numberText[i] != "0") {
        break;
      }
    }

    if (numberText[i] === ".") {
      --i;
    }

    return numberText.substring(0, i + 1)

  } catch (error) {
    console.log(error)
    return numberText;
  }

}

export function getIconCategoryBackcolor(item: RecordItemInfo, currentCategoryName: string): ResourceColor {
  if (item.category_name === currentCategoryName) {
    if (item.bill_type === BillTypeEnum.Outcome) {
      return getOutcomeIconBackColor();
    } else if (item.bill_type === BillTypeEnum.Income) {
      return getIncomeIconBackColor();
    } else {
      //not imp
      return getOutcomeIconBackColor();
    }

  } else {
    return getIconUnselectBackColor();
  }

}

export function getIconSelectImageColor(bill_type: BillTypeEnum) {
  return bill_type === 0 ? getOutcomeIconBackColor() : getIncomeIconBackColor();

}


export function getOutcomeIconBackColor() {
  return $r("app.color.danger");
}

export function getIncomeIconBackColor() {
  return Color.Green;
}

export function getIconUnselectBackColor() {
  return Color.Gray
}

export function roundAmountFen2Yuan(amount: number) {
  return Math.round(amount / 100)
}

export function formatFen(amount: number) {

  if (amount < 100) {
    return "0." + amount.toString().padStart(2, "0")
  } else {


    let str: string = amount.toString()
    let first = str.substring(0, str.length - 2)
    let second = str.substring(str.length - 2, str.length)
    let result = first + "." + second
    return result
  }

}


export function getDateAtMidnight(date: Date) {
  // 创建一个新的 Date 对象，避免修改原始日期
  const result = new Date(date.getTime());
  // 设置时间为当天的 0 点 0 分 0 秒
  result.setHours(0, 0, 0, 0);
  return result;
}


export async function test3() {

}