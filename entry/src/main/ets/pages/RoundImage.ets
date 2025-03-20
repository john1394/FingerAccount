@Component
export struct RoundImage {


  @Prop
  contentWidth:number=40


  @Prop
  imageUrl:ResourceStr=""

  @Prop
  backColor:ResourceColor=""

  build() {

    Column() {

      Image(this.imageUrl)
        .width(this.contentWidth-16)
        .height(this.contentWidth-16)


    }
    .justifyContent(FlexAlign.Center)
    .width(this.contentWidth)
    .height(this.contentWidth)
     .backgroundColor(this.backColor)
    //.backgroundColor(Color.Gray)
    .borderRadius(this.contentWidth/2)
  }
}