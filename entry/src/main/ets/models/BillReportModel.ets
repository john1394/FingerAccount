export enum ReportTimeRangeEnum {
  Week = 0,
  Month = 1,
  Year = 2,
  Custom = 3
}

export interface LineChartData {
  yTitle: string,
  yShowNumber: number[],
  xData: string[],
  interval: number

}

export interface CategoryListData {
  categoryName: string,
  categoryImage: ResourceStr,
  percentValue: number,
  count: number,
  amount: number,
  imageBackColor: ResourceColor
}


export interface PieData {
  value: number,
  name: string
}

export interface CategorySumData {
  amount: number,
  category: string,
  rows: number
}

export interface SumData {
  amount: number,
  timeBase: string
}

export interface MonthAmountData {
  outcome: number,
  income: number
}


export class ColumnData {
  uid: string;
  txt: string;
  selectedFontColor: ResourceColor = Color.White;
  selectedBackColor: ResourceColor = Color.Black
  unSelectedFontColor: ResourceColor = Color.Black
  unSelectedBackColor: ResourceColor = $r("app.color.back_color")
  selectedDisabledBackColor: ResourceColor = Color.Gray
  selected: boolean = false;

  constructor(uid: string, txt: string, selected: boolean) {
    this.uid = uid;
    this.txt = txt;
    this.selected = selected
  }

  getFontColor(): ResourceColor {
    if (this.selected) {
      return this.selectedFontColor;
    } else {
      return this.unSelectedFontColor;
    }
  }


  getBackColor(isLoading:boolean): ResourceColor {
    if (this.selected) {
      if(!isLoading)
      {
        return this.selectedBackColor;
      }
      else
      {
        return this.selectedDisabledBackColor
      }

    } else {
      return this.unSelectedBackColor;
    }
  }
}