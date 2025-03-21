import { promptAction } from "@kit.ArkUI"

@Component
export struct NumberBoard {
  @State inputValue: string = ''

  @State
  dataList: string[] = ["1", "2", "3", "⌫","4", "5", "6", "+","7","8","9", "-", ".", '0', "再记", '确定']

  @State
  buttonBackColor:ResourceColor=$r("app.color.second_back_color")
  build() {
    Column() {



      // 键盘主体布局
      GridRow({ columns: 4 }) {
        ForEach(this.dataList, (item: string,index:number) => {
          GridCol() {

            Column()
            {
              Button(item)

                .borderWidth(0)
                //.borderRadius(0)
                .type(ButtonType.Normal)
                .fontColor($r("app.color.text_primary"))
                .backgroundColor(this.buttonBackColor)
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
                //.textAlign(TextAlign.Center)

                .width("100%")
                .height("100%")

            }
            .alignItems(HorizontalAlign.Center)
            .height(80)
            .width("100%")

             .onClick(() => this.handleInput(item)) // 输入事件‌:ml-citation{ref="4" data="citationList"}
          }
          .border({
            width: {
              left: 1,
              top: 1,
              right: 1,
              bottom: 1
            },
            color: '#cccccc'
          })
        })
      }

      .padding(0)


    }
  }



  private handleInput(value: string | number) {

    promptAction.showToast({
      message: `当前值:${value}`
    })

    if (typeof value === 'number') {
      this.inputValue += value.toString()
    } else {
      // 处理特殊符号输入‌:ml-citation{ref="8" data="citationList"}
    }
  }
}

