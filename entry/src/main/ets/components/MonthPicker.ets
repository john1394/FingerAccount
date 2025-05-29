@Component
export struct MonthPicker {
  @State
  isShowSheet: boolean = false;
  @State
  selectYearIndex: number = 0;
  @State
  selectMonthIndex: number = 0;
  @State
  yearPicked: string = "";
  @State
  monthPicked: string = ""
  @Prop
  currentMonthBegin: Date;
  private years: string[] = []
  private months: string[] = []
  private line1Height = 60;
  private line2Height = 200;
  updateMonthData: (yearPicked: string, monthPicked: string) => void = () => {
  }

  aboutToAppear(): void {


    let startYear = 2020;
    let maxYearCount = 20;
    for (let i = 0; i < maxYearCount; i++) {
      this.years.push((i + startYear).toString() + "年")
    }

    for (let i = 1; i <= 12; i++) {
      this.months.push(i.toString() + "月")
    }

    //let current = new Date()

    let yearIndex = this.years.findIndex(item => item.includes(this.currentMonthBegin.getFullYear().toString()))
    if (yearIndex != -1) {
      this.selectYearIndex = yearIndex;
    }

    let monthIndex = this.months.findIndex(item => item.includes((this.currentMonthBegin.getMonth() + 1).toString()))
    if (monthIndex != -1) {
      this.selectMonthIndex = monthIndex;
    }

    this.yearPicked = this.years[this.selectYearIndex]
    this.monthPicked = this.months[this.selectMonthIndex]
  }

  @Builder
  SheetBuilder() {

    Column() {
      Row() {
        Text("取消").fontColor($r("app.color.text_second"))
          .fontWeight(FontWeight.Bold)
          .fontSize(18)
          .onClick(() => {
            this.isShowSheet = false
          })

        Text("确定").fontColor($r("app.color.text_primary"))
          .fontWeight(FontWeight.Bold).fontSize(18)
          .onClick(() => {


            this.isShowSheet = false

            this.yearPicked = this.years[this.selectYearIndex]
            this.monthPicked = this.months[this.selectMonthIndex]
            this.updateMonthData(this.yearPicked, this.monthPicked)
          })


      }
      .width("100%")
      .height(this.line1Height)
      .justifyContent(FlexAlign.SpaceBetween)

      .padding(
        {
          top: 10,
          left: 50,
          right: 50,
          bottom: 10
        }
      )


      Row() {
        TextPicker({ range: this.years, selected: $$this.selectYearIndex })
          .width("50%")
          .onChange((value: string | string[], index: number | number[]) => {
            console.info('Picker item changed, value: ' + value + ', index: ' + index)

            // this.yearPicked = this.years[index as number]
          })

        TextPicker({ range: this.months, selected: $$this.selectMonthIndex })
          .width("50%")
      }

      .width("100%")
      .height(this.line2Height)

    }.width("100%")
    .height("100%")

    .backgroundColor($r("app.color.back_color"))

  }

  build() {

    Row({ space: 5 }) {

      Row() {
        Text(`${this.yearPicked}${this.monthPicked}支出`)
          .fontSize(16)

          .bindSheet($$this.isShowSheet, this.SheetBuilder(), {
            detents: [this.line1Height + this.line2Height],
            preferType: SheetType.BOTTOM,
            dragBar: false
          ,
            showClose: false
          })

        Image($r("app.media.fill_arrow_down"))
          .width(20)
          .height(20)
      }
      .onClick(() => {
        this.isShowSheet = !this.isShowSheet
      })

    }.width("100%")

    .height(40)
  }
}