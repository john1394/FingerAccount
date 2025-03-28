@Component
export struct RoundImage {


  @Prop
  contentWidth:number=40
  @Prop
  innerPadding:number=12

  @Prop
  imageUrl:ResourceStr=""

  @Prop
  backColor:ResourceColor=""

  build() {

    Column() {

      Image(this.imageUrl)
        .width(this.contentWidth-this.innerPadding)
        .height(this.contentWidth-this.innerPadding)

    }
    .justifyContent(FlexAlign.Center)
    .width(this.contentWidth)
    .height(this.contentWidth)
     .backgroundColor(this.backColor)
    //.backgroundColor(Color.Gray)
    .borderRadius(this.contentWidth/2)
  }
}