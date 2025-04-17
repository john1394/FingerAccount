import { RoundImage } from '../pages/RoundImage'

@Component
export struct CategoryTopList {
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
        []
        //[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        , (item: number) => {
        Row() {

          RoundImage(
            {
              contentWidth: 30,
              imageUrl: $r("app.media.ic_cat_out_qita"),
              backColor: $r("app.color.danger")
            }
          )

          Column() {
            Row() {
              Row({ space: 10 }) {
                Text("理财")
                  .fontSize(14)
                Text("50.00%")
                  .fontSize(14)
              }

              Row({ space: 10 }) {
                Text("(共1笔)")
                  .fontSize(12)
                Text("8888.00")
                  .fontSize(14)
              }

            }.width("100%")
            .justifyContent(FlexAlign.SpaceBetween)

            Progress({ value: 20, total: 100, type: ProgressType.Linear }).style(
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