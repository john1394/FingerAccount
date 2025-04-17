import { promptAction, router } from '@kit.ArkUI'

import { CategoryItem, DefaultIncomeCategoryList, DefaultOutcomeCategoryList } from '../models/CategoryList'
import { DatabaseHelper } from '../utils/DatabaseHelper'
import { EditMemo } from './EditParts/EditMemo'

import { IncomeAndExpenditure } from './EditParts/IncomeAndExpenditure'
import { NumberBoard } from './EditParts/NumberBoard'

import { TimeSelector as TimeSelect } from './EditParts/TimeSelect'
import { RoundImage } from './RoundImage'
import { ValueType } from '@kit.ArkData'
import {
  formatFen,
  getIconCategoryBackcolor,
  getIncomeIconBackColor,
  getOutcomeIconBackColor,
  trimEndZero
} from '../utils/Util'
import { BillTypeEnum, RecordItemInfo } from '../models/RecordList'

@Entry
@Component
struct EditAccount {
  @State
  categoryList: CategoryItem[] = [];
  @Prop
  selectedImageColor: ResourceColor;
  @State
  inputAmountStr: string = "0"
  @State
  selectedDate: Date = new Date;
  @Prop
  currentItem: RecordItemInfo;
  updateSelectCategory = (name: string, image: string) => {

    this.currentItem.category_name = name;
    this.currentItem.category_image = image;

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
      this.currentItem.bill_type = BillTypeEnum.Income

    } else if (this.currentItem.bill_type === BillTypeEnum.Income) {
      this.currentItem.bill_type = BillTypeEnum.Outcome
    }

    this.categoryList = this.getCategoryList();

    this.currentItem.category_name = this.categoryList[0].category_name;

  }

  updateConfirm(isWriteAgain: boolean) {

    // let midNight: Date = getDateAtMidnight(this.selectedDate)
    let currentDate = new Date();
    let timestamp: number = new Date(this.selectedDate.getFullYear(), this.selectedDate.getMonth(),
      this.selectedDate.getDate(), currentDate.getHours(), currentDate.getMinutes(), currentDate.getSeconds()
    ,currentDate.getMilliseconds()
    ).getTime()

    //this.selectedDate.getTime()
    //midNight.getTime()
    let extra: string = ""
    let amountValue: number = Number(this.inputAmountStr)

    let fenMoney: number = Math.round(amountValue * 100);
    let bill_type: number = this.currentItem.bill_type;


    // 入库，id存在则更新，不存在则插入
    if (this.currentItem.id === 0) {
      let params: ValueType[] =
        [fenMoney, this.currentItem.category_name, bill_type, timestamp, this.currentItem.notes, extra]

      DatabaseHelper.getInstance().insertBill(params)
    } else {
      let params: ValueType[] =
        [fenMoney, this.currentItem.category_name, bill_type, timestamp, this.currentItem.notes, extra,
          this.currentItem.id]

      DatabaseHelper.getInstance().updateBill(params);
    }


    if (!isWriteAgain) {
      router.pushUrl({
        url: "pages/Index",
        params: {}
      })
    } else {


      this.updateMemo("")
      this.updateAmountValue("0")
      //后面的记录就是新加记录
      this.currentItem.id = 0;
      //清零
      promptAction.showToast({
        message: "记录成功"
      })

    }

  }

  aboutToAppear(): void {

    this.currentItem = router.getParams() as RecordItemInfo;
    if (this.currentItem === undefined) {
      this.currentItem =
        {
          id: 0,
          category_image: DefaultOutcomeCategoryList[0].category_image,
          category_name: DefaultOutcomeCategoryList[0].category_name,
          bill_type: 0,
          amount: 0,
          timestamp: new Date().getTime(),
          notes: ""
        }
    }

    this.selectedDate = new Date(this.currentItem.timestamp)
    this.categoryList = this.getCategoryList();

    this.selectedImageColor = this.currentItem.bill_type === 0 ? getOutcomeIconBackColor() : getIncomeIconBackColor();

    this.inputAmountStr = this.currentItem.amount === 0 ? "0" :
    trimEndZero(formatFen(this.currentItem.amount))


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
            //router.back()
            router.pushUrl({
              url: "pages/Index",
              params: {}
            })
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
                  //this.selectedCategoryName = this.getCategoryList()[0].category_name
                  this.currentItem.category_name = this.getCategoryList()[0].category_name

                  this.selectedImageColor = getOutcomeIconBackColor();
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

                }

                )

              if (this.currentItem.bill_type === BillTypeEnum.Income) {

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
                imageUrl: this.currentItem.category_image,
                //this.selectedCategoryImage,
                backColor:
                getIconCategoryBackcolor(this.currentItem, this.currentItem.category_name)
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

          inputValue: this.inputAmountStr,
          updateInputValue: (content: string) => {
            this.updateAmountValue(content)
          },

          updateConfirm: (writeAgain: boolean) => {
            this.updateConfirm(writeAgain)
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





