import 'package:expenses/app/common_widgets/app_dialog.dart';
import 'package:expenses/app/common_widgets/empty_content.dart';
import 'package:expenses/categories/categories_model/app_category/app_category.dart';
import 'package:expenses/categories/categories_screens/category_list_tile.dart';
import 'package:expenses/categories/categories_screens/edit_category_dialog.dart';
import 'package:expenses/entry/entry_model/app_entry.dart';
import 'package:expenses/store/actions/single_entry_actions.dart';
import 'package:expenses/store/connect_state.dart';
import 'package:expenses/utils/db_consts.dart';
import 'package:expenses/utils/keys.dart';
import 'package:expenses/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../env.dart';

class EntryCategoryListDialog extends StatelessWidget {
  final VoidCallback backChevron;
  final CategoryOrSubcategory categoryOrSubcategory;

  const EntryCategoryListDialog({Key key, this.backChevron, this.categoryOrSubcategory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<AppCategory> categories;
    return ConnectState(
        where: notIdentical,
        map: (state) => state.singleEntryState,
        builder: (singleEntryState) {
          if (categoryOrSubcategory == CategoryOrSubcategory.category) {
            categories = List.from(singleEntryState.categories);
          } else {
            categories = List.from(singleEntryState.subcategories);
            categories.retainWhere((subcategory) =>
                subcategory.parentCategoryId == Env.store.state.singleEntryState.selectedEntry.value.categoryId);
          }

          return buildDialog(context: context, categories: categories, singleEntryState: singleEntryState);
        });
  }

  Widget buildDialog({singleEntryState, BuildContext context, List<AppCategory> categories}) {
    return AppDialogWithActions(
      padContent: false,
      title: categoryOrSubcategory == CategoryOrSubcategory.category ? CATEGORY : SUBCATEGORY,
      backChevron: backChevron,
      trailingTitleWidget: _displayAddButton(selectedEntry: singleEntryState.selectedEntry.value),
      child: categories.length > 0 ? _categoryListView(context: context, categories: categories) : EmptyContent(),
    );
  }

  Widget _displayAddButton({MyEntry selectedEntry}) {
    AppCategory category = AppCategory();
    return IconButton(
      icon: Icon(Icons.add),
      onPressed: () => categoryOrSubcategory == CategoryOrSubcategory.category
          ? _entryAddEditCategory(category: category)
          : _entryAddEditSubcategory(subcategory: category),
    );
  }

  Widget _categoryListView({BuildContext context, List<AppCategory> categories}) {
    return ReorderableListView(
        scrollController: PrimaryScrollController.of(context) ?? ScrollController(),
        onReorder: (oldIndex, newIndex) {
          //reorder for categories
          if (categoryOrSubcategory == CategoryOrSubcategory.category) {
            Env.store.dispatch(ReorderCategoriesFromEntryScreen(oldIndex: oldIndex, newIndex: newIndex));
          } else {
            Env.store.dispatch(ReorderSubcategoriesFromEntryScreen(
                newIndex: newIndex, oldIndex: oldIndex, reorderedSubcategories: categories));
          }
        },
        children: _categoryList(context: context, categories: categories));
  }

  List<CategoryListTile> _categoryList({List<AppCategory> categories, BuildContext context}) {
    //determine if list is categories or subcategories
    bool isCategory = categoryOrSubcategory == CategoryOrSubcategory.category;
    return categories
        .map(
          (AppCategory category) => CategoryListTile(
            key: Key(category.id),
            category: category,
            onTapEdit: () => isCategory
                ? _entryAddEditCategory(category: category)
                : _entryAddEditSubcategory(subcategory: category),
            onTap: () =>
                isCategory ? _entrySelectCategory(category: category) : _entrySelectSubcategory(subcategory: category),
          ),
        )
        .toList();
  }

  Future<dynamic> _entryAddEditCategory({@required AppCategory category}) {
    return Get.dialog(
      EditCategoryDialog(
        save: (name, emojiChar, unused) {
          Env.store
              .dispatch(AddEditCategoryFromEntryScreen(category: category.copyWith(name: name, emojiChar: emojiChar)));
        },

        /*setDefault: (category) => {
          Env.logsFetcher.updateLog(log.setCategoryDefault(log: log, category: category)),
        },*/

        delete: () => {
          Env.store.dispatch(DeleteCategoryFromEntryScreen(category: category)),
          Get.back(),
        },
        category: category,
        categoryOrSubcategory: CategoryOrSubcategory.category,
      ),
    );
  }

  Future<dynamic> _entrySelectCategory({@required AppCategory category}) {
    Env.store.dispatch(UpdateEntryCategory(newCategory: category.id));
    if (_entryHasSubcategories(category: category)) {
      Get.back();
      return Get.dialog(
        EntryCategoryListDialog(
          categoryOrSubcategory: CategoryOrSubcategory.subcategory,
          key: ExpenseKeys.subcategoriesDialog,
          backChevron: () => {
            Get.back(),
            Get.dialog(
              EntryCategoryListDialog(
                categoryOrSubcategory: CategoryOrSubcategory.category,
                key: ExpenseKeys.categoriesDialog,
              ),
            ),
          },
        ),
      );
    }

    return null;
  }

  Future<dynamic> _entryAddEditSubcategory({@required AppCategory subcategory}) {
    return Get.dialog(
      EditCategoryDialog(
        categories: Env.store.state.singleEntryState.categories,
        save: (name, emojiChar, parentCategoryId) => {
          Env.store.dispatch(AddEditSubcategoryFromEntryScreen(
              subcategory: subcategory.copyWith(name: name, emojiChar: emojiChar, parentCategoryId: parentCategoryId))),
        },

        //TODO default function

        delete: () => {
          Env.store.dispatch(DeleteSubcategoryFromEntryScreen(subcategory: subcategory)),
          Get.back(),
        },
        initialParent: Env.store.state.singleEntryState.selectedEntry.value.categoryId,
        category: subcategory,
        categoryOrSubcategory: CategoryOrSubcategory.subcategory,
      ),
    );
  }

  Future<void> _entrySelectSubcategory({@required AppCategory subcategory}) async {
    //onTap method for Entry Subcategories
    Env.store.dispatch(UpdateEntrySubcategory(subcategory: subcategory.id));
    Get.back();
  }

  bool _entryHasSubcategories({@required AppCategory category}) {
    if (category.id == NO_CATEGORY || category.id == TRANSFER_FUNDS) {
      return false;
    }
    return true;
  }
}
