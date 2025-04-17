import { CategoryListData } from '../models/BillReportModel';
import { RoundImage } from '../pages/RoundImage';

@Component
export struct CategoryTopList {
  @Prop
  categoryList: CategoryListData[] = [
    {
      categoryName: "其它",
      categoryImage: $r("app.media.ic_cat_out_qita"),
      percentValue: 50,
      count: 2,
      amount: 7,
      imageBackColor: $r("app.color.danger")
    }
  ]

  build() {

    Column({ space: 10 }) {
      Row({ space: 10 }) {
        Image($r("app.media.rank"))
          .width(30)
          .height(30)
        Text("排行榜")
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
      }.width("100%")
      .padding(10)

      ForEach(
        this.categoryList
        , (item: CategoryListData) => {
        Row() {

          RoundImage(
            {
              contentWidth: 30,
              imageUrl: item.categoryImage,
              backColor: item.imageBackColor
            }
          )

          Column() {
            Row() {
              Row({ space: 10 }) {
                Text(item.categoryName)
                  .fontSize(14)
                Text(item.percentValue.toFixed(2) + "%")
                  .fontSize(14)
              }

              Row({ space: 10 }) {
                Text(`(共${item.count}笔)`)
                  .fontSize(12)
                Text((item.amount / 100).toFixed(2))
                  .fontSize(14)
              }

            }.width("100%")
            .justifyContent(FlexAlign.SpaceBetween)

            Progress({ value: item.percentValue, total: 100, type: ProgressType.Linear }).style(
              {
                strokeWidth: 6
              }
            )
              .width("100%").height(30)
          }
          .layoutWeight(1)
          .padding(10)

        }.height(40)
        .padding(
          {
            left: 10
          }
        )

      })


    }.width("100%")
    .justifyContent(FlexAlign.Start)
    .padding(
      {
        bottom: 20
      }
    )


    // .height(480)

  }
}