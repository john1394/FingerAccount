import { relationalStore, ValueType, } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import { SumData } from '../models/BillReportModel';
import { CategoryItem } from '../models/CategoryList';
import { BillTypeEnum, RecordItemInfo } from '../models/RecordList';


const db_file_name = "bill.db"
const db_file_dir = "customDir/subCustomDir"


const init_category_table_sql = `
CREATE TABLE IF NOT EXISTS category (
id INTEGER PRIMARY KEY AUTOINCREMENT,
category_name TEXT,
image_url TEXT,
bill_type INTEGER,
timestamp INTEGER
);
`;

//用;分隔，语句中不能有;号
const init_category_data_sql = `
insert into category(category_name,image_url,bill_type,timestamp) values('其它','ic_cat_out_qita','0' ,CAST(strftime('%s', 'now') AS INTEGER) * 1000);
insert into category(category_name,image_url,bill_type,timestamp) values('餐饮','ic_cat_out_canyin','0' ,CAST(strftime('%s', 'now') AS INTEGER) * 1000);
insert into category(category_name,image_url,bill_type,timestamp) values('购物','ic_cat_out_gouwu','0' ,CAST(strftime('%s', 'now') AS INTEGER) * 1000);
insert into category(category_name,image_url,bill_type,timestamp) values('服饰','ic_cat_out_fushi','0' ,CAST(strftime('%s', 'now') AS INTEGER) * 1000);
insert into category(category_name,image_url,bill_type,timestamp) values('日用','ic_cat_out_riyong','0' ,CAST(strftime('%s', 'now') AS INTEGER) * 1000);
insert into category(category_name,image_url,bill_type,timestamp) values('数码','ic_cat_out_shuma','0' ,CAST(strftime('%s', 'now') AS INTEGER) * 1000);
insert into category(category_name,image_url,bill_type,timestamp) values('美妆','ic_cat_out_meizhuang','0' ,CAST(strftime('%s', 'now') AS INTEGER) * 1000);
insert into category(category_name,image_url,bill_type,timestamp) values('护肤','ic_cat_out_hufu','0' ,CAST(strftime('%s', 'now') AS INTEGER) * 1000);
insert into category(category_name,image_url,bill_type,timestamp) values('软件','ic_cat_out_ruanjian','0' ,CAST(strftime('%s', 'now') AS INTEGER) * 1000);
insert into category(category_name,image_url,bill_type,timestamp) values('住房','ic_cat_out_zufang','0' ,CAST(strftime('%s', 'now') AS INTEGER) * 1000);
insert into category(category_name,image_url,bill_type,timestamp) values('交通','ic_cat_out_jiaotong','0' ,CAST(strftime('%s', 'now') AS INTEGER) * 1000);
insert into category(category_name,image_url,bill_type,timestamp) values('娱乐','ic_cat_out_yule','0' ,CAST(strftime('%s', 'now') AS INTEGER) * 1000);
insert into category(category_name,image_url,bill_type,timestamp) values('医疗','ic_cat_out_yiliao','0' ,CAST(strftime('%s', 'now') AS INTEGER) * 1000);
insert into category(category_name,image_url,bill_type,timestamp) values('通讯','ic_cat_out_tongxun','0' ,CAST(strftime('%s', 'now') AS INTEGER) * 1000);
insert into category(category_name,image_url,bill_type,timestamp) values('汽车','ic_cat_out_qiche','0' ,CAST(strftime('%s', 'now') AS INTEGER) * 1000);
insert into category(category_name,image_url,bill_type,timestamp) values('学习','ic_cat_out_xuexi','0' ,CAST(strftime('%s', 'now') AS INTEGER) * 1000);
insert into category(category_name,image_url,bill_type,timestamp) values('办公','ic_cat_out_bangong','0' ,CAST(strftime('%s', 'now') AS INTEGER) * 1000);
insert into category(category_name,image_url,bill_type,timestamp) values('运动','ic_cat_out_yundong','0' ,CAST(strftime('%s', 'now') AS INTEGER) * 1000);
insert into category(category_name,image_url,bill_type,timestamp) values('社交','ic_cat_out_sejiao','0' ,CAST(strftime('%s', 'now') AS INTEGER) * 1000);
insert into category(category_name,image_url,bill_type,timestamp) values('人情','ic_cat_out_renqin','0' ,CAST(strftime('%s', 'now') AS INTEGER) * 1000);
insert into category(category_name,image_url,bill_type,timestamp) values('育儿','ic_cat_out_yuer','0' ,CAST(strftime('%s', 'now') AS INTEGER) * 1000);
insert into category(category_name,image_url,bill_type,timestamp) values('宠物','ic_cat_out_congwu','0' ,CAST(strftime('%s', 'now') AS INTEGER) * 1000);
insert into category(category_name,image_url,bill_type,timestamp) values('旅行','ic_cat_out_luxing','0' ,CAST(strftime('%s', 'now') AS INTEGER) * 1000);
insert into category(category_name,image_url,bill_type,timestamp) values('度假','ic_cat_out_dujia','0' ,CAST(strftime('%s', 'now') AS INTEGER) * 1000);
insert into category(category_name,image_url,bill_type,timestamp) values('烟酒','ic_cat_out_yanjiu','0' ,CAST(strftime('%s', 'now') AS INTEGER) * 1000);
insert into category(category_name,image_url,bill_type,timestamp) values('设置','ic_cat_out_setting','0' ,CAST(strftime('%s', 'now') AS INTEGER) * 1000);



insert into category(category_name,image_url,bill_type,timestamp) values('其它','ic_cat_in_qita','1' ,CAST(strftime('%s', 'now') AS INTEGER) * 1000);
insert into category(category_name,image_url,bill_type,timestamp) values('工资','ic_cat_in_gongzhi','1' ,CAST(strftime('%s', 'now') AS INTEGER) * 1000);
insert into category(category_name,image_url,bill_type,timestamp) values('奖金','ic_cat_in_jiangjin','1' ,CAST(strftime('%s', 'now') AS INTEGER) * 1000);
insert into category(category_name,image_url,bill_type,timestamp) values('加班','ic_cat_in_jiaban','1' ,CAST(strftime('%s', 'now') AS INTEGER) * 1000);
insert into category(category_name,image_url,bill_type,timestamp) values('福利','ic_cat_in_fuli','1' ,CAST(strftime('%s', 'now') AS INTEGER) * 1000);
insert into category(category_name,image_url,bill_type,timestamp) values('公积金','ic_cat_in_gjj','1' ,CAST(strftime('%s', 'now') AS INTEGER) * 1000);
insert into category(category_name,image_url,bill_type,timestamp) values('红包','ic_cat_in_hongbao','1' ,CAST(strftime('%s', 'now') AS INTEGER) * 1000);
insert into category(category_name,image_url,bill_type,timestamp) values('兼职','ic_cat_in_jianzhi','1' ,CAST(strftime('%s', 'now') AS INTEGER) * 1000);
insert into category(category_name,image_url,bill_type,timestamp) values('副业','ic_cat_in_fuye','1' ,CAST(strftime('%s', 'now') AS INTEGER) * 1000);
insert into category(category_name,image_url,bill_type,timestamp) values('退税','ic_cat_in_tuisui','1' ,CAST(strftime('%s', 'now') AS INTEGER) * 1000);
insert into category(category_name,image_url,bill_type,timestamp) values('投资','ic_cat_in_touzhi','1' ,CAST(strftime('%s', 'now') AS INTEGER) * 1000);
insert into category(category_name,image_url,bill_type,timestamp) values('意外所得','ic_cat_in_yiwai','1' ,CAST(strftime('%s', 'now') AS INTEGER) * 1000);
insert into category(category_name,image_url,bill_type,timestamp) values('设置','ic_cat_in_setting','1' ,CAST(strftime('%s', 'now') AS INTEGER) * 1000);


`;

