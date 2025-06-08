import { BackHeader } from '../components/RenderItem';
import { router } from '@kit.ArkUI';
import { AutoBackupManager } from '../utils/AutoBackupManager';
import { BackupInfoRecord } from '../models/BackupModel';

@Entry
@Component
struct BackupAndRestorePage {
  @State
  isLoading: boolean = false
  @State
  backupList: BackupInfoRecord[] = []

  async aboutToAppear(): Promise<void> {

    //1. 从download 目录查询备份文件列表，从新到旧排序
    await this.reloadBackupList()

  }

  async reloadBackupList() {
    let context = getContext(this)
    let manager = new AutoBackupManager(context)
    this.backupList = await manager.getAllBackupFiles()
  }

  async backup() {

    let context = getContext(this)
    let manager = new AutoBackupManager(context)
    let backupDir = await manager.createDownloadPackageDir()
    let succeed = await manager.manualBackup(backupDir)


    if (succeed) {
      await this.reloadBackupList()
    }

    //await mockLongTime(5000)
    this.isLoading = false

  }

  build() {
    Column() {

      BackHeader(
        {
          click: () => {
            router.back()
          }

        })

      //主内容

      Column() {

        Column({ space: 10 }) {

          Column() {
            Button("新建备份", { type: ButtonType.Normal })
              .width("100%")
              .height(36)
              .border({ width: 1, color: Color.Black })// 蓝色细边框
              .fontColor($r("app.color.text_primary"))
              .fontWeight(FontWeight.Medium)
              .fontSize(20)
              .backgroundColor(Color.Transparent)
              .borderRadius(8)
              .onClick(() => {

                //todo 主动备份时，不删除超量的？
                this.isLoading = true
                this.backup()
              })
              .enabled(!this.isLoading)
          }.padding(
            {
              left: 10,
              right: 10,
              top: 10

            }
          )

          if (this.isLoading) {
            Row({ space: 10 }) {
              LoadingProgress().width(30).height(30)
              Text("正在处理中...")
                .fontSize(12)
                .fontColor($r("app.color.text_second"))
            }
          }


          Column() {


            List({ space: 0 }) {

              ForEach(this.backupList,
                (item: BackupInfoRecord) => {
                  ListItem() {
                    Column({ space: 0 }) {
                      Text("备份 " + item.timeStr)
                        .height(40)

                      // Divider().strokeWidth(0.5)
                      //   .width("100%")
                      //   .color($r("app.color.text_second"))

                    }.width("100%")
                    // .backgroundColor($r("app.color.back_color"))


                    .justifyContent(FlexAlign.Center)
                  }
                  .borderRadius(5)
                  .backgroundColor($r("app.color.white"))

                }
              )

            }
            .divider({
              strokeWidth: 0.5,

            })
            .width("100%")
            .height("100%")

            // .backgroundColor(Color.Pink)

          }

          //.layoutWeight(1)
          .padding(10)
          //.backgroundColor($r("app.color.white"))
          //.backgroundColor(Color.Pink)
          .borderRadius(8)
          .width("100%")
          .height("100%")

        }
        .width("100%")
        .height("100%")

      }
      //外面的
      .width("100%")
      .height("100%")

      //.backgroundColor(Color.Pink)


    }
    .backgroundColor($r('app.color.back_color'))
    .height('100%')
    .width('100%')
  }
}