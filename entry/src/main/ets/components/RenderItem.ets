@Component
export struct BackHeader {
  @Prop
  text: string = ""

  click: () => void = () => {
  }

  build() {
    //第一行
    Row({ space: 0 }) {
      Image($r("app.media.ic_public_arrow_left"))
        .width(24)
        .height(24)
        .onClick(() => {

          if(this.click)
          {
            this.click()
          }

        })

      Text(this.text) {
      }
      .fontSize(16)
      .layoutWeight(1)
      .fontWeight(FontWeight.Bold)
      .textAlign(TextAlign.Center)
    }
    .padding(
      {
        right: 24
      }
    )
    .width("100%")
    .height(48)
    .backgroundColor($r("app.color.white"))
  }
}