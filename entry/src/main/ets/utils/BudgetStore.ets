import { preferences } from '@kit.ArkData'
import { emitter } from '@kit.BasicServicesKit'

export class BudgetStore {
  static context: Context
  static budget_key: string = "budget_key"
  static month_key: string = "month_key"

  static init(context: Context) {
    BudgetStore.context = context
  }

  // 创建/获取仓库
  static getStore() {
    // 获取仓库, 获取不到就会创建
    return preferences.getPreferencesSync(BudgetStore.context, {
      // 仓库的名称
      name: BudgetStore.budget_key
    })
  }

  static async addMonthBudget(value: number) {
    // 获取到创建的仓库
    const store = BudgetStore.getStore()
    // 给仓库添加数据
    store.putSync(BudgetStore.month_key, value + "")
    // 写入到磁盘
    await store.flush()

    // 发布消息
    emitter.emit(BudgetStore.budget_key)
  }

  static getMonthBudget(): number {
    // 获取指定的仓库仓库
    const store = BudgetStore.getStore();
    // 获取仓库中的所有数据
    const month_value = store.getSync(BudgetStore.month_key, "")

    let tempNumber = Number(month_value)

    return isNaN(tempNumber) ? 0 : tempNumber
  }
}