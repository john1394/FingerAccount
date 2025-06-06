import { router } from '@kit.ArkUI'

@Component
export struct RestoreDataConfirm {
  build() {
    Row() {
      Column() {
        Row() {
          Text("是否从备份中恢复数据?")
            .fontSize(24)
            .fontColor($r('app.color.text_primary'))
        }
        .width('100%')
        .height(88)
        .justifyContent(FlexAlign.Center)
        .border({
          color: $r('app.color.background_divider'),
          width: {
            bottom: 0.5
          }
        })

        Row() {
          Text("否")
            .fontSize(24)
            .textAlign(TextAlign.Center)
            .fontColor($r('app.color.text_secondary'))
            .layoutWeight(1)
            .border({
              color: $r('app.color.background_divider'),
              width: {
                right: 0.5
              }
            })
            .height('100%')
            .onClick(async () => {

              AlertDialog.show(
                {
                  message: "good"
                }
              )
            })

          Text("是")
            .fontSize(24)
            .textAlign(TextAlign.Center)
            .fontColor($r('app.color.text_primary'))
            .layoutWeight(1)
            .border({
              color: $r('app.color.background_divider'),
              width: {
                right: 0
              }
            })
            .height('100%')
            .onClick(async () => {

              AlertDialog.show(
                {
                  message: "done"
                }
              )

              // router.pushUrl(
              //   {
              //"pages/BillDetail",
              //     url: "pages/index",
              //     params: {}
              //   }
              // )

              // router.pushUrl(
              //   {
              //     url: "pages/index",
              //     params: {}
              //   }
              // )

            })
        }
        .height(49)
        .width('100%')

      }
    }
    .width(278)
    .borderRadius(12)
    .backgroundColor($r('app.color.white'))
  }
}