@Entry
@Component
struct SearchTestPage {
  @State message: string = 'Hello World';

  build() {
    Column() {

      Search({ value: "", placeholder: 'Type to search...' })
        .searchButton('SEARCH')
        .width('95%')
        .height(40)
        .backgroundColor('#F5F5F5')
        .placeholderColor(Color.Grey)
        .placeholderFont({ size: 14, weight: 400 })
        .textFont({ size: 14, weight: 400 })
        .onSubmit((value: string) => {
          // this.submitValue = value
          console.log("mylog", "submit", value)
        })
        .onChange((value: string) => {
          // this.changeValue = value
          console.log("mylog", "change", value)
        })
        .margin(20)

      // Search(
      //   { placeholder: "输入备注/类别/金额" }
      // ) {
      //
      // }.onSubmit( ()=>
      // {
      //   console.log("mylog","submit")
      // })
    }
    .height('100%')
    .width('100%')
  }
}