export interface BillDbRecord {
  // id
  id: number
  //帐本id
  bill_book_id: number,

  // 类型名称
  category: string
  //收支类型 0 为支出 ,1 为收入
  bill_type: number,

  //金额
  amount: number
  //记帐时间
  timestamp: number,

  //备注
  notes: string,

  //扩展列
  extra_fields: string
}

export interface BillDbRecordExport {
  // id
  id: number
  //帐本id
  bill_book_name: string,

  // 类型名称
  category: string
  //收支类型 0 为支出 ,1 为收入
  bill_type_name: string,
  //金额
  amountStr: string
  //记帐时间
  timeStr: string,
  //备注
  notes: string,

}


export interface RecordItemInfo {
  // 用户id
  id: number
  //帐本id
  bill_book_id: number,

  // 类型图片
  category_image: string | Resource
  // 类型名称
  category_name: string
  //收支类型 0 为支出 ,1 为收入
  bill_type: number,

  //金额
  amount: number
  //记帐时间
  timestamp: number,

  //备注
  notes: string

}

export enum BillTypeEnum {
  Outcome = 0, // 文本
  Income = 1, // 图片

}

// export const DefaultRecordList: RecordItemInfo[] = [
//
//   {
//     id: 123,
//     bill_book_id:1,
//     // 类型图片
//     category_image: $r("app.media.ic_cat_out_tongxun"),
//     // 类型名称
//     category_name: "其它",
//     bill_type: 0,
//     //金额
//     amount: 100,
//
//     //记帐时间
//     timestamp: 1742379786821,
//     notes: ""
//   },
//
// ]