import { promptAction, router } from '@kit.ArkUI'

import { CategoryItem, DefaultIncomeCategoryList, DefaultOutcomeCategoryList } from '../models/CategoryList'
import { DatabaseHelper } from '../utils/DatabaseHelper'
import { EditMemo } from './EditParts/EditMemo'

import { IncomeAndExpenditure } from './EditParts/IncomeAndExpenditure'
import { NumberBoard } from './EditParts/NumberBoard'

import { TimeSelector as TimeSelect } from './EditParts/TimeSelect'
import { RoundImage } from './RoundImage'
import { ValueType } from '@kit.ArkData'
import { formatFen, getDateAtMidnight,
  getIconCategoryBackcolor,
  getIncomeIconBackColor, getOutcomeIconBackColor } from '../utils/Util'
import { BillTypeEnum, RecordItemInfo } from '../models/RecordList'

@Entry
@Component
struct EditAccount {
  @State
  categoryList: CategoryItem[] = [];
  @Prop
  selectedCategoryName: string = "其它"
  @Prop
  selectedImageColor: ResourceColor;
  @Prop
  selectedCategoryImage: ResourceStr
  @State
  inputAmountStr: string = "0"
  @State
  selectedDate: Date = new Date;
  @Prop
  currentItem: RecordItemInfo;
  updateSelectCategory = (name: string, image: string) => {
    this.selectedCategoryName = name;
    this.selectedCategoryImage = image;

  }

  updateAmountValue(inputValue: string) {

    this.inputAmountStr = inputValue;
    this.currentItem.amount = Math.round(Number(this.inputAmountStr) * 100)
  }

  updateSelectedDate(inputValue: Date) {

    this.selectedDate = inputValue;
  }

  updateMemo(inputValue: string) {
    //this.memoText = inputValue
    this.currentItem.notes = inputValue;
  }

  switchBillType() {
    if (this.currentItem.bill_type === BillTypeEnum.Outcome) {
      this.currentItem.bill_type =BillTypeEnum.Income
        //1
    } else if (this.currentItem.bill_type === BillTypeEnum.Income) {
      this.currentItem.bill_type = BillTypeEnum.Outcome
    }

    this.categoryList=this.getCategoryList();
    //this.selectedCategoryName=
    this.currentItem.category_name= this.categoryList[0].category_name;

  }

  updateConfirm() {
    // promptAction.showToast({
    //   message: `确认了:${this.inputAmount},${this.selectedCategoryName},${this.memoText},${this.selectedDate}`
    // })

    let midNight: Date = getDateAtMidnight(this.selectedDate)

    let timestamp: number = midNight.getTime()
    let extra: string = ""
    let amountValue: number = Number(this.inputAmountStr)

    let fenMoney: number = Math.round(amountValue * 100);
    let bill_type: number = this.currentItem.bill_type;
    //this.isOutput ? 0 : 1;


    if (this.currentItem.id === 0) {
      let params: ValueType[] =
        [fenMoney, this.selectedCategoryName, bill_type, timestamp, this.currentItem.notes, extra]

      DatabaseHelper.getInstance().insertBill(params)
    } else {
      let params: ValueType[] =
        [fenMoney, this.selectedCategoryName, bill_type, timestamp, this.currentItem.notes, extra, this.currentItem.id]

      DatabaseHelper.getInstance().updateBill(params);
    }


    router.pushUrl({
      url: "pages/WriteRecord",
      params: {}
    })
  }

  aboutToAppear(): void {

    this.currentItem = router.getParams() as RecordItemInfo;

    if (this.currentItem === undefined) {
      this.currentItem =
        {
          id: 0,
          category_image: $r("app.media.ic_edit"),
          category_name: "其它",
          bill_type: 0,
          amount: 0,
          timestamp: new Date().getTime(),
          notes: ""
        }
    }

    this.selectedCategoryName = this.currentItem.category_name;
    this.selectedCategoryImage = this.currentItem.category_image;
    this.selectedImageColor = this.currentItem.bill_type === 0 ? getOutcomeIconBackColor() : getIncomeIconBackColor();
    //$r("app.color.danger")
    this.inputAmountStr = this.currentItem.amount === 0 ? "0" : formatFen(this.currentItem.amount)
    this.categoryList = this.getCategoryList();
    //this.inputAmount=this.currentItem.amount;


  }

  getCategoryList(): CategoryItem[] {
    if (this.currentItem.bill_type === 0) {
      return DefaultOutcomeCategoryList;
    } else if (this.currentItem.bill_type === 1) {
      return DefaultIncomeCategoryList;

    }

    return []
  }

