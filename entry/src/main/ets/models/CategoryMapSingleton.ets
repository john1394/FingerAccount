import { DatabaseHelper } from '../utils/DatabaseHelper';
import { CategoryItem } from './CategoryList';
import { BillTypeEnum } from './RecordList';

export default class CategoryMapSingleton {
  // 私有静态实例
  private static instance: CategoryMapSingleton = new CategoryMapSingleton();
  // Map 存储键值对
  private outComeMap: Map<string, CategoryItem>;
  private inComeMap: Map<string, CategoryItem>;

  // 私有构造函数，确保无法直接实例化
  private constructor() {
    this.outComeMap = new Map<string, CategoryItem>();
    this.inComeMap = new Map<string, CategoryItem>();
    //this.initializeMap();
    console.log("mylog", "initializeMap成功")
  }

  // 静态方法获取单例实例
  public static getInstance(): CategoryMapSingleton {

    return CategoryMapSingleton.instance;
  }

  // 获取 Map 的值
  public get(key: string, bill_type: BillTypeEnum): CategoryItem | undefined {
    if (bill_type == BillTypeEnum.Outcome) {
      return this.outComeMap.get(key);
    } else if (bill_type == BillTypeEnum.Income) {
      return this.inComeMap.get(key);
    } else {
      return undefined;
    }
  }

  // 设置 Map 的值
  public set(key: string, value: CategoryItem, bill_type: BillTypeEnum): void {

    if (bill_type == BillTypeEnum.Outcome) {
      this.outComeMap.set(key, value);
    } else if (bill_type == BillTypeEnum.Income) {
      this.inComeMap.set(key, value);
    }
  }

  // 获取 Map 的所有键值对
  public getOutComeMap(): Map<string, CategoryItem> {
    return new Map(this.outComeMap); // 返回一个副本，避免直接修改
  }

  public getInComeMap(): Map<string, CategoryItem> {
    return new Map(this.inComeMap); // 返回一个副本，避免直接修改
  }

  // 初始化 Map
  public  initializeMap(): void {

    this.outComeMap.clear()
    this.inComeMap.clear()
    let allData = DatabaseHelper.getInstance().getCategoryData()

    allData.forEach(item => {

      if (item.bill_type == BillTypeEnum.Outcome) {
        this.outComeMap.set(item.category_name, item)
      } else if (item.bill_type == BillTypeEnum.Income) {
        this.inComeMap.set(item.category_name, item)
      }

    }
    );

  }
}
