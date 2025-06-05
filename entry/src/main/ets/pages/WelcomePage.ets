import { router } from '@kit.ArkUI';

@Entry
@Component
struct WelcomePage {
  @State message: string = 'Hello World';

  aboutToAppear(): void {

    router.pushUrl(
      {
        url: "pages/index",
        params: {}
      }
    )
  }

  build() {
    Column() {

      Text("欢迎回来!!")
    }
    .height('100%')
    .width('100%')
  }
}