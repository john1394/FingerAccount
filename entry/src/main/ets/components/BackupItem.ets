import { BackupInfoRecord, PopupItem } from '../models/BackupModel';


@Component
export struct BackupItem {
  @Prop
  backupRecord: BackupInfoRecord;
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
      itemClick: () => {

        this.showPopup = false
        this.deleteBackupItem(this.backupRecord.backupFilePath)
      }
    }
  ]
  deleteBackupItem: (path: string) => void = () => {
  }

  //
  // @Prop
  // context:Context;

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

  build() {
    Column({ space: 0 }) {
      Text("备份 " + this.backupRecord.timeStr)
        .height(40)// .onClick(() => {
          //   this.showPopup = true
          // })
        .bindPopup(this.showPopup, {
          builder: this.getContent,
          popupColor: $r("app.color.popup_back"),
          backgroundBlurStyle: BlurStyle.NONE,
          onStateChange: (event) => {
            this.showPopup = event.isVisible
          }
        })
        .gesture(LongPressGesture().onAction(() => {
          // 绑定长按的手势
          this.showPopup = true
        }))


    }.width("100%")
    .justifyContent(FlexAlign.Center)
  }
}