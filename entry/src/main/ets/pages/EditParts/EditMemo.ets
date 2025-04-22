import { BizConstants } from '../../utils/BizConstants'

@Component
export struct EditMemo {
  @Prop
  notesText: string = ""
  dialogController: CustomDialogController | null = new CustomDialogController({
    builder: CustomDialogExample({

      inputText: this.notesText,
      cancel: () => {
        this.onCancel()
      },
      confirm: (txt: string) => {
        this.onAccept(txt)
      }
    }),
    cancel: this.existApp,
    autoCancel: true,
    onWillDismiss: (dismissDialogAction: DismissDialogAction) => {
      console.info("reason=" + JSON.stringify(dismissDialogAction.reason))
      console.log("dialog onWillDismiss")
      if (dismissDialogAction.reason == DismissReason.PRESS_BACK) {
        dismissDialogAction.dismiss()
      }
      if (dismissDialogAction.reason == DismissReason.TOUCH_OUTSIDE) {
        dismissDialogAction.dismiss()
      }
    },
    alignment: DialogAlignment.Center,
    offset: { dx: 0, dy: -20 },
    customStyle: false,
    cornerRadius: 20,
    width: 300,
    height: 240,
    borderWidth: 1,
    borderStyle: BorderStyle.Dashed, //使用borderStyle属性，需要和borderWidth属性一起使用
    borderColor: Color.Green, //使用borderColor属性，需要和borderWidth属性一起使用
    backgroundColor: Color.Gray,
    shadow: ({
      radius: 20,
      color: Color.Grey,
      offsetX: 50,
      offsetY: 0
    }),
  })
  updateMemo: (inputValue: string) => void = (inputValue: string) => {
  }

  // 在自定义组件即将析构销毁时将dialogController置空
  aboutToDisappear() {
    this.dialogController = null // 将dialogController置空
  }

  onCancel() {
    console.info('onCancel')
  }

  onAccept(txt: string) {
    console.info('onAccept')

    this.notesText = txt;
    //this.memoShowText=this.notesText;
    // if(txt==="")
    // {
    //   this.memoShowText="添加备注"
    // }

    this.updateMemo?.(this.notesText)

  }

  existApp() {
    console.info('Click the callback in the blank area')
  }

  //@State

  //memoShowText:string="添加备注"
  getNotesShowText() {
    if (this.notesText === "") {
      return "添加备注"
    } else {
      return this.notesText;
    }
  }

  build() {


    Column() {
      Text(this.getNotesShowText())
        .width(200)
        .maxLines(1)
        .textOverflow(
          {
            overflow: TextOverflow.Ellipsis
          }
        )
        .margin(
          {
            left: 10,
            top: 10,
            bottom: 10
          }
        )
        .fontColor('#888888')//.backgroundColor(Color.Pink)
        .onClick(() => {

          if (this.dialogController != null) {
            this.dialogController.open()
          }
        }
        )

    }.width("100%")
    //.backgroundColor(Color.Pink)
    .alignItems(HorizontalAlign.Start)
  }
}

@CustomDialog
struct CustomDialogExample {
  controller?: CustomDialogController
  @State inputText: string = '';
  cancel: () => void = () => {

  }
  confirm: (txt: string) => void = (txt: string) => {
  }

  build() {
    Column() {

      Text('添加备注')
        .fontSize(24)
        .height(70)
      TextArea({ placeholder: '输入内容', text: this.inputText }


      )
        .defaultFocus(true)
        .maxLength(BizConstants.Max_Memo_char_count)
        .maxLines(5)
        .height(100)
        .id('text2')
        .onChange(

          value => {

            this.inputText = value
          }

        )


      Row({ space: 10 }) {
        Button('取消')
          .fontSize(20)
          .fontColor(Color.Green)
          .borderColor(Color.Green)
          .borderWidth(1)
          .backgroundColor(Color.White)
          .onClick(() => {
            this.cancel()

            this.controller?.close()
          })


        Button('确定')
          .fontSize(20)
          .fontColor(Color.White)
          .borderColor(Color.Green)
          .borderWidth(1)
          .backgroundColor(Color.Green)
          .onClick(() => {

            this.confirm(this.inputText)
            this.controller?.close()

          }
          )


      }
      //.backgroundColor(Color.Pink)
      .width("100%")


      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Center)

      .margin(
        {
          bottom: 10,
          top: 10
        }
      )

    }
  }
}