// const init_income_category_sql = `
// insert into category(category_name,image_url,bill_type,timestamp) values('其它','ic_cat_in_qita','1' ,CAST(strftime('%s', 'now') AS INTEGER) * 1000);
// insert into category(category_name,image_url,bill_type,timestamp) values('工资','ic_cat_in_gongzhi','1' ,CAST(strftime('%s', 'now') AS INTEGER) * 1000);
// `;


const SQL_CREATE_TABLE =
  'CREATE TABLE IF NOT EXISTS bills (\n' +
    '    id INTEGER PRIMARY KEY AUTOINCREMENT,\n' +
    '    amount INTEGER,\n' +
    '    category TEXT,\n' +
    '    bill_type INTEGER,\n' +
    '    timestamp INTEGER,\n' +
    '    notes TEXT,\n' +
    '    extra_fields TEXT\n' +
    '  )';

const SQL2 = "CREATE TABLE IF NOT EXISTS aggregations (\n" +
  "      type TEXT,\n" +
  "      date_key TEXT,\n" +
  "      total_amount INTEGER,\n" +
  "      category TEXT,\n" +
  "      PRIMARY KEY (type, date_key)\n" +
  "      )"

const SQL_index1 = "CREATE INDEX idx_bills_timestamp ON bills(timestamp); " +
  "CREATE INDEX idx_bills_category ON bills(category);  " +
  "CREATE INDEX idx_aggregations_date ON aggregations(date_key);"


