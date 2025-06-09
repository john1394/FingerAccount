export interface BackupInfoRecord {


  /**
   *yyyy-MM-DD HH:MM:SS 格式
   */
  timeStr: string
  backupFilePath: string

}

export interface PopupItem {
  title: string
  icon: ResourceStr,
  itemClick?: () => void
}