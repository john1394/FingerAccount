import {
  BarChart,
  BarChartModel,
  BarData,
  BarDataSet,
  BarEntry,
  Description,
  Fill,
  IBarDataSet,
  JArrayList,
  Legend,
  LimitLabelPosition,
  LimitLine,
  MarkerView,
  XAxis,
  XAxisPosition,
  YAxis
} from '@ohos/mpchart';

@Component
export struct MPTimeBarChart {
  @Prop model: BarChartModel;
  @Prop data: BarData;
  @Prop limitLine1: LimitLine
  @Prop limitLine2: LimitLine
  @Prop leftAxis: YAxis | null
  @Prop rightAxis: YAxis | null
  @Prop xAxis: XAxis | null
  @Prop normalMarker: MarkerView

  //@Prop    stackMarker :CustomMarkerView
  build() {
    BarChart({ model: this.model })
      .width('100%')
      .height('30%')
  }

  // 图表数据初始化
  aboutToAppear() {

    // Step1:必须：初始化图表配置构建类
    this.model = new BarChartModel();

    // Step2:配置图表指定样式，各部件间没有先后之分

    // 为图表添加数据选择的监听器
    //this.model.setOnChartValueSelectedListener(this.valueSelectedListener);
    // 为图表添加手势识别监听器
    // this.model.setOnChartGestureListener(this.chartGestureListener);
    // 获取图表描述部件，设置图表描述部件不可用，即图表不进行绘制描述部件
    let description: Description | null = this.model.getDescription()
    if (description) {
      description.setEnabled(false);
    }
    // 获取图表图例部件，设置图表图例部件不可用
    let l: Legend | null = this.model.getLegend();
    if (l) {
      l.setEnabled(false);
    }
    // 设置图表数据最大的绘制数，如果超过该数值，则不进行绘制图表的数值标签
    this.model.setMaxVisibleValueCount(40);
    // 是否绘制图表的背景色，绘制范围为图表柱状图的绘制范围，不包含轴线之外的部分
    this.model.setDrawGridBackground(false);
    // 设置图表的背景色，颜色的规格需要满足CanvasRenderingContext2D.fillstyle/strokestyle规格
    this.model.setGridBackgroundColor('#500000ff')
    // 设置不绘制柱状图的柱体阴影背景
    this.model.setDrawBarShadow(false);
    // 设置柱状图的数值在柱体上方
    this.model.setDrawValueAboveBar(false);
    // 设置柱状图的高亮范围是否为整个柱体，只在堆叠柱状图中有区别
    this.model.setHighlightFullBarEnabled(false);
    // 为左Y轴设置LimitLine,可设置限制线的宽度，线段样式，限制标签的位置，标签字体大小等
    this.limitLine1 = new LimitLine(120, 'Upper Limit');
    this.limitLine1.setLineWidth(4);
    this.limitLine1.enableDashedLine(10, 10, 0);
    this.limitLine1.setLabelPosition(LimitLabelPosition.RIGHT_TOP);
    this.limitLine1.setTextSize(10);

    this.limitLine2 = new LimitLine(50, 'Lower Limit');
    this.limitLine2.setLineWidth(4);
    this.limitLine2.enableDashedLine(10, 10, 0);
    this.limitLine2.setLineColor(Color.Yellow);
    this.limitLine2.setLabelPosition(LimitLabelPosition.RIGHT_BOTTOM);
    this.limitLine2.setTextSize(10);

    // 设置图表左Y轴信息
    this.leftAxis = this.model.getAxisLeft();
    if (this.leftAxis) {
      this.leftAxis.setAxisMinimum(0); // this replaces setStartAtZero(true)
      this.leftAxis.setDrawLimitLinesBehindData(false);

      // 添加LimitLines
      //  this.leftAxis.addLimitLine(this.limitLine1);
      // this.leftAxis.addLimitLine(this.limitLine2);
    }
    // 设置图表右Y轴信息
    this.rightAxis = this.model.getAxisRight();
    if (this.rightAxis) {
      this.rightAxis.setEnabled(false);
      this.rightAxis.setAxisMinimum(0);
    }
    // 设置X轴信息
    this.xAxis = this.model.getXAxis();
    if (this.xAxis) {
      this.xAxis.setPosition(XAxisPosition.BOTTOM);
    }
    // 为图表设置markerView
    this.normalMarker = new MarkerView();
    this.model.setMarker(this.normalMarker);
    // 也可设置定义图表MarkerView
    //this.stackMarker = new CustomMarkerView();
    // 生成单一颜色数据
    this.data = this.getNormalData();
    // 将数据与图表配置类绑定
    this.model.setData(this.data);
    // 设置图表最大的X轴显示范围，如不设置，则默认显示全部数据
    this.model.setVisibleXRangeMaximum(20);
  }

