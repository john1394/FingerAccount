import { TabBarClass } from '../models/tab'
import BillReport from './BillReport'
import My from './My'
import WriteRecord from './WriteRecord'


@Entry
@Component
struct Index {
  @State
  tabBarList: TabBarClass[] = [
    {
      icon: $r('app.media.ic_public_message'),
      name: 'WriteRecord',
      title: '记帐',
      selectIcon: $r('app.media.ic_public_message_filled')
    },
    {
      icon: $r('app.media.ic_gallery_discover'),
      name: 'report',
      title: '报表',
      selectIcon: $r('app.media.ic_gallery_discover_filled')
    },
    {
      icon: $r('app.media.ic_public_contacts'),
      name: 'my',
      title: '我的',
      selectIcon: $r('app.media.ic_public_contacts_filled')
    }
  ]
  @State
  currentIndex: number = 0

  aboutToAppear(): void {

  }

  @Builder
  CommonTabBar(item: TabBarClass) {
    Column() {
      Image(this.tabBarList[this.currentIndex].name === item.name ? item.selectIcon : item.icon)
        .width(20)
        .height(20)

      Text(item.title)
        .fontSize(12)
        .fontColor(this.tabBarList[this.currentIndex].name == item.name ? $r("app.color.primary") :
        $r("app.color.text_primary"))
        .margin({
          top: 5
        })
    }
  }

  build() {
    Column() {
      Tabs({ index: $$this.currentIndex }) {
        ForEach(this.tabBarList, (item: TabBarClass) => {
          TabContent() {
            if (item.name === "WriteRecord") {
              WriteRecord()
            } else if (item.name === "report") {
              BillReport()
            } else if (item.name === "my") {
              My()
            }
          }.tabBar(this.CommonTabBar(item))

        })
      }
      .barPosition(BarPosition.End)
      .animationDuration(300)
      .edgeEffect(
        EdgeEffect.Spring
      )
    }
    .width("100%")
    .height("100%")

  }
}