export class DatabaseHelper {
  private static instance: DatabaseHelper;
  private rdbStore: relationalStore.RdbStore | null = null;
  private initPromise: Promise<void> | null = null; // 用于确保初始化只执行一次

  // 确保单例模式线程安全
  public static getInstance(): DatabaseHelper {
    if (!DatabaseHelper.instance) {
      DatabaseHelper.instance = new DatabaseHelper();
    }
    return DatabaseHelper.instance;
  }


  testGetTableData(tableName: string) {
    try {
      const predicates = new relationalStore.RdbPredicates(tableName);
      const resultSet = this.rdbStore?.querySync(predicates);

      let jsonData: Array<Map<string, string>> = [];
      while (resultSet?.goToNextRow()) {
        let row = new Map<string, string>();

        for (let i = 0; i < resultSet.columnNames.length; i++) {
          const columnName = resultSet.columnNames[i];
          const value = resultSet.getString(resultSet.getColumnIndex(columnName));
          row[columnName] = value; // 使用方括号语法动态设置属性
        }

        jsonData.push(row);
      }

      resultSet?.close();

      const deepJson = JSON.stringify(jsonData);

      return jsonData;
    } catch (error) {
      console.error('查询表数据时出错:', error);
      return null;
    }
  }

  promiseTest1(): Promise<string> {
    return new Promise((resolve, reject) => {
      // 模拟异步操作（如网络请求、文件读写）
      setTimeout(() => {
        const success = false; // 假设操作成功
        if (success) {
          resolve("Data fetched successfully!");
        } else {
          throw new Error("my error")
          reject("Error: Failed to fetch data.");
        }
      }, 5000);
    });
  }

  promiseTest2(): Promise<void> {
    let result: Promise<void> = new Promise(async (resolve) => {

      console.log("mystep 2")
      setTimeout(() => {
        const success = true; // 假设操作成功
        if (success) {
          console.log(" mystep 4");
          resolve()
        } else {
          //throw new Error("my error")

        }
      }, 5000);

    })

    return result

  }

  async doAsyncTask(): Promise<void> {
    return new Promise((resolve) => {
      setTimeout(() => {
        console.log("Async task completed");
        resolve(); // 无返回值，仅表示完成
      }, 5000);
    });
  }

  async test3() {
    for (let index = 0; index < 100; index++) {
      console.log("mystep 2 index:" + index)
    }
  }

  test2() {

    console.log("mystep 1")
    let result = this.test3()

    console.log("mystep 3")

    result.then(
      () => {
        console.log("mystep 5")
      }
    )

    // this.promiseTest1()
    //   .then((result) => {
    //     console.log(result); // 成功时输出结果
    //   })
    //   .catch((error: Error) => {
    //     console.error(error.message); // 失败时处理错误
    //   });
  }


  insertTest() {
    this.rdbStore?.executeSync("insert into bills(amount) values('1')");
  }

  insertBill(params: ValueType[]) {
    try {

      let sql: string = "insert into bills(amount,category,bill_type,timestamp,notes,extra_fields) values(?,?,?,?,?,?)"
      // 执行插入操作
      const insertId = this.rdbStore?.executeSync(sql, params)
      console.log(`Inserted row ID: ${insertId}`);
      return insertId;
    } catch (err) {
      const error = err as BusinessError;
      console.error(`Insert failed, code: ${error.code}, message: ${error.message}`);
      return -1;
    }
  }

