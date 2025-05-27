import web_webview from '@ohos.web.webview';
import { BackHeader } from '../components/RenderItem';
import { router } from '@kit.ArkUI';

@Entry
@Component
struct PrivacyPage {
  @State htmlContent: string = "";

  build() {
    Column() {
      BackHeader(
        {
          click: () => {
            router.back()
          }

        }
      )
      // 使用 Web 组件加载本地 HTML

      Column() {
        Web({
          src: $rawfile('doc/privacy.html'), // 指定 HTML 文件路径
          controller: new web_webview.WebviewController()
        })
          .width('100%')// 设置宽度
          .height('100%') // 设置高度
      }.width("100%")
      .height("100%")
      .backgroundColor(Color.Pink)

    }
    .justifyContent(FlexAlign.Start)
    .height('100%')
    .width('100%')

  }
}