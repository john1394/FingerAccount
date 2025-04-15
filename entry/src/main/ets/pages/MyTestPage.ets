@Entry
@Component
struct MyTestPage {
  @State message: string = 'Hello World';

  build() {
    Column() {
      Text("test me")
    }
    .height('100%')
    .width('100%')
  }
}