import { router } from '@kit.ArkUI';
import { RecordItemInfo } from '../models/RecordList';
import { DatabaseHelper } from '../utils/DatabaseHelper';
import { RoundImage } from './RoundImage';
import { formatDateYMDHan, formatFen, getIncomeIconBackColor, getOutcomeIconBackColor } from '../utils/Util';

@Preview
@Entry
@Component
struct BillDetail {
  @State showDialog: boolean = false // 控制对话框显示
  @Prop
  currentItem: RecordItemInfo;

  aboutToAppear(): void {

    this.currentItem = router.getParams() as RecordItemInfo;

  }

  formatBillAmount() {
    let result: string = ""
    if (this.currentItem.bill_type === 0) { //支出
      result = "-" + formatFen(this.currentItem.amount)
    } else if (this.currentItem.bill_type === 1) {
      result = formatFen(this.currentItem.amount) + ""
    }

    return result;
  }

  formatBillTypeName() {
    let result: string = ""
    if (this.currentItem.bill_type === 0) { //支出
      result = "支出"
    } else if (this.currentItem.bill_type === 1) {
      result = "收入"
    }

    return result;
  }

  formatMemoText() {
    let result: string = ""
    if (this.currentItem.notes === "") { //支出
      result = "--"
    } else {
      result = this.currentItem.notes;
    }

    return result;
  }

  build() {

    Column() {


      //第一行
      Row({ space: 0 }) {
        Image($r("app.media.ic_public_arrow_left"))
          .width(30)
          .height(30)

          .onClick(() => {
            router.back()

          })
          .zIndex(2)
          .margin(
            {
              left: 10,
              right: 10
            }
          )

        Text("详情") {
        }.fontSize(20)
        .fontWeight(FontWeight.Bold)
      }
      .width("100%")
      .height(48)
      .backgroundColor($r("app.color.white"))

      Column() {
      }.height(5)

      Column() {


        //列表

        Column() {

          Row({ space: 10 }) {
            Row() {
              RoundImage(
                {
                  contentWidth: 30,
                  imageUrl: this.currentItem.category_image,
                  backColor: this.currentItem.bill_type === 0 ? getOutcomeIconBackColor() : getIncomeIconBackColor()

                }
              ).margin(
                {
                  left: 0,
                  right: 10
                }
              )

              Text(this.currentItem.category_name)
            }
            //.width("100%")
            .height(60)

            //.backgroundColor(Color.Pink)

            Text(this.formatBillAmount())
              .margin(
                {
                  right: 10
                }
              )

          }.width("100%")
          .padding(
            {
              left: 10
            }
          )
          .justifyContent(FlexAlign.SpaceBetween)

          //第二行
          Row({ space: 0 }) {
            Text("收支类型")
            Text(this.formatBillTypeName())
              .margin(
                {
                  right: 10
                }
              )
          }.height(60)
          .width("100%")
          .padding(
            {
              left: 10
            }
          )
          .justifyContent(FlexAlign.SpaceBetween)

          //第三行
          Row({ space: 0 }) {
            Text("日期")
            Text(formatDateYMDHan(new Date(this.currentItem.timestamp)))
              .margin(
                {
                  right: 10
                }
              )
          }.height(60)
          .width("100%")
          .padding(
            {
              left: 10
            }
          )
          .justifyContent(FlexAlign.SpaceBetween)

          //第四行
          Row({ space: 0 }) {
            Text("备注")
            Text(this.formatMemoText())
              .width(150)
              .margin(
                {
                  right: 10
                }
              )
          }
          //.height(60)
          .width("100%")
          .padding(
            {
              left: 10
            }
          )
          .justifyContent(FlexAlign.SpaceBetween)

        }.backgroundColor($r("app.color.white"))
        .width("100%")
        .borderRadius(5)
        .padding(
          {
            left: 10,
            right: 10
          }
        )

      }.width("100%")
      .padding(
        {
          left: 10,
          right: 10
        }
      )


      //其它空间
      Column() {
      }
      .layoutWeight(1)

      Row() {
        Text('编辑')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)// .backgroundColor(Color.Pink)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
          .onClick(() => {
            router.pushUrl(
              {
                url: "pages/EditAccount",
                params: this.currentItem
              }
            )
          }
          )

        Divider()
          .vertical(true)
          .height('60%')// 设置高度为父容器的60%
          .strokeWidth(1)// 分割线宽度（逻辑像素）
          .color(Color.Gray)
          .margin({ left: 10, right: 10 }) // 调整左右边距
        Text('删除')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)// .backgroundColor(Color.Yellow)
          .textAlign(TextAlign.Center)
          .layoutWeight(1)
          .onClick(() => {

            this.getUIContext().showAlertDialog(
              {
                title: '确定删除',
                message: '是否确定删除这笔帐单',
                autoCancel: true,

                alignment: DialogAlignment.Center,
                offset: { dx: 0, dy: -20 },
                gridCount: 3,

                buttons: [{
                  value: '取消',

                  action: () => {
                    console.info('Callback when the first button is clicked')
                  },
                }
                  ,
                  {
                    enabled: true,
                    defaultFocus: true,
                    style: DialogButtonStyle.HIGHLIGHT,
                    value: '确定',
                    action: () => {
                      console.info('Callback when the second button is clicked')
                      //   del
                      DatabaseHelper.getInstance().deleteBill(this.currentItem.id)

                      router.pushUrl({
                        url: "pages/WriteRecord",
                        params: {}
                      })
                    }
                  }
                ]
              }
            )

          }
          )

      }.height(60)
      .width("100%")
      .backgroundColor($r("app.color.white"))

      //底部


    }.width
    ("100%"
    )
    .height
    ("100%"
    )
    .backgroundColor
    ($r
    ("app.color.back_color"
    ))
  }
}
