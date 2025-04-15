@Preview
@Entry
@Component
struct TestPage {
  build() {

    Column()
    {
      //build

      Button("click")
        .borderRadius('10.00px')


      Text("hi")
    }.width("100%")
    .height("100%")
    .padding(10)
    .opacity(0.69)
    .grayscale(0.23)
    .borderWidth('1.00vp')
  }
}