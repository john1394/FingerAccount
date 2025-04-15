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


  getBackColor(): ResourceColor {
    if (this.selected) {
      return this.selectedBackColor;
    } else {
      return this.unSelectedBackColor;
    }
  }
}