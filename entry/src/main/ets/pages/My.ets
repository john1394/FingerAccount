import { router } from '@kit.ArkUI'

@Preview
@Component
struct My {
  @Builder
  getRenderItem(left: string, rightClick?: () => void) {
    Row() {
      Text(left)
      Image(
        $r("app.media.ic_public_right"))
        .width(16)
        .height(16)
    }
    .onClick(
      () => {
        if (rightClick) {
          rightClick()
        }
      }
    )
    .width('100%')
    .padding({
      left: 20,
      right: 20
    })
    .backgroundColor($r("app.color.white"))
    .height(60)
    .justifyContent(FlexAlign.SpaceBetween)
    .border({
      color:
      $r("app.color.border_color"),
      width: {
        bottom: 0.5
      }
    })
  }

  build() {
    Column() {
      // 顶部
      Row() {
        Row({ space: 10 }) {

          Column({ space: 10 }) {
            Text("指尖记帐").fontSize(18).fontColor($r('app.color.text_primary'))
            Text("邮箱：john1394@163.com").fontColor(
              $r('app.color.text_second')).fontSize(14)
          }.alignItems(HorizontalAlign.Start)
        }
        .layoutWeight(1)

        Image($r("app.media.ic_public_right"))
          .width(16)
          .height(16)
          .fillColor(
            $r('app.color.text_second'))
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .padding(30)
      .width('100%')
      .backgroundColor($r("app.color.white"))

      Row().height(10)
      this.getRenderItem("关于",
        () => {
          router.pushUrl({
            url: "pages/AboutPage",
            params: {}
          })
        }
      )


      Divider().strokeWidth(0.5)
        .width("90%")
        .color($r("app.color.text_second"))
      //Row().height(10)
      this.getRenderItem("用户协议",
        () => {
          router.pushUrl({
            url: "pages/UserAgreementPage",
            params: {}
          })
        }
      )

      Divider().strokeWidth(0.5)
        .width("90%")
        .color($r("app.color.text_second"))

      this.getRenderItem("隐私项",
        () => {
          router.pushUrl({
            url: "pages/PrivacyPage",
            params: {}
          })
        }
      )


      Divider().strokeWidth(0.5)
        .width("90%")
        .color($r("app.color.text_second"))


      this.getRenderItem("备份/恢复",
        () => {
          router.pushUrl({
            url: "pages/BackupRestorePage",
            params: {}
          })
        }

      )

      Divider().strokeWidth(0.5)
        .width("90%")
        .color($r("app.color.text_second"))
      //Row().height(10)
      this.getRenderItem("设置")
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.back_color'))
  }
}

export default My