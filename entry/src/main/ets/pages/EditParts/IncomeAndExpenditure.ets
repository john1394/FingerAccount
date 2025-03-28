import { CategoryItem, DefaultOutcomeCategoryList } from "../../models/CategoryList"
import { RecordItemInfo } from "../../models/RecordList";
import {
  getIconCategoryBackcolor,
  getIconUnselectBackColor, getIncomeIconBackColor, getOutcomeIconBackColor } from "../../utils/Util";
import { RoundImage } from "../RoundImage"

@Component
export struct IncomeAndExpenditure {
  @Prop
  categoryList: CategoryItem[]=[] ;

  // @Prop
  // selectedCategoryName: string="" ;

  @Prop
  selectedCategoryImage: string ="";


  @Prop
  bill_type:number=0;

  @Prop
  selectedImageColor:ResourceColor;

  @State
  blockHeight:number=210
    //186;
  @Prop
  currentItem: RecordItemInfo;



  // private getCategoryBackColor(item: CategoryItem): ResourceColor | undefined {
  //
  //   if(this.selectedCategoryName === item.category_name)
  //   {
  //     if(this.bill_type===0)
  //     {
  //       return getOutcomeIconBackColor();
  //     }
  //     else
  //     {
  //       return getIncomeIconBackColor();
  //     }
  //   }
  //   else
  //   {
  //     return getIconUnselectBackColor();
  //   }
  //
  //
  //   return this.selectedCategoryName === item.category_name ? this.selectedImageColor : Color.Gray
  // }

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
              Column({ space: 0 }) {
                RoundImage(
                  {
                    contentWidth: 50,
                    imageUrl: $r(item.category_image),

                    backColor:getIconCategoryBackcolor(this.currentItem,item.category_name)
                    //this.getCategoryBackColor(item)

                  }
                ).onClick(() => {
                  this.updateSelectCategory(item.category_name,item.category_image)
                  //this.selectedCategoryName=item.category_name
                  this.currentItem.category_name=item.category_name
                  //this.selectedCategoryImage=item.category_image

                }
                )

                //.fillColor($r("app.color"))
                Text(item.category_name)
                  .fontSize(14)
                  .textAlign(
                    TextAlign.Center
                  )
                  .width(60)

                  .margin(
                    {
                      top: 5
                    }
                  )

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
        //.height("100%")
        .alignItems(ItemAlign.Start)
        //.backgroundColor(Color.Pink)

      }.height("100%")
      .width('100%')
      .scrollable(ScrollDirection.Vertical)

    }
    .width("100%")
    .backgroundColor($r("app.color.white"))
  }
}