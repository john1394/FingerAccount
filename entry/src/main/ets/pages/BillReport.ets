import { DEFAULT } from '@ohos/hypium';
import { ColumnData } from '../models/BillReportModel'


@Preview
@Entry
@Component
struct BillReport {
  @Prop
  isOutput: boolean = true

  @State
  DateSelectBorderWidth: number = 3;
  @State columns: ColumnData[] = [
    new ColumnData('week', "周", true),
    new ColumnData('month', "月", false),
    new ColumnData('year', "年", false),
    new ColumnData('custom', "自定义", false),
  ];

  updateSelectColumn(selectedItem: ColumnData) {

    let newColumns: ColumnData[] = [];

    this.columns.forEach((item) => {
      if (item.uid === selectedItem.uid) {
        item.selected = true;
        //this.selectedColumn=item.uid;
      } else {
        item.selected = false;
      }

      newColumns.push(item);
    })

    this.columns = newColumns;
  }

  build() {

    Column() {

      //第一行
      Column() {

        Row({ space: 10 }) {

          Column() {
            Text("支出")
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .margin(
                {
                  top: 10
                }
              )

            Column() {
            }
            .height("3vp")
            .width("56vp")
            .margin(
              {
                left: 10,
                right: 5,
                top: 5,
                bottom: 5
              }
            )
            .backgroundColor(this.isOutput ? Color.Black : Color.Transparent)
          }
          .height("100%")
          .alignItems(HorizontalAlign.Center)
          .justifyContent(FlexAlign.Center)
          //.backgroundColor(Color.Gray)
          .width("100%")
          .layoutWeight(1)
          .onClick(() => {
            this.isOutput = !this.isOutput
          })


          Column() {
            Text("收入")
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .margin(
                {
                  top: 10
                }
              )

            Column() {
            }
            .height("3vp")
            .width("56vp")
            .margin(
              {
                left: 5,
                right: 10,
                top: 5,
                bottom: 5
              }
            )
            .backgroundColor(!this.isOutput ? Color.Black : Color.Transparent)
          }
          .height("100%")
          .alignItems(HorizontalAlign.Center)
          .justifyContent(FlexAlign.Center)
          //.backgroundColor(Color.Gray)
          .width("100%")
          .layoutWeight(1)
          .onClick(() => {
            this.isOutput = !this.isOutput
          })

        }
        .width("150vp")
        .height("100%")
        //.backgroundColor(Color.Pink)
        .justifyContent(FlexAlign.Center)

        //.height("60vp")
      }.width("100%")
      .height("50vp")
      .alignItems(HorizontalAlign.Center)

      //.backgroundColor(Color.Orange)

      //第二行
      Row() {

        Row() {

          ForEach(this.columns, (item: ColumnData, index: number) => {

            Column() {
              Text(item.txt)
                .fontColor(item.getFontColor())
                .fontSize(20)
                .fontWeight(FontWeight.Normal)
            }
            .backgroundColor(item.getBackColor())
            .width("100%")
            .height("100%")
            .borderWidth(
              index != this.columns.length - 1 ? {
                left: this.DateSelectBorderWidth,
                top: this.DateSelectBorderWidth,
                bottom: this.DateSelectBorderWidth
              } :
                {
                  left: this.DateSelectBorderWidth,
                  top: this.DateSelectBorderWidth,
                  bottom: this.DateSelectBorderWidth,
                  right: this.DateSelectBorderWidth,
                }
            )
            .borderColor(Color.Black)
            .layoutWeight(1)
            .alignItems(HorizontalAlign.Center)
            .justifyContent(FlexAlign.Center)
            .onClick(() => {
              this.updateSelectColumn(item);
            })

          })


        }.width("100%")
        .height("100%")

      }.padding(
        {
          left: 10,
          right: 10,
          top: 10,
          bottom: 10
        }
      ).width("100%")
      .height(60)

      //第三行
      Row() {
        Column() {
          Image($r("app.media.arrow_circle_left_48dp_000000"))
            .width(40)
            .height(40)

        }.height("100%")
        //.backgroundColor(Color.Brown)
        .justifyContent(FlexAlign.Center)

        .layoutWeight(1)

        Column() {
          Text("2025年03月24日-2025年03月30日")
         // Text("2025年03月")
            .fontSize(16)


        }.layoutWeight(4)


        Column() {
          Image($r("app.media.arrow_circle_right_48dp_000000"))
            .width(40)
            .height(40)
        }.height("100%")
        .justifyContent(FlexAlign.Center)
        .layoutWeight(1)

      }
      .backgroundColor($r("app.color.back_color"))
      //.backgroundColor(Color.Pink)
      .width("100%")
      .alignItems(VerticalAlign.Center)
      .height(50)


      // .backgroundColor(Color.Pink)

    }
    .width("100%")
    .height("100%")
    //.backgroundColor(Color.Pink)
    .backgroundColor($r("app.color.back_color"))

  }
}

export default BillReport
