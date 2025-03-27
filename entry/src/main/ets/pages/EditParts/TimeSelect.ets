import { formatDateYMD, formatDateYMD as formatDateymd, formatDateYMDHan } from "../../utils/Util"

@Component
export struct TimeSelector {
  @State
  selectedDate: Date = new Date()
  @State
  dateText: string = "今天"
  @State
  selectedToday: boolean = true
  updateSelectedDate: (inputValue: Date) => void = () => {
  }

  selectedDayIsToday() {
    let today = new Date();
    let todayStr = formatDateYMD(today)
    let selectedStr = formatDateYMD(this.selectedDate);
    if (todayStr === selectedStr) {
      return true
    } else {
      return false;
    }
  }

  getDataStr()
  {
    if(this.selectedDayIsToday())
    {
      return "今天"
    }
    else
    {
      return formatDateYMDHan(this.selectedDate)
    }
  }

  build() {

    Column() {
      Row({ space: 5 }) {

        if (this.selectedDayIsToday()) {
          Image($r("app.media.calendar_today_48dp_434343"))
            .width(24).height(24)


          Text("今天")
        } else {
          Text(formatDateYMDHan(this.selectedDate))
        }

      }.width(150)
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

            this.dateText =this.getDataStr();
              //formatDateymd(this.selectedDate)

            if (formatDateymd(this.selectedDate) === formatDateymd(new Date())) {
              this.selectedToday = true;
            } else {
              this.selectedToday = false;
            }

            this.updateSelectedDate?.(this.selectedDate);
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

    }
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Center)
    .padding(
      {
        left: 10
      }
    )
    .width('100%')
    .height('100%')
  }
}