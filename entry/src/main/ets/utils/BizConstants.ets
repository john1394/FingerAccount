export class BizConstants {
  static Category_Top10_Limit: number = 10
  static Category_TOP5_Limit: number = 5
  static SelectedIncomeCategoryIconBackColor: ResourceColor = Color.Green
  static SelectedOutComeCategoryIconBackColor: ResourceColor = $r("app.color.danger")
  static Max_Support_year = 2060
  static Min_Support_year = 2020
  static Max_Memo_char_count = 50
  static Max_Search_char_count = 20
  static MaxNumber = 100000000;
  static Month_reload_data_key = "Month_reload_data_key"
  static Report_reload_data_key = "Report_reload_data_key"
  //基本帐本id，下个版本扩展支持多个帐本，默认为1 bill_book_id
  static Default_bill_book_id: number = 1
  static Rdb_backup_file_suffix = ".backup"
  //总共最多备份数
  static Rdb_backup_file_max_total_count: number = 3
  //每天最多备份数
  static Rdb_backup_max_day_count: number = 2
  static Rdb_backup_name_suffix = "bak_"
}