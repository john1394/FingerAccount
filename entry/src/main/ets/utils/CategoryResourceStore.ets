import { distributedKVStore } from '@kit.ArkData';
import { sleepTest } from './Util';

/*
 暂时不用kv
 */
export class CategoryResourceStore {
  private static instance: CategoryResourceStore;
  kvStore: distributedKVStore.SingleKVStore | null = null

  public static getInstance(): CategoryResourceStore {
    if (!CategoryResourceStore.instance) {
      CategoryResourceStore.instance = new CategoryResourceStore();
    }

    return CategoryResourceStore.instance;
  }

  public async createKVStore(context: Context) {
    try {

      const bundleName = context.applicationInfo.name;
      const kvManagerConfig: distributedKVStore.KVManagerConfig = {
        context: context,
        bundleName: bundleName
      };
      // 创建KVManager实例
      let kvManager = distributedKVStore.createKVManager(kvManagerConfig);
      try {
        const options: distributedKVStore.Options = {
          createIfMissing: true, // 当数据库文件不存在时是否创建数据库，默认创建
          encrypt: true, // 设置数据库文件是否加密，默认不加密
          backup: false, // 设置数据库文件是否备份，默认备份
          kvStoreType: distributedKVStore.KVStoreType.SINGLE_VERSION, // 设置要创建的数据库类型，默认为多设备协同数据库
          securityLevel: distributedKVStore.SecurityLevel.S2 // 设置数据库安全级别
        };
        // storeId为数据库唯一标识符
        kvManager.getKVStore('kvStoreId', options, async (err, store: distributedKVStore.SingleKVStore) => {
          if (err) {
            console.error(`获取KVStore对象失败。错误码：${err.code}，错误信息：${err.message}`)
            return;
          }

          this.kvStore = store

          console.log("mylog", "begin call initCategory")
          await this.initCategory()

          console.log("mylog", "end call initCategory")

        })
      } catch (err) {
        console.error(`获取KVStore对象过程抛出异常. 错误码：${err.code}，错误信息：${err.message}`)
      }

    } catch (err) {
      console.error(`获取KVManager对象失败. 错误码：${err.code}，错误信息：${err.message}`)
    }
  }

  private async initCategory() {
    console.log("mylog", "begin call sleepTest")
    await sleepTest()

    console.log("mylog", "end call sleepTest")
    let putResult = this.kvStore?.put("cat_canyin", "val1")

    await putResult

    if (this.kvStore) {

      let getResult = this.kvStore.get("cat_canyin")
      let va1 = await getResult
      //  let value1 = getResult
      // this.kvStore.get("aa", (err, value) => {
      //   if (err !== undefined) {
      //
      //     return;
      //   }
      //
      //   console.log("" + value)
      //
      // });

      let entriesPromise = await this.kvStore.getEntries("cat_")

      for (let i = 0; i < entriesPromise.length; i++) {
        console.info('key:' + entriesPromise[i].key + 'value : ' + JSON.stringify(entriesPromise[i].value))
      }


      // this.kvStore.getEntries("cat_").then(
      //   (value) => {
      //     for (let i = 0; i < value.length; i++) {
      //       console.info('key:' + value[i].key + 'value : ' + JSON.stringify(value[i].value))
      //     }
      //   }
      // )
      //   .catch((err: BusinessError) => {
      //     console.info(`getEntries error is: ${err.code}, msg is: ${err.message}`);
      //   })


      // let entries: distributedKVStore.Entry[] = []
      //
      // let entry: distributedKVStore.Entry = {
      //   key: "aa", value: {
      //     type: distributedKVStore.ValueType.STRING,
      //     value: "bb"
      //   }
      // } as distributedKVStore.Entry
      //
      // entries.push(entry)
      //
      // this.kvStore?.putBatch(entries)
      //}
    }
  }
}