import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { KeyboardAvoidMode, window } from '@kit.ArkUI';
import { PreferenceStore } from '../utils/PreferenceStore';
import { DatabaseHelper } from '../utils/DatabaseHelper';
import CategoryMapSingleton from '../models/CategoryMapSingleton';
import { AutoBackupManager } from '../utils/AutoBackupManager';

const DOMAIN = 0x0000;

export default class EntryAbility extends UIAbility {
  async onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): Promise<void> {
    this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onCreate');

    //test1();

    //DatabaseHelper.getInstance().restore(this.context)
    // 获取创建程序控制管理器
    //const manager = abilityAccessCtrl.createAtManager()

    //await manager.requestPermissionsFromUser(this.context, ["ohos.permission.READ_WRITE_DOCUMENTS_DIRECTORY"]);
    //
    // // 申请录音(麦克风)权限 --- 进入应用的时候
    // await manager.requestPermissionsFromUser(this.context, [
    //   "ohos.permission.MICROPHONE"
    // ])


    await DatabaseHelper.getInstance().initDatabase(this.context)
    CategoryMapSingleton.getInstance().initializeMap()

    let manager = new AutoBackupManager(this.context)
    let backupDir = await manager.createDownloadPackageDir(this.context)
    await manager.backup(backupDir)

  }

  onDestroy(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  async onWindowStageCreate(windowStage: window.WindowStage): Promise<void> {
    // Main window is created, set main page for this ability
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    PreferenceStore.init(this.context)

    //console.log("mylog", "begin call createKVStore")
    //await CategoryResourceStore.getInstance().createKVStore(this.context)
    //console.log("mylog", "end call createKVStore")

    windowStage.loadContent(
      'pages/Index',
      //"pages/test/TestDatePickerPage"
      //"pages/test/SearchTestPage"
      (err) => {
        if (err.code) {
          hilog.error(DOMAIN, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
          return;
        }

        windowStage.getMainWindowSync().getUIContext().setKeyboardAvoidMode(KeyboardAvoidMode.RESIZE)
        hilog.info(DOMAIN, 'testTag', 'Succeeded in loading the content.');
      });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onBackground');
  }
}