  updateBill(params: ValueType[]) {
    try {

      const sql = `UPDATE bills
  SET amount = ?,
      category = ?,
      bill_type = ?,
      timestamp = ?,
      notes = ?,
      extra_fields = ?
  WHERE id = ?`;

      // 执行插入操作
      const updateId = this.rdbStore?.executeSync(sql, params)
      console.log(`affected row ID: ${updateId}`);
      return updateId;
    } catch (err) {
      const error = err as BusinessError;
      console.error(`Insert failed, code: ${error.code}, message: ${error.message}`);
      return -1;
    }
  }


  deleteBill(id: number) {
    try {

      let sql: string = "delete from bills where id = ?"

      let params: ValueType[] = []

      params.push(id);
      const affected = this.rdbStore?.executeSync(sql, params)
      console.log(`delete row ID: ${affected}`);
      return affected;
    } catch (err) {
      const error = err as BusinessError;
      console.error(`delete failed, code: ${error.code}, message: ${error.message}`);
      return -1;
    }
  }


  getCategoryByType(billType:BillTypeEnum): CategoryItem[] {
    let result: CategoryItem[] = [];
    try {
      const sql = 'SELECT * FROM category where bill_type=? order by id';
      let params:ValueType[]=[];
      params.push(billType.valueOf());

      const resultSet = this.rdbStore?.querySqlSync(sql,params); // 或使用 executeSql（需处理结果集）
      while (resultSet?.goToNextRow()) {

        // 获取列值
        const id = resultSet.getLong(resultSet.getColumnIndex('id'));
        const category_name = resultSet.getString(resultSet.getColumnIndex('category_name'));
        const image_url = "app.media."+resultSet.getString(resultSet.getColumnIndex('image_url'));
        const bill_type = resultSet.getLong(resultSet.getColumnIndex('bill_type'));
        const timestamp = resultSet.getLong(resultSet.getColumnIndex('timestamp'));

        console.log(`ID: ${id}, category_name: ${category_name}, image_url: ${image_url}, bill_type:${bill_type}}, Timestamp: ${timestamp}`);

        let item: CategoryItem =
          {
            category_image: image_url,
            category_name: category_name,
          }

        result.push(item);
      }

      resultSet?.close();

    } catch (error) {
      console.error(`Failed to execute SQL: ${error.message}`);

    }
    return result
  }

    getDaySum(begin:number,end:number,bill_type:BillTypeEnum):SumData[]
  {

    let result: SumData[] = [];
    try {
      const sql =`SELECT SUM(amount) as total,  strftime('%Y-%m-%d', timestamp/1000, 'unixepoch','localtime') AS date
                 FROM bills
                 where bill_type=? and timestamp>=? and timestamp <=?
                 group by date order  by date asc`
      let params:ValueType[]=[bill_type, begin,end];


      const resultSet = this.rdbStore?.querySqlSync(sql,params); // 或使用 executeSql（需处理结果集）
      while (resultSet?.goToNextRow()) {

        // 获取列值
        const total = resultSet.getLong(resultSet.getColumnIndex('total'));
        const date = resultSet.getString(resultSet.getColumnIndex('date'));


        console.log(`total: ${total}, date: ${date}`);

        let item: SumData =
          {
            amount: total,
            timeBase: date,
          }

        result.push(item);
      }

      resultSet?.close();

    } catch (error) {
      console.error(`Failed to execute SQL: ${error.message}`);

    }

    return result
  }

  getMonthSum(begin:number,end:number,bill_type:BillTypeEnum):SumData[]
  {

    let result: SumData[] = [];
    try {
      const sql =`SELECT SUM(amount) as total,  strftime('%Y-%m', timestamp/1000, 'unixepoch','localtime') AS date
                 FROM bills
                 where bill_type=? and timestamp>=? and timestamp <=?
                 group by date order  by date asc`
      let params:ValueType[]=[bill_type, begin,end];


      const resultSet = this.rdbStore?.querySqlSync(sql,params); // 或使用 executeSql（需处理结果集）
      while (resultSet?.goToNextRow()) {

        // 获取列值
        const total = resultSet.getLong(resultSet.getColumnIndex('total'));
        const date = resultSet.getString(resultSet.getColumnIndex('date'));


        console.log(`total: ${total}, date: ${date}`);

        let item: SumData =
          {
            amount: total,
            timeBase: date,
          }

        result.push(item);
      }

      resultSet?.close();

    } catch (error) {
      console.error(`Failed to execute SQL: ${error.message}`);

    }

    return result
  }

