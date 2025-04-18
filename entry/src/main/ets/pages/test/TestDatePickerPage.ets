class bottom {
  bottom: number = 50
}

let bott: bottom = new bottom()

@Entry
@Component
struct TestDatePickerPage {
  private selectedYear: number = new Date().getFullYear()
  private selectedMonth: number = new Date().getMonth() + 1
  private select: number = 1
  private fruits: string[] = ['apple1', 'orange2', 'peach3', 'grape4']
  private apfruits: string[] = ['apple1', 'apple2', 'apple3', 'apple4']
  private orfruits: string[] = ['orange1', 'orange2', 'orange3', 'orange4']
  private pefruits: string[] = ['peach1', 'peach2', 'peach3', 'peach4']
  private multi: string[][] = [this.apfruits, this.orfruits, this.pefruits]
  private cascade: TextCascadePickerRangeContent[] = [
    {
      text: '辽宁省',
      children: [{ text: '沈阳市', children: [{ text: '沈河区' }, { text: '和平区' }, { text: '浑南区' }] },
        { text: '大连市', children: [{ text: '中山区' }, { text: '金州区' }, { text: '长海县' }] }]
    },
    {
      text: '吉林省',
      children: [{ text: '长春市', children: [{ text: '南关区' }, { text: '宽城区' }, { text: '朝阳区' }] },
        { text: '四平市', children: [{ text: '铁西区' }, { text: '铁东区' }, { text: '梨树县' }] }]
    },
    {
      text: '黑龙江省',
      children: [{ text: '哈尔滨市', children: [{ text: '道里区' }, { text: '道外区' }, { text: '南岗区' }] },
        { text: '牡丹江市', children: [{ text: '东安区' }, { text: '西安区' }, { text: '爱民区' }] }]
    }
  ]

  build() {
    Column() {

      Scroll() {
        Column() {
          Text("hello")
          DatePicker({
            start: new Date('1970-01-01'),
            end: new Date('2100-12-31'),
            selected: new Date(`${this.selectedYear}-${this.selectedMonth}-01`)
          })

          Row() {
            TextPicker({ range: this.fruits, selected: this.select })
            TextPicker({ range: this.fruits, selected: this.select })
          }.backgroundColor(Color.Pink)


          TextPicker({ range: this.apfruits, selected: this.select })
            .onChange((value: string | string[], index: number | number[]) => {
              console.info('Picker item changed, value: ' + value + ', index: ' + index)
            })
            .onScrollStop((value: string | string[], index: number | number[]) => {
              console.info('Picker scroll stopped, value: ' + value + ', index: ' + index)
            }).margin(bott)

          TextPicker({ range: this.multi })
            .onChange((value: string | string[], index: number | number[]) => {
              console.info('TextPicker 多列:onChange ' + JSON.stringify(value) + ', ' + 'index: ' +
              JSON.stringify(index))
            })
            .onScrollStop((value: string | string[], index: number | number[]) => {
              console.info('TextPicker 多列:onScrollStop ' + JSON.stringify(value) + ', ' + 'index: ' +
              JSON.stringify(index))
            }).margin(bott)

          TextPicker({ range: this.cascade })
            .backgroundColor(Color.Pink)
            .onChange((value: string | string[], index: number | number[]) => {
              console.info('TextPicker 多列联动:onChange ' + JSON.stringify(value) + ', ' + 'index: ' +
              JSON.stringify(index))
            })
            .onScrollStop((value: string | string[], index: number | number[]) => {
              console.info('TextPicker 多列联动:onScrollStop ' + JSON.stringify(value) + ', ' + 'index: ' +
              JSON.stringify(index))
            })

        }

      }.backgroundColor(Color.Gray)

    }
  }
}