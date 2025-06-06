import { router } from '@kit.ArkUI';
import { PreferenceStore } from '../utils/PreferenceStore';
import { AutoBackupManager } from '../utils/AutoBackupManager';
import { DatabaseHelper } from '../utils/DatabaseHelper';
import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct WelcomePage {
  @State
  isShowDialog: boolean = false
  latestBackupFilePath: string = ""

  async aboutToAppear(): Promise<void> {
    //恢复卸载或者重装前的数据
    //1.检查是否有要恢复的备份数据
    //a. 目前没数据
    //b. 没恢复过
    //3. bak 目录下倒序，最新的一条
    //4. restore 到数据库

    try {

      let context = getContext(this)
      let manager = new AutoBackupManager(context)
      let backup = await manager.getLatestBackup()

      console.log("mylog", backup)

      if (backup) {
        this.latestBackupFilePath = backup
        this.isShowDialog = true
      } else {
        PreferenceStore.setIsDoneRestoreOldData(true)
        router.replaceUrl(
          {
            url: "pages/Index",
            params: {}
          }
        )
      }

    } catch (err) {
      const error = err as BusinessError;
      console.error(`WelcomePage failed, code: ${error.code}, message: ${error.message}`);
    }
  }

  async processRestore(yes: boolean): Promise<void> {

    if (yes) {
      if (this.latestBackupFilePath) {
        await DatabaseHelper.getInstance().restoreDb(this.latestBackupFilePath)
      }
    }

    PreferenceStore.setIsDoneRestoreOldData(true)

    router.replaceUrl(
      {
        url: "pages/Index",
        params: {}
      }
    )
  }

  build() {
    Column() {

      Stack() {
        Image("/assets/wallpaper/firstPageBackground.png")
          .objectFit(ImageFit.Cover)

        Row() {
          Column() {
            Row() {
              Text("恢复卸载或者重装前的数据?")
                .fontSize(20)
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


                  this.processRestore(false)
                  router.replaceUrl(
                    {
                      url: "pages/Index",
                      params: {}
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

                  this.processRestore(true)


                })
            }
            .height(49)
            .width('100%')

          }
        }
        .width(278)
        .borderRadius(12)
        .backgroundColor($r('app.color.white'))
        .visibility(this.isShowDialog ? Visibility.Visible : Visibility.None)

      }.width("100%")
      .height("100%")

    }
    .height('100%')
    .width('100%')
  }
}