  private getNormalData(): BarData {
    let values: JArrayList<BarEntry> = new JArrayList<BarEntry>();
    values.add(new BarEntry(1, 2));
    values.add(new BarEntry(2, 3));
    values.add(new BarEntry(3, 10));
    values.add(new BarEntry(4, 20));
    values.add(new BarEntry(6, 200));

    let dataSet: BarDataSet = new BarDataSet(values, 'DataSet');
    dataSet.setHighLightColor(Color.Black);
    dataSet.setDrawIcons(false);
    // 为柱体添加颜色信息
    //dataSet.setColorByColor(Color.Blue);

    let dataSetList: JArrayList<IBarDataSet> = new JArrayList<IBarDataSet>();
    dataSetList.add(dataSet);

    let barData: BarData = new BarData(dataSetList);
    //设置柱状图宽度
    barData.setBarWidth(0.85);
    //设置顶部圆角半径
    barData.setTopRadius(5);
    return barData;
  }

  private getGradientData(): BarData {
    let values: JArrayList<BarEntry> = new JArrayList<BarEntry>();
    values.add(new BarEntry(1, 32.9));
    values.add(new BarEntry(2, 44.7));

    let dataSet: BarDataSet = new BarDataSet(values, 'DataSet');
    dataSet.setHighLightColor(Color.Black);
    dataSet.setDrawIcons(false);
    let startColor1: string = '#ffffbb33';
    let startColor2: string = '#ff33b5e5';
    let startColor3: string = '#ffffbb33';
    let startColor4: string = '#ff99cc00';
    let startColor5: string = '#ffff4444';
    let endColor1: string = '#ff0099cc';
    let endColor2: string = '#ffaa66cc';
    let endColor3: string = '#ff669900';
    let endColor4: string = '#ffcc0000';
    let endColor5: string = '#ffff8800';
    let gradientFills: JArrayList<Fill> = new JArrayList<Fill>();
    gradientFills.add(new Fill(startColor1, endColor1));
    gradientFills.add(new Fill(startColor2, endColor2));
    gradientFills.add(new Fill(startColor3, endColor3));
    gradientFills.add(new Fill(startColor4, endColor4));
    gradientFills.add(new Fill(startColor5, endColor5));
    // 为柱体添加渐变的颜色信息
    dataSet.setFills(gradientFills);

    let dataSetList: JArrayList<IBarDataSet> = new JArrayList<IBarDataSet>();
    dataSetList.add(dataSet);

    let barData: BarData = new BarData(dataSetList);
    barData.setBarWidth(0.85);
    return barData;
  }

  private getStackData(): BarData {
    let values: JArrayList<BarEntry> = new JArrayList<BarEntry>();
    values.add(new BarEntry(1, [38.0, 28.0, 39.8]));
    values.add(new BarEntry(2, [18.2, 16.1, 16.1]));

    let set1: BarDataSet | null = null;
    set1 = new BarDataSet(values, "Statistics Vienna 2014");
    set1.setDrawIcons(false);
    // 为柱体添加指定分段的颜色信息
    set1.setColorsByArr([Color.Red, Color.Green, Color.Pink]);
    set1.setStackLabels(["Births", "Divorces", "Marriages"]);

    let dataSets: JArrayList<IBarDataSet> = new JArrayList<IBarDataSet>();
    dataSets.add(set1);

    let data: BarData = new BarData(dataSets);
    data.setValueTextColor(Color.White);
    return data;
  }
}