import { DefaultRecordList, RecordItemInfo } from '../models/RecordList'
import { formatTime, test1 } from '../utils/Util'

@Preview
@Component
struct WriteRecord {

  @State
  recordList: RecordItemInfo[] = DefaultRecordList


  build() {
    Column() {
      Column() {
        Row() {
          Stack({ alignContent: Alignment.End }) {
            Text("指尖记帐")
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor($r("app.color.text_primary"))
              .width("100%")
              .textAlign(TextAlign.Start)


            Image($r("app.media.search_24dp_1F1F1F"))
              .width(20)
              .height(20)//.fillColor($r("app.color.white"))
              .margin({
                right: 30
              })

          }
          .width("100%")

        }
        .padding(
          {
            left: 20
          }
        )
        .width("100%")
        .justifyContent(FlexAlign.End)
        .height(40)

      }.width("100%")
      //.backgroundColor($r("app.color.start_window_background"))
      //.backgroundColor("#fff")
      .backgroundColor($r("app.color.second_back_color"))

      Column()
        .height(10)
        .width("100%")




      //第一节
      Column() {

        Column() {


          Row() {

            Text("本月支出:")
              .fontSize(16)
              .fontColor($r("app.color.text_primary"))
            Text("￥100.00")
              .fontSize(18).fontWeight(FontWeight.Bold)


          }.width("100%")

          Row() {

            Text("本月收入:")
              .fontSize(16)
            Text("￥200.00")
              .fontSize(18).fontWeight(FontWeight.Bold)
              .fontColor($r("app.color.text_second"))

          }.width("100%")
          .margin(
            {
              top:10
            }
          )

          Row() {

            Text("预算剩余:")
              .fontSize(16)
            Text("￥200.00")
              .fontSize(18).fontWeight(FontWeight.Bold)

          }.width("100%")
          .margin(
            {
              top:10
            }
          )

        }
        .borderRadius(5)
        .height("100%")
        .width("100%")
        .backgroundColor($r("app.color.white"))
        .padding(
          {
            left: 10,
            top: 10,
            right: 10,
            bottom: 10
          }
        )

      }
      .height(130)
      .width("100%")
      .padding(
        {
          left: 10,
          right: 10,
          top: 10,
          bottom: 10
        }
      )
      .backgroundColor($r("app.color.back_color"))

      //第2节
      Column() {

        Column() {


          Row() {

            Text("今日支出:")
              .fontSize(16)
              .fontColor($r("app.color.text_primary"))
            Text("￥100.00")
              .fontSize(18).fontWeight(FontWeight.Bold)


          }.width("100%")

          Row() {

            Text("今日收入:")
              .fontSize(16)
            Text("￥200.00")
              .fontSize(18).fontWeight(FontWeight.Bold)
              .fontColor($r("app.color.text_second"))

          }.width("100%")
          .margin(
            {
              top:10
            }
          )



        }
        .borderRadius(5)
        .height("100%")
        .width("100%")
        .backgroundColor($r("app.color.white"))
        .padding(
          {
            left: 10,
            top: 10,
            right: 10,
            bottom: 10
          }
        )

      }
      .height(100)

      .width("100%")
      .padding(
        {
          left: 10,
          right: 10,
          top: 10,
          bottom: 10
        }
      )
      .backgroundColor($r("app.color.back_color"))


      //列表

      Column()
      {

        List() {
          ForEach(this.recordList, (item: RecordItemInfo) => {
            ListItem() {
              Row({ space: 10 }) {

               Row()
               {
                 Image(item.category_image)
                   .width(24)
                   .height(24)
                   .margin(
                     {
                       right:5
                     }
                   )

                 Text(item.category_name)
                   .fontSize(18)
               }.justifyContent(FlexAlign.Start)
               .padding(
                 {
                   left: 10,
                   top: 10,
                   right: 10,
                   bottom: 10
                 }
               )

                //右侧块
                Column()
                {
                  Text(`￥${item.amount}`)
                    .margin(
                      {
                        bottom:10
                      }
                    ).textAlign(TextAlign.End)
                    .fontWeight(FontWeight.Bold)
                   // .backgroundColor(Color.Pink)
                    .fontColor($r("app.color.text_primary"))


                  Text(formatTime(item.timestamp))
                    .textAlign(TextAlign.End)
                   // .backgroundColor(Color.Yellow)
                    .fontColor($r("app.color.text_second"))
                }.width(120)
                .alignItems(HorizontalAlign.End)

                .padding(
                  {

                    top:10,
                    right: 10,
                    bottom:10
                  }

                )
               // .backgroundColor(Color.Red)


              }.justifyContent(FlexAlign.SpaceBetween)
              .width("100%")


            }
          }
          )
        }  .backgroundColor($r("app.color.white"))
        .borderRadius(5)

      }

      .padding(
        {
          left: 10,
          top: 10,
          right: 10,
          bottom: 10
        }
      )


    }
    .width("100%")
    .height("100%")
    .backgroundColor($r("app.color.back_color"))
  }
}

export default WriteRecord