  getAllBillRecord() {
    let result: RecordItemInfo[] = []
    try {
      // 1. 执行 SQL 查询
      const sql = 'SELECT * FROM bills order by timestamp desc';
      const resultSet = this.rdbStore?.querySqlSync(sql); // 或使用 executeSql（需处理结果集）

      while (resultSet?.goToNextRow()) {
        // 获取列索引
        const idIndex = resultSet.getColumnIndex('id');
        const amountIndex = resultSet.getColumnIndex('amount');
        const categoryIndex = resultSet.getColumnIndex('category');
        const bill_type_Index = resultSet.getColumnIndex('bill_type');
        const timestampIndex = resultSet.getColumnIndex('timestamp');
        const notesIndex = resultSet.getColumnIndex('notes');
        const extraFieldsIndex = resultSet.getColumnIndex('extra_fields');

        // 获取列值
        const idValue = resultSet.getLong(idIndex);
        const amount = resultSet.getLong(amountIndex);
        const category = resultSet.getString(categoryIndex);
        const bill_type = resultSet.getLong(bill_type_Index);
        const timestamp = resultSet.getLong(timestampIndex);
        const notes = resultSet.getString(notesIndex);
        const extraFields = resultSet.getString(extraFieldsIndex);

        console.log(`ID: ${idValue}, Amount: ${amount}, Category: ${category}, bill_type:${bill_type}}, Timestamp: ${timestamp}, Notes: ${notes}, Extra Fields: ${extraFields}`);

        let item: RecordItemInfo =
          {
            id: idValue,
            category_image: '',
            category_name: category,
            bill_type: bill_type,
            amount: amount,
            timestamp: timestamp,
            notes: notes
          }

        result.push(item);
      }

      resultSet?.close();


    } catch (error) {
      console.error(`Failed to execute SQL: ${error.message}`);

    }

    return result;
  }

  selectTest() {
    try {
      // 1. 执行 SQL 查询
      const sql = 'SELECT * FROM bills';
      const resultSet = this.rdbStore?.querySqlSync(sql); // 或使用 executeSql（需处理结果集）

      // 2. 读取结果
      let count = 0;
      if (resultSet?.goToFirstRow()) {
        count = resultSet.getLong(resultSet.getColumnIndex('total'));
      }

      // 3. 关闭结果集
      resultSet?.close();


    } catch (error) {
      console.error(`Failed to execute SQL: ${error.message}`);

    }
  }

  // 初始化方法必须完整覆盖赋值逻辑

  private async getRdbStorePromise(context: Context,
    config: relationalStore.StoreConfig): Promise<relationalStore.RdbStore> {
    return new Promise((resolve, reject) => {
      relationalStore.getRdbStore(context, config, (err, store) => {
        if (err) {
          reject(err);
        } else {
          resolve(store);
        }
      });
    });
  }

  async initDatabase(context: Context): Promise<void> {
    if (this.rdbStore) {
      return; // 已初始化，直接返回
    }

    if (!this.initPromise) {

      this.initPromise = (async () => {
        const STORE_CONFIG: relationalStore.StoreConfig = {
          name: db_file_name,
          securityLevel: relationalStore.SecurityLevel.S1,
          encrypt: false,
          customDir: db_file_dir,
          isReadOnly: false,
        };

        try {
          const store = await this.getRdbStorePromise(context, STORE_CONFIG);

          // 处理数据库版本和表结构
          if (store.version === 0) {
            // 初始版本，创建表结构

            let lines = init_category_data_sql.split(";");

            lines = lines.filter(line => line.trim() != ""
            )
            store.executeSync(SQL_CREATE_TABLE);
            store.executeSync(SQL2);
            store.executeSync(SQL_index1);
            //初始化数据
            store.executeSync(init_category_table_sql);


            lines.forEach((line) => {

              console.log(line);
              store.executeSync(line);
            })


            store.version = 1;
          }

          // 示例版本升级逻辑，根据需求调整
          if (store.version === 1) {
            // 升级到版本2
            // store.executeSql('ALTER TABLE EMPLOYEE ADD COLUMN AGE INTEGER');
            // store.version = 2;
          }

          // 设置当前数据库实例
          this.rdbStore = store;
        } catch (error) {
          console.error('初始化数据库失败:', error);
          // throw  new Error(error)

        }
      })
      ()
      ;
    }

    await this.initPromise;
  }
}