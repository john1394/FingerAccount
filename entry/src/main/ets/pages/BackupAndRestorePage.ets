import { BackHeader } from '../components/RenderItem';
import { router } from '@kit.ArkUI';
import { AutoBackupManager } from '../utils/AutoBackupManager';
import { BackupInfoRecord, PopupItem } from '../models/BackupModel';
import { BackupItem } from '../components/BackupItem';

@Entry
@Component
struct BackupAndRestorePage {
  @State
  showPopup: boolean = false
  // 弹层菜单的数据
  @State
  popupList: PopupItem[] = [
    {
      title: '恢复',
      icon: $r("app.media.restore"),

    },
    {
      title: '删除',
      icon: $r("app.media.delete"),
      itemClick: async () => {
        // 删除首选项的数据
        AlertDialog.show({
          message: "deleted"
        })
      }
    }
  ]
  @State
  isLoading: boolean = false
  @State
  backupList: BackupInfoRecord[] = []

  async deleteBackupItem(path: string) {

    this.isLoading = true
    let context = getContext(this)
    let manager = new AutoBackupManager(context)
    let bakDir = await manager.createDownloadPackageDir()
    if (bakDir) {
      await manager.deleteBackupItemInner(path)
      await this.reloadBackupList()
    }

    this.isLoading = false

  }

  //
  // async deleteBackupItemReal(path: string) {
  //
  //   //await mockLongTime(5 * 1000)
  //   let context = getContext(this)
  //   let manager = new AutoBackupManager(context)
  //   await manager.createDownloadPackageDir()
  //   await manager.deleteBackupItemInner(path)
  //   await this.reloadBackupList()
  //   this.isLoading = false
  // }

  @Builder
  getContent() {
    GridRow({ columns: 5 }) {
      ForEach(this.popupList, (item: PopupItem) => {
        GridCol() {
          Column({ space: 6 }) {
            Image(item.icon)
              .width(18)
              .aspectRatio(1)
              .fillColor($r("app.color.white"))
            Text(item.title)
              .fontSize(14)
              .fontColor($r("app.color.white"))
          }
          .height(60)
          .onClick(() => {
            item.itemClick && item.itemClick()
          })
        }
      })

    }
    .width(300)
    .padding({
      left: 10,
      top: 15,
      bottom: 10
    })
  }

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

                    BackupItem(
                      {
                        backupRecord: item,

                        deleteBackupItem: (path: string) => {
                          this.deleteBackupItem(path)
                        }


                      }
                    )
                    // Column({ space: 0 }) {
                    //   Text("备份 " + item.timeStr)
                    //     .height(40)
                    //     .onClick(() => {
                    //       this.showPopup = true
                    //     })
                    //     .bindPopup(this.showPopup, {
                    //       builder: this.getContent,
                    //       popupColor: $r("app.color.popup_back"),
                    //       backgroundBlurStyle: BlurStyle.NONE,
                    //       onStateChange: (event) => {
                    //         this.showPopup = event.isVisible
                    //       }
                    //     })
                    //   // .gesture(LongPressGesture().onAction(() => {
                    //   //   // 绑定长按的手势
                    //   //   this.showPopup = true
                    //   // }))
                    //
                    //
                    // }.width("100%")
                    // .justifyContent(FlexAlign.Center)


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