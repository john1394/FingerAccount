import { hilog } from "@kit.PerformanceAnalysisKit";

export  function  test1()
{
  const DOMAIN = 0x0000;
  let a1=Date.now()

  //hilog.info("", '调试信息: %s',a1.toString());

//  console.info("a1value:"+a1.toString())
 // hilog.info(DOMAIN,  '%{a1value2}s', a1.toString());
  let str1= formatTime(a1)
  hilog.info(0,"str1:%s",str1)
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
export  function formatDateyyyymmdd(date: Date): string {
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0'); // 月份从0开始，需要+1
  const day = String(date.getDate()).padStart(2, '0');
  return `${year}/${month}/${day}`;
}

export function getDateAtMidnight(date:Date) {
  // 创建一个新的 Date 对象，避免修改原始日期
  const result = new Date(date.getTime());
  // 设置时间为当天的 0 点 0 分 0 秒
  result.setHours(0, 0, 0, 0);
  return result;
}

