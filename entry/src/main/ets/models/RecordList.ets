export interface RecordItemInfo {
  // 用户id
  id: number
  // 类型图片
  category_image: string|Resource
  // 类型名称
  category_name: string
  //收支类型 0 为支出 ,1 为收入
  bill_type:number,
  //金额
  amount: number
  //记帐时间
  timestamp: number,
  //备注
  notes:string

}

export const DefaultRecordList: RecordItemInfo[] = [

  {
    id: 123,
    // 类型图片
    category_image: $r("app.media.ic_edit"),
    // 类型名称
    category_name: "其它",
    bill_type:0,
    //金额
    amount: 100,

    //记帐时间
    timestamp: 1742379786821,
    notes:""
  },
  // {
  //   id: "123",
  //   // 类型图片
  //   category_image: $r("app.media.ic_edit"),
  //   // 类型名称
  //   category_name: "其它",
  //   //金额
  //   amount: 100,
  //
  //   //记帐时间
  //   timestamp: 1742379786821
  // },
  // {
  //   id: "123",
  //   // 类型图片
  //   category_image: $r("app.media.ic_edit"),
  //   // 类型名称
  //   category_name: "其它",
  //   //金额
  //   amount: 100,
  //
  //   //记帐时间
  //   timestamp: 1742379786821
  // }
]