import { CategoryItem } from '../../models/CategoryList';
import { RecordItemInfo } from '../../models/RecordList';
import { getIconCategoryBackcolor } from '../../utils/Util';
import { RoundImage } from '../RoundImage';

@Component
export struct IncomeAndExpenditure {
  @Prop
  categoryList: CategoryItem[] = [];
  @Prop
  selectedCategoryImage: string = "";
  @Prop
  bill_type: number = 0;
  @Prop
  selectedImageColor: ResourceColor;
  @State
  blockHeight: number = 210
  //186;
  @Prop
  currentItem: RecordItemInfo;
  updateSelectCategory = (name: string, image: string) => {

  }

  aboutToAppear(): void {

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

                    backColor: getIconCategoryBackcolor(this.currentItem, item.category_name)

                  }
                ).onClick(() => {

                  if (item.category_name === "设置") {
                    // router.pushUrl({
                    //   url: "pages/CategoryManage",
                    //   params: { "a": "b" }
                    // })
                    console.log("to be continued")
                  } else {

                    this.updateSelectCategory(item.category_name, item.category_image)
                    this.currentItem.category_name = item.category_name
                  }

                }
                )

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

        .alignItems(ItemAlign.Start)

        //.backgroundColor(Color.Yellow)

      }
      .align(Alignment.Top)
      .height("100%")
      .width('100%')
      .scrollable(ScrollDirection.Vertical)
      //.backgroundColor(Color.Pink)
      .scrollBar(BarState.Off)

    }
    .width("100%")
    .backgroundColor($r("app.color.white"))
  }
}