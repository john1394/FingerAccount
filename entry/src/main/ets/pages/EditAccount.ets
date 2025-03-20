import { router } from '@kit.ArkUI'
import image from '@ohos.multimedia.image'
import { CategoryItem, DefaultCategoryList } from '../models/CategoryList'
import { RoundImage } from './RoundImage'

@Entry
@Component
struct EditAccount {
  @State
  showOutput: boolean = true
  @State
  categoryList: CategoryItem[] = DefaultCategoryList

  build() {

    Column() {
      //第一行
      Stack() {
        Image($r("app.media.ic_public_arrow_left"))
          .width(30)
          .height(30)
          .onClick(() => {
            router.back()
          })
          .zIndex(2)

        Column() {
          Row() {


            Column() {
              Text("支出")
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
                .margin(
                  {
                    bottom: 5
                  }
                )
                .onClick(() => {

                  animateTo({ duration: 300 }, () => {
                    this.showOutput = !this.showOutput
                  })

                }
                )

              if (this.showOutput) {
                Image($r("app.media.horizontal_rule_48dp_000000"))
                  .width(50)
                  .height(2)
              } else {
                Column().height(2).width(50)
              }

            }

            Column() {
              Text("收入")
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
                .margin(
                  {
                    bottom: 5
                  }
                )
                .onClick(() => {

                  animateTo({ duration: 300 }, () => {
                    this.showOutput = !this.showOutput
                  })

                }

                )

              if (!this.showOutput) {


                Image($r("app.media.horizontal_rule_48dp_000000"))
                  .width(50)
                  .height(2)
              } else {
                Column().height(2).width(50)
              }

            }

          }

        }.alignItems(HorizontalAlign.Center)
        .width("100%")
        .height(40)

      }.alignContent(Alignment.Start)
      .margin(
        {
          top: 10
        }
      )

      //第二行
      Column() {


        Row() {
          Row() {

            // Column() {
            //
            //   Image($r("app.media.restaurant_48dp_F3F3F3"))
            //     .width(24)
            //     .height(24)
            //   // .backgroundColor(Color.Grey)
            //
            //
            // }
            // .justifyContent(FlexAlign.Center)
            // .width(40)
            // .height(40)
            // .backgroundColor($r("app.color.danger"))
            // //.backgroundColor(Color.Gray)
            // .borderRadius(20)

            RoundImage(
              {
                contentWidth: 40,
                imageUrl: $r("app.media.restaurant_48dp_F3F3F3"),
                backColor: $r("app.color.danger")
              }
            ).margin(
              {
                left: 10
              }
            )


            Text("其它")
              .fontSize(20)
              .margin(
                {
                  left: 10
                }
              )


          }.width(100)

          // .backgroundColor(Color.Red)


          Text("￥10000")
            .fontSize(20).fontWeight(FontWeight.Bolder)
            .margin(
              {
                right: 10
              }
            )

        }.width("100%")
        .height(60)
        // .backgroundColor(Color.Pink)
        .justifyContent(FlexAlign.SpaceBetween)

      }
      .width("100%")
      .backgroundColor($r("app.color.white"))
      .margin(
        {
          bottom: 10
        }
      )

      //第三行，类型grid

      Column() {

        // ScrollContainer()
        //   .width('100%')
        //   .height('100%')
        //   .scrollDirection(ScrollDirection.Vertical) // 垂直滚动
        //   .childrenAlign(VerticalAlign.Start)
        //   .build() {
        // }
        // }

        Scroll() {

          GridRow({ columns: 5 }) {
            ForEach(this.categoryList, (item: CategoryItem) => {
              GridCol() {
                Column({ space: 6 }) {


                  RoundImage(
                    {
                      contentWidth: 40,
                      imageUrl: $r(item.category_image),
                      backColor: $r("app.color.danger")
                    }
                  )

                  //.fillColor($r("app.color"))
                  Text(item.category_name)
                    .fontSize(14)
                    .margin(
                      {
                        top:5
                      }
                    )
                  //.fontColor($r("app.color.white"))
                }
                .padding(
                  {
                    top: 10,
                    right: 10,
                    left: 10,
                    bottom: 10
                  }
                )
                .height(60)
                .onClick(() => {
                  // item.itemClick && item.itemClick()
                })

              }
              //.border({ width: { right: 1,bottom:1 }, color: '#cccccc' })

              .padding(
                {
                  top: 10,
                  right: 10,
                  left: 10,
                  bottom: 10
                }
              )
            })
          }

        }.height(175)
        .width('100%')
        //.backgroundColor(Color.Yellow)
        .scrollable(ScrollDirection.Vertical)

      }
      .width("100%")
      .backgroundColor($r("app.color.white"))

      //余下的空间
      Column() {
        Text("other space")
      }.width("100%")
      .layoutWeight(1)

    }.width("100%")
    .height("100%")
    .backgroundColor($r("app.color.back_color"))

  }
}



