import { CategoryItem, DefaultCategoryList } from "../../models/CategoryList"
import { RoundImage } from "../RoundImage"

@Component
export struct IncomeAndExpenditure {
  @State
  categoryList: CategoryItem[] = DefaultCategoryList

  @Prop
  selectedCategoryName: string = "其它"

  @Prop
  selectedCategoryImage: string ="";

  private getCategoryBackColor(item: CategoryItem): ResourceColor | undefined {
    return this.selectedCategoryName === item.category_name ? $r("app.color.danger") : Color.Gray
  }

  updateSelectCategory = (name: string,image:string) => {

  }

  aboutToAppear(): void {
   // this.selectedCategoryImage="app.media.other_houses_48dp_F3F3F3";
  }

  build() {
    //第三行，类型grid
    Column() {

      Scroll() {

        GridRow({ columns: 5 }) {
          ForEach(this.categoryList, (item: CategoryItem) => {
            GridCol() {
              Column({ space: 6 }) {


                RoundImage(
                  {
                    contentWidth: 40,
                    imageUrl: $r(item.category_image),

                    backColor:
                    this.getCategoryBackColor(item)

                  }
                ).onClick(() => {

                  //this.selectedCategoryName = item.category_name
                  //this.selectedCategoryImage = item.category_image
                  this.updateSelectCategory(item.category_name,item.category_image);

                }
                )

                //.fillColor($r("app.color"))
                Text(item.category_name)
                  .fontSize(14)
                  .margin(
                    {
                      top: 5
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
  }
}