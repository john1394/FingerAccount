import { promptAction, router } from '@kit.ArkUI'

import { CategoryItem, DefaultIncomeCategoryList, DefaultOutcomeCategoryList } from '../models/CategoryList'
import { DatabaseHelper } from '../utils/DatabaseHelper'
import { EditMemo } from './EditParts/EditMemo'

import { IncomeAndExpenditure } from './EditParts/IncomeAndExpenditure'
import { NumberBoard } from './EditParts/NumberBoard'

import { TimeSelector as TimeSelect } from './EditParts/TimeSelect'
import { RoundImage } from './RoundImage'
import { ValueType } from '@kit.ArkData'
import { getDateAtMidnight } from '../utils/Util'
import { RecordItemInfo } from '../models/RecordList'

@Entry
@Component
struct EditAccount {
  @Provide
  isOutput: boolean = true
  @State
  categoryList: CategoryItem[] = DefaultOutcomeCategoryList

  @Prop
  selectedCategoryName: string = "其它"
  @Prop
  selectedImageColor: ResourceColor;
  @Prop
  selectedCategoryImage: ResourceStr
  @State
  memoText: string = ""
  @State
  inputAmount: string = "0"
  @State
  selectedDate: Date = new Date;

  @Prop
  currentItem:RecordItemInfo;

  updateSelectCategory = (name: string, image: string) => {
    this.selectedCategoryName = name;
    this.selectedCategoryImage = image;

  }

  updateAmountValue(inputValue: string) {

    this.inputAmount = inputValue;
  }

  updateSelectedDate(inputValue: Date) {

    this.selectedDate = inputValue;
  }

  updateMemo(inputValue: string) {
    this.memoText = inputValue
  }

  switchBillType()
  {
    if(this.currentItem.bill_type===0)
    {
      this.currentItem.bill_type=1
    }
    else if(this.currentItem.bill_type===1)
    {
      this.currentItem.bill_type=0
    }
  }

  updateConfirm() {
    // promptAction.showToast({
    //   message: `确认了:${this.inputAmount},${this.selectedCategoryName},${this.memoText},${this.selectedDate}`
    // })

    let midNight: Date = getDateAtMidnight(this.selectedDate)

    let timestamp: number = midNight.getTime()
    let extra: string = ""
    let amountValue: number = Number(this.inputAmount)

    let fenMoney: number = Math.round(amountValue * 100);
    let bill_type:number=this.isOutput?0:1;

    let params: ValueType[] = [fenMoney, this.selectedCategoryName,bill_type, timestamp, this.memoText, extra]
    DatabaseHelper.getInstance().insertBill(params)


    router.pushUrl({
      url: "pages/WriteRecord",
      params: {}
    })
  }

  aboutToAppear(): void {

    this.currentItem= router.getParams() as RecordItemInfo;

    if(this.currentItem===undefined)
    {
     this.currentItem=
       {
         id:0,
         category_image: $r("app.media.ic_edit"),
         category_name: "其它",
         bill_type:1,
         amount: 0,
         timestamp: new Date().getTime(),
         notes:""
       }
    }

    this.selectedCategoryName =this.currentItem.category_name;
    this.selectedCategoryImage = this.currentItem.category_image;
    this.selectedImageColor = $r("app.color.danger")

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

                  this.categoryList = DefaultOutcomeCategoryList
                  //todo list长度要不为空
                  this.selectedCategoryName = DefaultOutcomeCategoryList[0].category_name
                  this.selectedImageColor = $r("app.color.danger")

                }
                )

              //if (this.isOutput)
              if(this.currentItem.bill_type===0)
              {
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
                    //this.isOutput = !this.isOutput
                   this.switchBillType();

                  })

                  this.categoryList = DefaultIncomeCategoryList
                  this.selectedCategoryName = DefaultIncomeCategoryList[0].category_name
                  //this.selectedImageColor=$r("app.color.image_green")
                  this.selectedImageColor = Color.Green
                }

                )

              //if (!this.isOutput)
              if(this.currentItem.bill_type===1)
              {

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
                imageUrl: this.selectedCategoryImage,

                backColor: this.selectedImageColor
                //$r("app.color.danger")
              }
            ).margin(
              {
                left: 10
              }
            )


            Text(this.selectedCategoryName)
              .fontSize(20)
              .margin(
                {
                  left: 10
                }
              )


          }.width(100)

          // .backgroundColor(Color.Red)
          Row() {
            Text("￥")
              .fontSize(20).fontWeight(FontWeight.Bolder)

            Text(this.inputAmount).fontSize(20).fontWeight(FontWeight.Bolder)
              .margin(
                {
                  right: 10
                }
              )
            // .onClick( ()=>
            // {
            //   this.inputAmount="2.0"
            // })
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
          isOutput:this.isOutput,
          updateSelectCategory: this.updateSelectCategory
        , categoryList: this.categoryList
        , selectedImageColor: this.selectedImageColor
        }

      ).height(230)

      //.layoutWeight(1)

      //第4行，备注
      EditMemo(
        {

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