  build() {

    Column() {
      //第一行
      Stack() {
        Image($r("app.media.ic_public_arrow_left"))
          .width(30)
          .height(30)
          .onClick(() => {
            router.back()
          })
          .zIndex(2)

        Column() {
          Row() {
            Column() {
              Text("支出")
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
                .margin(
                  {
                    bottom: 5
                  }
                )
                .onClick(() => {


                  animateTo({ duration: 300 }, () => {
                    //this.isOutput = !this.isOutput
                    this.switchBillType();

                  })

                 // this.categoryList =this.getCategoryList();
                    //DefaultOutcomeCategoryList
                  //todo list长度要不为空
                  this.selectedCategoryName = this.getCategoryList()[0].category_name
                  this.selectedImageColor =getOutcomeIconBackColor();
                    //$r("app.color.danger")

                }
                )

              if (this.currentItem.bill_type === BillTypeEnum.Outcome) {
                Image($r("app.media.horizontal_rule_48dp_000000"))
                  .width(50)
                  .height(2)
              } else {
                Column().height(2).width(50)
              }
            }

            Column() {
              Text("收入")
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
                .margin(
                  {
                    bottom: 5
                  }
                )
                .onClick(() => {

                  animateTo({ duration: 300 }, () => {

                    this.switchBillType();

                  })

                  //this.categoryList =
                    //DefaultIncomeCategoryList
                  //this.selectedCategoryName =
                    //this.currentItem.category_name
                  //DefaultIncomeCategoryList[0].category_name
                  //this.selectedImageColor = Color.Green
                }

                )

              if (this.currentItem.bill_type ===BillTypeEnum.Income ) {

                Image($r("app.media.horizontal_rule_48dp_000000"))
                  .width(50)
                  .height(2)
              } else {
                Column().height(2).width(50)
              }

            }

          }

        }.alignItems(HorizontalAlign.Center)
        .width("100%")
        .height(40)

      }.alignContent(Alignment.Start)
      .margin(
        {
          top: 10
        }
      )

      //第二行
      Column() {


        Row() {
          Row() {
            RoundImage(
              {
                contentWidth: 40,
                imageUrl:this.currentItem.category_image,
                //this.selectedCategoryImage,
                backColor:getIconCategoryBackcolor(this.currentItem,this.currentItem.category_name)
                //this.selectedImageColor
              }
            ).margin(
              {
                left: 10
              }
            )

            Text(this.currentItem.category_name)
              .fontSize(20)
              .margin(
                {
                  left: 10
                }
              )
          }.width(100)

          Row() {
            Text("￥")
              .fontSize(20).fontWeight(FontWeight.Bolder)

            Text(this.inputAmountStr)//this.inputAmount
              .fontSize(20).fontWeight(FontWeight.Bolder)
              .margin(
                {
                  right: 10
                }
              )

          }

        }.width("100%")
        .height(60)
        // .backgroundColor(Color.Pink)
        .justifyContent(FlexAlign.SpaceBetween)

      }
      .width("100%")
      .backgroundColor($r("app.color.white"))
      .margin(
        {
          bottom: 2
        }
      )

      //第三行，类型grid

      IncomeAndExpenditure(
        {

          currentItem: this.currentItem,
          //selectedCategoryName:this.selectedCategoryName,

          updateSelectCategory: this.updateSelectCategory
        ,
          categoryList: this.categoryList
        ,
          selectedImageColor: this.selectedImageColor
        }

      ).height(230)

      //.layoutWeight(1)

      //第4行，备注
      EditMemo(
        {

          notesText: this.currentItem.notes,
          updateMemo: (content: string) => {
            this.updateMemo(content)
          },
        }

      )
        .height(40)// .backgroundColor(Color.Pink)
        .backgroundColor($r("app.color.white"))//.backgroundColor($r("app.color.second_back_color"))
        .borderWidth(1)
        .borderColor("#cccccc")
        .padding(
          {
            left: 5
          }
        )
        .margin(
          {
            top: 2
          }
        )

      //日期选择
      TimeSelect(
        {
          selectedDate: new Date(this.currentItem.timestamp),
          updateSelectedDate: (content: Date) => {
            this.updateSelectedDate(content)
          }
        },
      )
        .height
        (
          40
        )
        .backgroundColor
        (
          $r
          (
            "app.color.white"
          )
        )//.backgroundColor(Color.Pink)

          //($r("app.color.second_back_color"))
        .borderWidth
        (
          1
        )
        .borderColor
        (
          "#cccccc"
        )


      //数字键盘
      NumberBoard(
        {

          //amount: this.currentItem.amount,
          inputValue: this.inputAmountStr,
          updateInputValue: (content: string) => {
            this.updateAmountValue(content)
          },

          updateConfirm: () => {
            this.updateConfirm()
          }
        }

      )
        .layoutWeight
        (
          1
        )


    }.width("100%")
    .height("100%")
    .backgroundColor($r("app.color.back_color"))

  }
}





