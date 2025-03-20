import { router } from '@kit.ArkUI'

import { CategoryItem, DefaultCategoryList } from '../models/CategoryList'
import { IncomeAndExpenditure } from './EditParts/IncomeAndExpenditure'
import { RoundImage } from './RoundImage'

@Entry
@Component
struct EditAccount {
  @State
  showOutput: boolean = true
  @State
  categoryList: CategoryItem[] = DefaultCategoryList

  @Prop
  selectedCategoryName: string

  @Prop
  selectedCategoryImage: string

  updateSelectCategory = (name: string,image:string) => {
    this.selectedCategoryName=name;
    this.selectedCategoryImage=image;
  }

  aboutToAppear(): void {
    this.selectedCategoryName="其它"
    this.selectedCategoryImage="app.media.other_houses_48dp_F3F3F3"
  }

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

            RoundImage(
              {
                contentWidth: 40,
                imageUrl: $r(this.selectedCategoryImage),

                backColor: $r("app.color.danger")
              }
            ).margin(
              {
                left: 10
              }
            )


            Text( this.selectedCategoryName)
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
      // Column() {
      //
      //   Scroll() {
      //
      //     GridRow({ columns: 5 }) {
      //       ForEach(this.categoryList, (item: CategoryItem) => {
      //         GridCol() {
      //           Column({ space: 6 }) {
      //
      //
      //             RoundImage(
      //               {
      //                 contentWidth: 40,
      //                 imageUrl: $r(item.category_image),
      //
      //                 backColor:
      //                 this.getCategoryBackColor(item)
      //
      //               }
      //             ).onClick(() => {
      //
      //               this.selectedCategoryName = item.category_name
      //               this.selectedCategoryImage = item.category_image
      //
      //             }
      //             )
      //
      //             //.fillColor($r("app.color"))
      //             Text(item.category_name)
      //               .fontSize(14)
      //               .margin(
      //                 {
      //                   top: 5
      //                 }
      //               )
      //             //.fontColor($r("app.color.white"))
      //           }
      //           .padding(
      //             {
      //               top: 10,
      //               right: 10,
      //               left: 10,
      //               bottom: 10
      //             }
      //           )
      //           .height(60)
      //           .onClick(() => {
      //             // item.itemClick && item.itemClick()
      //           })
      //
      //         }
      //         //.border({ width: { right: 1,bottom:1 }, color: '#cccccc' })
      //
      //         .padding(
      //           {
      //             top: 10,
      //             right: 10,
      //             left: 10,
      //             bottom: 10
      //           }
      //         )
      //       })
      //     }
      //
      //   }.height(175)
      //   .width('100%')
      //   //.backgroundColor(Color.Yellow)
      //   .scrollable(ScrollDirection.Vertical)
      //
      // }
      // .width("100%")
      // .backgroundColor($r("app.color.white"))
      //

      IncomeAndExpenditure(
        {
         updateSelectCategory:this.updateSelectCategory
        }

      )


      //余下的空间
      Column() {
        Text("other space")
      }.width("100%")
      .layoutWeight(1)

    }.width("100%")
    .height("100%")
    .backgroundColor($r("app.color.back_color"))

  }

  private getCategoryBackColor(item: CategoryItem): ResourceColor | undefined {
    return this.selectedCategoryName === item.category_name ? $r("app.color.danger") : Color.Gray
  }
}



