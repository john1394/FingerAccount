import { promptAction } from '@kit.ArkUI';

const MaxNumber: number = 100000000;

@Component
export struct NumberBoard {
  @State inputValue: string = ''
  @State amount: number = 0;
  @State
  dataList: string[] = ["1", "2", "3", "⌫", "4", "5", "6", "清零", "7", "8", "9", "-", ".", '0', "再记", '确定']
  @State
  buttonBackColor: ResourceColor = $r("app.color.second_back_color")
  @State
  prevType: number = 0; //0 为数字，1为加减号
  updateInputValue: (inputValue: string) => void = (inputValue: string) => {
  }
  updateConfirm: (isWriteAgain: boolean) => void = () => {
  }

  aboutToAppear(): void {


  }

  build() {
    Column() {


      // 键盘主体布局
      GridRow({ columns: 4 }) {
        ForEach(this.dataList, (item: string, index: number) => {
          GridCol() {

            Column() {

              if (item === "+"
                || item === "-"
              ) {
                Column() {
                }
                .width("100%")
                .height("100%")
                .backgroundColor(this.buttonBackColor)
              } else {

                Button(item)

                  .borderWidth(0)//.borderRadius(0)
                  .type(ButtonType.Normal)
                  .fontColor($r("app.color.text_primary"))
                  .backgroundColor(this.buttonBackColor)
                  .fontSize(20)
                  .fontWeight(FontWeight.Bold)//.textAlign(TextAlign.Center)

                  .width("100%")
                  .height("100%")
              }

            }
            .alignItems(HorizontalAlign.Center)
            .height(80)
            .width("100%")

            .onClick(() => this.handleInput(item, index))
          }
          .border({
            width: {
              left: 1,
              top: 1,
              right: 1,
              bottom: 1
            },
            color: '#cccccc'
          })
        })
      }

      .padding(0)

    }
  }

  private handleInput(value: string, index: number) {


    if (value === "0"
      || value === "1"
      || value === "2"
      || value === "3"
      || value === "4"
      || value === "5"
      || value === "6"
      || value === "7"
      || value === "8"
      || value === "9"
    ) {

      this.inputNumber(value, index);
    } else if (value === "⌫") {
      this.backspace(value, index);
    } else if (value === "清零") {
      this.clearValue();
    } else if (value === ".") {
      this.addDot();
    } else if (value === "确定") {
      this.confirm(false);
    } else if (value === "再记") {


      this.confirm(true);
      this.amount = 0;
      this.inputValue = "0"
    }


  }

  private reRecord(value: string, index: number) {

  }

  private confirm(writeAgain: boolean) {

    if (this.inputValue === "") {
      this.inputValue = "0"
    }

    let inputNumber = Number(this.inputValue)


    if (inputNumber === 0
    ) {
      promptAction.showToast({
        message: `金额不能是 0 啊!`
      })

      return
    }

    this?.updateConfirm(writeAgain)
  }

  private inputNumber(value: string, index: number) {


    if (this.inputValue === "0") {
      this.inputValue = value
      this.updateInputValue?.(this.inputValue);
      return
    }

    let dotIndex = this.inputValue.indexOf(".")
    if (dotIndex != -1) {
      //两个数字
      if (this.inputValue.length - 1 - dotIndex >= 2) {
        return
      }
    }

    //1.小数点后最多两个数字
    //2.总值不可超过maxnumber


    let targetValue = this.inputValue + value
    let targetNumber: number = Number(targetValue)

    //每天不超过1个小目标
    if (targetNumber > MaxNumber) {

      return
    }

    this.inputValue = targetValue

    this.updateInputValue?.(this.inputValue);

  }

  private backspace(value: string, index: number) {


    if (this.inputValue.length > 0) {
      this.inputValue = this.inputValue.substring(0, this.inputValue.length - 1);
    }

    if (this.inputValue === "") {
      this.inputValue = "0"
    }

    this.updateInputValue?.(this.inputValue);

  }

  private clearValue() {
    this.inputValue = "0"
    this.updateInputValue?.(this.inputValue);
  }

  private addDot() {
    if (this.inputValue.indexOf(".") != -1) {
      return
    }

    if (this.inputValue.length === 0) {
      this.inputValue = "0"
    }

    this.inputValue = this.inputValue + "."
    this.updateInputValue?.(this.inputValue);
  }
}

