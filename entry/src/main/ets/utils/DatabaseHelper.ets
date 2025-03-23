import { relationalStore } from '@kit.ArkData';


const db_file_name="bill.db"
const db_file_dir= "customDir/subCustomDir"

const SQL_CREATE_TABLE =
  'CREATE TABLE IF NOT EXISTS bills (\n' +
    '    id INTEGER PRIMARY KEY AUTOINCREMENT,\n' +
    '    amount INTEGER,\n' +
    '    category TEXT,\n' +
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


  insertTest() {
    this.rdbStore?.executeSync("insert into bills(amount) values('1')");
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

  private async getRdbStorePromise(context: Context, config: relationalStore.StoreConfig): Promise<relationalStore.RdbStore> {
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
            store.executeSql(SQL_CREATE_TABLE);
            store.executeSql(SQL2);
            store.executeSql(SQL_index1);
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
          throw  new Error(error)
        }
      })
      ()
      ;
    }

    await this.initPromise;
  }

  async initDatabase1(context:
    Context
  ):
    Promise<void> {
    if (!this.rdbStore) {

      const
        STORE_CONFIG: relationalStore.StoreConfig = {
          name: 'RdbTest1.db', // 数据库文件名
          securityLevel: relationalStore.SecurityLevel.S1, // 数据库安全级别
          encrypt: false, // 可选参数，指定数据库是否加密，默认不加密
          customDir: 'customDir/subCustomDir', // 可选参数，数据库自定义路径。数据库将在如下的目录结构中被创建：context.databaseDir + '/rdb/' + customDir，其中context.databaseDir是应用沙箱对应的路径，'/rdb/'表示创建的是关系型数据库，customDir表示自定义的路径。当此参数不填时，默认在本应用沙箱目录下创建RdbStore实例。
          isReadOnly: false // 可选参数，指定数据库是否以只读方式打开。该参数默认为false，表示数据库可读可写。该参数为true时，只允许从数据库读取数据，不允许对数据库进行写操作，否则会返回错误码801。
        }
      ;

      // 判断数据库版本，如果不匹配则需进行升降级操作
      relationalStore.getRdbStore
      (
        context,
        STORE_CONFIG, (err, store) => {
        if (err) {
          console.error(`Failed to get RdbStore. Code:${err.code}, message:${err.message}`);
          return;
        }

        console.info
        (
          'Succeeded in getting RdbStore.'
        )
        ;


        // 当数据库创建时，数据库默认版本为0
        if
        (
          store.version
            ===
            0
        ) {
          store
            .executeSql(SQL_CREATE_TABLE); // 创建数据表

          store
            .executeSql(SQL2); // 创建数据表
          store
            .executeSql(SQL_index1); // 创建数据表
          // 设置数据库的版本，入参为大于0的整数
          store
            .version = 1
          ;
        }

        // 如果数据库版本不为0且和当前数据库版本不匹配，需要进行升降级操作
        // 当数据库存在并假定版本为1时，例应用从某一版本升级到当前版本，数据库需要从1版本升级到2版本
        if (store.version === 1) {
          // version = 1：表结构：EMPLOYEE (NAME, SALARY, CODES, ADDRESS) => version = 2：表结构：EMPLOYEE (NAME, AGE, SALARY, CODES, ADDRESS)
          (store as relationalStore.RdbStore).executeSql('ALTER TABLE EMPLOYEE ADD COLUMN AGE INTEGER');
          store.version = 2;
        }

        // 当数据库存在并假定版本为2时，例应用从某一版本升级到当前版本，数据库需要从2版本升级到3版本
        if (store.version === 10) {
          // version = 2：表结构：EMPLOYEE (NAME, AGE, SALARY, CODES, ADDRESS) => version = 3：表结构：EMPLOYEE (NAME, AGE, SALARY, CODES)
          (store as relationalStore.RdbStore).executeSql('ALTER TABLE EMPLOYEE DROP COLUMN ADDRESS TEXT');
          store.version = 11;
        }

        this.rdbStore = store;
      }

      )
      ;
    }
  }
}