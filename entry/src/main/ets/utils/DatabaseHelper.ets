import { relationalStore, ValueType, } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import { CategorySumData, SumData } from '../models/BillReportModel';
import { CategoryItem } from '../models/CategoryList';
import { BillDbRecord, BillTypeEnum, RecordItemInfo } from '../models/RecordList';
import { BizConstants } from './BizConstants';


const db_file_name = "bill.db"
const db_file_dir = "dbdir"


const init_bill_book_table_sql = `
CREATE TABLE IF NOT EXISTS bill_book (
id INTEGER PRIMARY KEY AUTOINCREMENT,
name TEXT,
timestamp INTEGER
);
`;

const init_bill_book_data_sql = `
insert into bill_book(id,name,timestamp) values('1','基本帐本',CAST(strftime('%s', 'now') AS INTEGER) * 1000);
`


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



`;

//insert into category(category_name,image_url,bill_type,timestamp) values('设置','ic_cat_out_setting','0' ,CAST(strftime('%s', 'now') AS INTEGER) * 1000);
//insert into category(category_name,image_url,bill_type,timestamp) values('设置','ic_cat_in_setting','1' ,CAST(strftime('%s', 'now') AS INTEGER) * 1000);

const SQL_CREATE_TABLE =
  'CREATE TABLE IF NOT EXISTS bills (' +
    '    id INTEGER PRIMARY KEY AUTOINCREMENT,' +
    '    bill_book_id INTEGER ,' +
    '    amount INTEGER,' +
    '    category TEXT,' +
    '    bill_type INTEGER,' +
    '    timestamp INTEGER,' +
    '    notes TEXT,' +
    '    extra_fields TEXT' +
    '  )';

// const SQL2 = "CREATE TABLE IF NOT EXISTS aggregations (\n" +
//   "      type TEXT,\n" +
//   "      date_key TEXT,\n" +
//   "      total_amount INTEGER,\n" +
//   "      category TEXT,\n" +
//   "      PRIMARY KEY (type, date_key)\n" +
//   "      )"

const SQL_index1 = "CREATE INDEX idx_bills_timestamp ON bills(bill_book_id,timestamp); " +
  "CREATE INDEX idx_bills_category ON bills(bill_book_id,category);  "

//+ "CREATE INDEX idx_aggregations_date ON aggregations(date_key);"

export class DatabaseHelper {
  private static instance: DatabaseHelper = new DatabaseHelper();
  private rdbStore: relationalStore.RdbStore | null = null;

  private constructor() {
  }

  // 确保单例模式线程安全
  public static getInstance(): DatabaseHelper {
    if (!DatabaseHelper.instance) {
      DatabaseHelper.instance = new DatabaseHelper();
    }

    return DatabaseHelper.instance;
  }

  backupDb(toFileFullPath: string): Promise<void> {

    let pro: Promise<void> = new Promise((resolve) => {
      if (this.rdbStore) {

        this.rdbStore.backup(toFileFullPath, () => {
          console.log("mylog", "backup finished")
          resolve()
        })
      } else {
        resolve()
      }
    })

    return pro


  }

  resoreDb(fromFileName: string) {
    if (this.rdbStore) {
      this.rdbStore.restore(fromFileName, () => {
        console.log("mylog", "restore finished")
      })
    }
  }


  insertBill(params: ValueType[]) {
    try {

      let sql: string =
        "insert into bills(bill_book_id, amount,category,bill_type,timestamp,notes,extra_fields) values(?,?,?,?,?,?,?)"
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

  insertOneBill(record: BillDbRecord) {
    try {

      let params: ValueType[] =
        [BizConstants.Default_bill_book_id, record.id, record.amount, record.category, record.bill_type,
          record.timestamp, record.notes,
          record.extra_fields]
      let sql: string =
        "insert into bills(bill_book_id, id,amount,category,bill_type,timestamp,notes,extra_fields) values(?,?, ?,?,?,?,?,?)"
      // 执行插入操作
      const insertId = this.rdbStore?.executeSync(sql, params)
      console.log(`Inserted row ID: ${insertId}`);
      return insertId;
    } catch (err) {
      const error = err as BusinessError;
      console.error("mylog", `Insert failed, code: ${error.code}, message: ${error.message}`);
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


  getCategoryData(): CategoryItem[] {
    let result: CategoryItem[] = [];
    try {
      const sql = 'SELECT * FROM category order by id';
      let params: ValueType[] = [];
      //params.push(billType.valueOf());

      const resultSet = this.rdbStore?.querySqlSync(sql, params); // 或使用 executeSql（需处理结果集）
      while (resultSet?.goToNextRow()) {

        // 获取列值
        const id = resultSet.getLong(resultSet.getColumnIndex('id'));
        const category_name = resultSet.getString(resultSet.getColumnIndex('category_name'));
        const image_url = "app.media." + resultSet.getString(resultSet.getColumnIndex('image_url'));
        const bill_type = resultSet.getLong(resultSet.getColumnIndex('bill_type'));
        const timestamp = resultSet.getLong(resultSet.getColumnIndex('timestamp'));

        console.log(`ID: ${id}, category_name: ${category_name}, image_url: ${image_url}, bill_type:${bill_type}}, Timestamp: ${timestamp}`);

        let item: CategoryItem =
          {
            category_image: image_url,
            category_name: category_name,
            bill_type: bill_type
          }

        result.push(item);
      }

      resultSet?.close();

    } catch (error) {
      console.error(`Failed to execute SQL: ${error.message}`);

    }
    return result
  }

  getCategorySum(bill_book_id: number, begin: number, end: number, bill_type: BillTypeEnum,
    limit?: number): CategorySumData[] {

    let result: CategorySumData[] = [];
    try {
      let sql: string = `select sum(amount) as total ,category,COUNT(*) AS rows from bills
                 where bill_type=? and timestamp>=? and timestamp <?
                 and bill_book_id= ?
                 group by category order by total asc`

      if (limit) {
        sql += ` limit ${limit}`
      }

      let params: ValueType[] = [bill_type, begin, end, bill_book_id];


      const resultSet = this.rdbStore?.querySqlSync(sql, params); // 或使用 executeSql（需处理结果集）
      while (resultSet?.goToNextRow()) {

        // 获取列值
        const total = resultSet.getLong(resultSet.getColumnIndex('total'));
        const date = resultSet.getString(resultSet.getColumnIndex('category'));
        const rows = resultSet.getLong(resultSet.getColumnIndex('rows'));


        console.log(`total: ${total}, date: ${date}`);

        let item: CategorySumData =
          {
            amount: total,
            category: date,
            rows: rows
          }

        result.push(item);
      }

      resultSet?.close();

    } catch (error) {
      console.error(`Failed to execute SQL: ${error.message}`);

    }

    return result
  }


  getDaySum(bill_book_id: number, begin: number, end: number, bill_type: BillTypeEnum): SumData[] {

    let result: SumData[] = [];
    try {
      const sql = `SELECT SUM(amount) as total,  strftime('%Y-%m-%d', timestamp/1000, 'unixepoch','localtime') AS date
                 FROM bills
                 where bill_type=? and timestamp>=? and timestamp <?
                 and bill_book_id= ?
                 group by date order  by date asc`
      let params: ValueType[] = [bill_type, begin, end, bill_book_id];


      const resultSet = this.rdbStore?.querySqlSync(sql, params); // 或使用 executeSql（需处理结果集）
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

  getMonthSum(bill_book_id: number, begin: number, end: number, bill_type: BillTypeEnum): SumData[] {

    let result: SumData[] = [];
    try {
      const sql = `SELECT SUM(amount) as total,  strftime('%Y-%m', timestamp/1000, 'unixepoch','localtime') AS date
                 FROM bills
                 where bill_type=? and timestamp>=? and timestamp <?
                 and bill_book_id= ?
                 group by date order  by date asc`
      let params: ValueType[] = [bill_type, begin, end, bill_book_id];


      const resultSet = this.rdbStore?.querySqlSync(sql, params); // 或使用 executeSql（需处理结果集）
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

  insertAllBillRecord(parsedObj: BillDbRecord[]) {

    parsedObj.forEach(element => {
      this.insertOneBill(element)
    });
  }

  getAllBillRecord() {
    let result: BillDbRecord[] = []
    try {
      // 1. 执行 SQL 查询
      const sql = 'SELECT * FROM bills order by timestamp desc';
      const resultSet = this.rdbStore?.querySqlSync(sql); // 或使用 executeinSql（需处理结果集）

      while (resultSet?.goToNextRow()) {
        // 获取列索引
        const idIndex = resultSet.getColumnIndex('id');
        const bill_book_id_index = resultSet.getColumnIndex('bill_book_id');
        const amountIndex = resultSet.getColumnIndex('amount');
        const categoryIndex = resultSet.getColumnIndex('category');
        const bill_type_Index = resultSet.getColumnIndex('bill_type');
        const timestampIndex = resultSet.getColumnIndex('timestamp');
        const notesIndex = resultSet.getColumnIndex('notes');
        const extraFieldsIndex = resultSet.getColumnIndex('extra_fields');

        // 获取列值
        const idValue = resultSet.getLong(idIndex);
        const bill_book_id = resultSet.getLong(bill_book_id_index);

        const amount = resultSet.getLong(amountIndex);
        const category = resultSet.getString(categoryIndex);
        const bill_type = resultSet.getLong(bill_type_Index);
        const timestamp = resultSet.getLong(timestampIndex);
        const notes = resultSet.getString(notesIndex);
        const extraFields = resultSet.getString(extraFieldsIndex);

        console.log(`ID: ${idValue}, Amount: ${amount}, Category: ${category}, bill_type:${bill_type}},
         Timestamp: ${timestamp}, Notes: ${notes}, Extra Fields: ${extraFields}`);

        let item: BillDbRecord =
          {
            id: idValue,
            bill_book_id: bill_book_id,
            category: category,
            bill_type: bill_type,
            amount: amount,
            timestamp: timestamp,
            notes: notes,
            extra_fields: extraFields
          }

        result.push(item);
      }

      resultSet?.close();


    } catch (error) {
      console.error("mylog", `Failed to execute SQL: ${error.message}`);

    }

    return result;
  }

  getBillRecordMonth(bill_book_id: number, begin: number, end: number) {
    let result: RecordItemInfo[] = []
    try {
      // 1. 执行 SQL 查询
      const sql = 'SELECT * FROM bills where timestamp>=? and timestamp<? '
        + ' and bill_book_id=? '
        + 'order by timestamp desc';

      let params: ValueType[] = [begin, end, bill_book_id];
      const resultSet = this.rdbStore?.querySqlSync(sql, params); // 或使用 executeSql（需处理结果集）

      while (resultSet?.goToNextRow()) {
        // 获取列索引
        const idIndex = resultSet.getColumnIndex('id');
        const bill_book_id_index = resultSet.getColumnIndex('bill_book_id');
        const amountIndex = resultSet.getColumnIndex('amount');
        const categoryIndex = resultSet.getColumnIndex('category');
        const bill_type_Index = resultSet.getColumnIndex('bill_type');
        const timestampIndex = resultSet.getColumnIndex('timestamp');
        const notesIndex = resultSet.getColumnIndex('notes');
        const extraFieldsIndex = resultSet.getColumnIndex('extra_fields');

        // 获取列值
        const idValue = resultSet.getLong(idIndex);
        const bill_book_id = resultSet.getLong(bill_book_id_index);
        const amount = resultSet.getLong(amountIndex);
        const category = resultSet.getString(categoryIndex);
        const bill_type = resultSet.getLong(bill_type_Index);
        const timestamp = resultSet.getLong(timestampIndex);
        const notes = resultSet.getString(notesIndex);
        const extraFields = resultSet.getString(extraFieldsIndex);

        console.log(`ID: ${idValue}, Amount: ${amount}, Category: ${category}, bill_type:${bill_type}},
         Timestamp: ${timestamp}, Notes: ${notes}, Extra Fields: ${extraFields} ,bill_book_id:${bill_book_id}`);

        let item: RecordItemInfo =
          {
            id: idValue,
            bill_book_id: bill_book_id,
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


  // 初始化方法必须完整覆盖赋值逻辑

  async initDatabase(context: Context): Promise<void> {
    if (this.rdbStore) {
      return; // 已初始化，直接返回
    }

    const STORE_CONFIG: relationalStore.StoreConfig = {
      name: db_file_name,
      securityLevel: relationalStore.SecurityLevel.S1,
      encrypt: false,
      customDir: db_file_dir,
      isReadOnly: false,
    };

    try {

      const store = await relationalStore.getRdbStore(context, STORE_CONFIG)

      // 处理数据库版本和表结构
      if (store.version === 0) {
        // 初始版本，创建表结构


        store.executeSync(SQL_CREATE_TABLE);
        //store.executeSync(SQL2);
        store.executeSync(SQL_index1);
        //初始化数据
        store.executeSync(init_category_table_sql);

        let categoryDataLines = init_category_data_sql.split(";");
        categoryDataLines = categoryDataLines.filter(line => line.trim() != "")

        categoryDataLines.forEach((line) => {
          console.log(line);
          store.executeSync(line);
        })

        //初始化帐本
        store.executeSync(init_bill_book_table_sql);

        let billBookDataLines = init_bill_book_data_sql.split(";");
        billBookDataLines = billBookDataLines.filter(line => line.trim() != "")

        billBookDataLines.forEach((lineData) => {
          console.log(lineData);
          store.executeSync(lineData);
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
      console.log("mylog", "设置当前数据库实例成功")
    } catch (error) {
      console.error('初始化数据库失败:', error);
      // throw  new Error(error)

    }

  }
}
