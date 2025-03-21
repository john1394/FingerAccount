import { formatDateyyyymmdd as formatDateymd } from "../../utils/Util"

@Component
export struct TimeSelector {
  private selectedDate: Date = new Date()

  @State
  dateText:string="今天"

  @State
  selectedToday:boolean=true

  build() {

    Column() {
      Row({ space: 5 }) {

        if(this.selectedToday) {
          Image($r("app.media.calendar_today_48dp_434343"))
            .width(30).height(30)


          Text("今天")
        }
        else
        {
          Text(this.dateText)
        }

      }.width(100)
      .onClick(() => {
        this.getUIContext().showDatePickerDialog
        ({
          // 建议使用 this.getUIContext().showDatePickerDialog()接口
          start: new Date("2000-1-1"),
          end: new Date("2100-12-31"),
          selected: this.selectedDate,
          showTime: false,
          useMilitaryTime: true,
          disappearTextStyle: { color: Color.Pink, font: { size: '22fp', weight: FontWeight.Bold } },
          textStyle: { color: '#ff00ff00', font: { size: '18fp', weight: FontWeight.Normal } },
          selectedTextStyle: { color: '#ff182431', font: { size: '14fp', weight: FontWeight.Regular } },
          onDateAccept: (value: Date) => {
            // 通过Date的setFullYear方法设置按下确定按钮时的日期，这样当弹窗再次弹出时显示选中的是上一次确定的日期
            this.selectedDate = value
            console.info("DatePickerDialog:onDateAccept()" + value.toString())

            this.dateText= formatDateymd(this.selectedDate)

            if(formatDateymd(this.selectedDate)===formatDateymd(new Date()))
            {
              this.selectedToday=true;
            }
            else
            {
              this.selectedToday=false;
            }
          },
          onCancel: () => {
            console.info("DatePickerDialog:onCancel()")
          },
          onDateChange: (value: Date) => {
            console.info("DatePickerDialog:onDateChange()" + value.toString())
          },
          onDidAppear: () => {
            console.info("DatePickerDialog:onDidAppear()")
          },
          onDidDisappear: () => {
            console.info("DatePickerDialog:onDidDisappear()")
          },
          onWillAppear: () => {
            console.info("DatePickerDialog:onWillAppear()")
          },
          onWillDisappear: () => {
            console.info("DatePickerDialog:onWillDisappear()")
          }
        })
      }
      )

      //.backgroundColor(Color.Pink)

    }.alignItems(HorizontalAlign.Start)
    .padding(
      {
        left: 10
      }
    )
    .width('100%')
    .height('100%')
  }
}