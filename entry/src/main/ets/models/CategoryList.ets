import CategoryMapSingleton from './CategoryMapSingleton';

export interface CategoryItem {

  // 类型图片
  category_image: string
  // 类型名称
  category_name: string
  bill_type: number


}


// function getDefaultCategoryMap(): CategoryItem[] {
//   return DatabaseHelper.getInstance().getCategoryData();
// }

function getDefaultIncomeCategoryList() {
  let items: CategoryItem[] = [];

  for (const value of CategoryMapSingleton.getInstance().getInComeMap().values()) {
    items.push(value);

  }

  return items;

}

function getDefaultOutcomeCategoryList() {

  let items: CategoryItem[] = [];

  for (const value of CategoryMapSingleton.getInstance().getOutComeMap().values()) {
    items.push(value);

  }
  return items;


}


export const DefaultIncomeCategoryList: CategoryItem[] = getDefaultIncomeCategoryList()

export const DefaultOutcomeCategoryList: CategoryItem[] = getDefaultOutcomeCategoryList()





