import { CategoryItem, DefaultOutcomeCategoryList } from "../../models/CategoryList"
import { RoundImage } from "../RoundImage"

@Component
export struct IncomeAndExpenditure {
  @Prop
  categoryList: CategoryItem[] ;

  @Prop
  selectedCategoryName: string ;

  @Prop
  selectedCategoryImage: string ="";

  @Prop
  isOutput: boolean ;

  @Prop
  selectedImageColor:ResourceColor;

  @State
  blockHeight:number=210
    //186;



  private getCategoryBackColor(item: CategoryItem): ResourceColor | undefined {
    return this.selectedCategoryName === item.category_name ? this.selectedImageColor : Color.Gray
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

        GridRow({ columns: 4 }) {
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


                  this.updateSelectCategory(item.category_name,item.category_image)
                  this.selectedCategoryName=item.category_name
                  this.selectedCategoryImage=item.category_image

                }
                )

                //.fillColor($r("app.color"))
                Text(item.category_name)
                  .fontSize(14)
                  .textAlign(
                    TextAlign.Center
                  )
                  .width(60)
                 // .backgroundColor(Color.Orange)
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
              .height(70)


            }
           // .backgroundColor(Color.Pink)
            //.border({ width: { left:1,top:1, right: 1,bottom:1 }, color: '#cccccc' })

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

      }.height("100%")
      .width('100%')
      //.backgroundColor(Color.Yellow)
      .scrollable(ScrollDirection.Vertical)

    }
    .width("100%")
    .backgroundColor($r("app.color.white"))
  }
}