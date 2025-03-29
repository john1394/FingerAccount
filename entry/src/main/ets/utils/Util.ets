import { hilog } from "@kit.PerformanceAnalysisKit";
import { BillTypeEnum, RecordItemInfo } from "../models/RecordList";

export function test1() {
  const DOMAIN = 0x0000;
  let a1 = Date.now()

  let str1 = formatTime(a1)
  hilog.info(0, "str1:%s", str1)
}


export interface DayPair {
  begin: Date;
  end: Date;
}

// 获取当前年份的第一天和最后一天
export function getYearBoundaries(currentDate: Date): DayPair {

  const currentYear = currentDate.getFullYear();
  // 年的第一天（1月1日）
  const firstDay = new Date(currentYear, 0, 1); // 月份从 0 开始（0=1月）

  // 年的最后一天（12月31日）
  const lastDay = new Date(currentYear, 11, 31); // 12月=11

  return { begin: firstDay, end: lastDay };
}

// 将当前时间向前移动一周
export function shiftWeek(dayPair: DayPair, left: boolean): DayPair {
  let dayNumber = left ? -7 : 7;
  const begin = new Date(dayPair.begin); // 创建副本，避免修改原对象
  begin.setDate(begin.getDate() + dayNumber); // 增加 7 天

  const end = new Date(dayPair.end); // 创建副本，避免修改原对象
  end.setDate(end.getDate() + dayNumber); // 增加 7 天
  return { begin, end };
}

export function shiftMonth(dayPair: DayPair, left: boolean): DayPair {
  let deltaNumber = left ? -1 : 1;
  const begin = new Date(dayPair.begin); // 创建副本，避免修改原对象
  begin.setDate(1);
  begin.setMonth(begin.getMonth()+deltaNumber);

  const end = new Date(begin);
  end.setMonth(end.getMonth() + 1); // 跳到下个月
  end.setDate(0); // 设为上个月最后一天

  return { begin, end };
}

export function shiftYear(dayPair: DayPair, left: boolean): DayPair {
  let deltaNumber = left ? -1 : 1;
  const beginYear = dayPair.begin.getFullYear()+deltaNumber;
  const begin = new Date(beginYear, 0, 1); // 月份从 0 开始（0=1月）
  const end = new Date(beginYear, 11, 31); // 12月=11
  return { begin, end };
}

// 获取当前月份的第一天和最后一天
export function getMonthBoundaries(currentDate: Date): DayPair {

  // 月份第一天（直接设为 1 号）
  const firstDay = new Date(currentDate);
  firstDay.setDate(1);

  // 月份最后一天：下个月的第 0 天即为本月最后一天
  const lastDay = new Date(firstDay);
  lastDay.setMonth(lastDay.getMonth() + 1); // 跳到下个月
  lastDay.setDate(0); // 设为上个月最后一天

  return { begin: firstDay, end: lastDay };
}

export function getWeekBoundaries(currentDate: Date): DayPair {
  const currentDay = currentDate.getDay(); // 0（周日）到 6（周六）

  // 计算到周一的天数差
  const diffToMonday = currentDay === 0 ? -6 : 1 - currentDay;
  const monday = new Date(currentDate);
  monday.setDate(currentDate.getDate() + diffToMonday);

  // 周日是周一加 6 天
  const sunday = new Date(monday);
  sunday.setDate(sunday.getDate() + 6);

  return { begin: monday, end: sunday }
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

export function formatDateYMDHan(date: Date): string {
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0'); // 月份从0开始，需要+1
  const day = String(date.getDate()).padStart(2, '0');
  return `${year}年${month}月${day}日`;
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

export function getOutcomeIconBackColor() {
  return $r("app.color.danger");
}

export function getIncomeIconBackColor() {
  return Color.Green;
}

export function getIconUnselectBackColor() {
  return Color.Gray
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

