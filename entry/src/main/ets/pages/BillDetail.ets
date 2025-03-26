import { router } from '@kit.ArkUI'
import { RecordItemInfo } from '../models/RecordList'
import { DatabaseHelper } from '../utils/DatabaseHelper';
import { RoundImage } from './RoundImage'

@Preview
@Entry
@Component
struct BillDetail {
  @Prop
  currentItem: RecordItemInfo;

  aboutToAppear(): void {

    // router.getParams() as
    this.currentItem = router.getParams() as RecordItemInfo;

  }


  build() {

    Column() {
      Column() {
        Row({ space: 10 }) {
          Image($r("app.media.ic_public_arrow_left"))
            .width(30)
            .height(30)
            .onClick(() => {
              router.back()
              // router.back(
              //   {
              //     url:"pages/WriteRecord",
              //     params: { refresh: true }
              //   }
              // )
            })
            .zIndex(2)
            .margin(
              {
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

        //列表

        Column() {
          List({ space: 10 }) {


            ListItem() {

              Row({ space: 10 }) {
                Row() {
                  RoundImage(
                    {
                      contentWidth: 40,
                      imageUrl: $r("app.media.ic_edit"),
                      backColor: $r("app.color.danger")
                    }
                  ).margin(
                    {
                      left: 10,
                      right: 20
                    }
                  )

                  Text("餐饮")
                }
                .height(60)

                //.backgroundColor(Color.Gray)

                Text("-8.00")
                  .margin(
                    {
                      right: 10
                    }
                  )

              }.width("100%")
              .justifyContent(FlexAlign.SpaceBetween)

            }


            ListItem() {
              Text("second")
            }.height(40)
          }

          .width("100%")

          // .backgroundColor(Color.Pink)

        }.borderRadius(5)
        .backgroundColor($r("app.color.white"))

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
        Text('编辑').fontSize(20)
          .fontWeight(FontWeight.Bold)// .backgroundColor(Color.Pink)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

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

            //del
            DatabaseHelper.getInstance().deleteBill(this.currentItem.id)
            //router.back()
            router.pushUrl({
              url: "pages/WriteRecord",
              params: {}
            })

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
