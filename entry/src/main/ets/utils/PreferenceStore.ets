import { preferences } from '@kit.ArkData'
import { emitter } from '@kit.BasicServicesKit'
import { PreferenceKeys, PreferenceStores } from './PreferenceKeys'

export class PreferenceStore {
  static context: Context

   static emit_budget: string = "emit_budget"

  //  static month_key: string = "month_key"

  static init(context: Context) {
    PreferenceStore.context = context
  }

  // 创建/获取仓库
  static getStore() {
    // 获取仓库, 获取不到就会创建
    return preferences.getPreferencesSync(PreferenceStore.context, {
      // 仓库的名称
      name: PreferenceStores[PreferenceStores.default_pref_store]
    })
  }

  static async addMonthBudget(value: number) {
    // 获取到创建的仓库
    const store = PreferenceStore.getStore()
    // 给仓库添加数据

    store.putSync(PreferenceKeys[PreferenceKeys.month_key], value + "")
    // 写入到磁盘
    await store.flush()

    // 发布消息
    emitter.emit(PreferenceStore.emit_budget)
  }

  static getMonthBudget(): number {
    // 获取指定的仓库仓库
    const store = PreferenceStore.getStore();
    // 获取仓库中的所有数据
    const month_value = store.getSync(PreferenceKeys[PreferenceKeys.month_key], "")

    let tempNumber = Number(month_value)

    return isNaN(tempNumber) ? 0 : tempNumber
  }
}