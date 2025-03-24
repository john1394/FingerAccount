export interface RecordItemInfo {
  // 用户id
  id: number
  // 类型图片
  category_image: string|Resource
  // 类型名称
  category_name: string
  //金额
  amount: number
  //记帐时间
  timestamp: number
}

export const DefaultRecordList: RecordItemInfo[] = [

  {
    id: 123,
    // 类型图片
    category_image: $r("app.media.ic_edit"),
    // 类型名称
    category_name: "其它",
    //金额
    amount: 100,

    //记帐时间
    timestamp: 1742379786821
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