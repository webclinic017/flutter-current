
import 'package:expenses/categories/categories_model/app_category/app_category.dart';
import 'package:expenses/utils/db_consts.dart';
import 'package:flutter/material.dart';
import 'package:expenses/categories/categories_screens/category_list_tools.dart';

//leading and trailing components for category list tiles

class CategoryListTileLeading extends StatelessWidget {
  const CategoryListTileLeading({
    Key key,
    @required this.category,
    this.sublist = false,
  }) : super(key: key);

  final AppCategory category;
  final bool sublist;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        sublist
            ? SizedBox(
                width: 10.0,
              )
            : Container(),
        Icon(Icons.unfold_more_outlined),
        SizedBox(width: 5),
        Text(
          category?.emojiChar ?? '\u{2757}',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: EMOJI_SIZE),
        ),
      ],
    );
  }
}

class CategoryListTileTrailing extends StatelessWidget {
  const CategoryListTileTrailing({
    Key key,
    @required this.onTapEdit,
    this.addSubcategory = false,
  }) : super(key: key);

  final VoidCallback onTapEdit;
  final bool addSubcategory;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.center,
      height: 30.0,
      width: 30.0,
      child: IconButton(
        padding: EdgeInsets.all(0),
        icon: Icon(
          addSubcategory ? Icons.add_outlined : Icons.edit_outlined,
          size: EMOJI_SIZE,
        ),
        onPressed: onTapEdit,
      ),
    );
  }
}

class MasterCategoryListTileTrailing extends StatelessWidget {
  const MasterCategoryListTileTrailing({
    Key key,
    @required this.setLogEnt,
    @required this.category,
    @required this.expanded,
    @required this.categories,
  }) : super(key: key);

  final SettingsLogEntry setLogEnt;
  final AppCategory category;
  final bool expanded;
  final List<AppCategory> categories;

  @override
  Widget build(BuildContext context) {

    return CategoryListTileTrailing(
      onTapEdit: () => _canAddSubcategory() ? _onTapAdd() : _onTapEdit(),
      addSubcategory: _canAddSubcategory(),
    );
  }

  _onTapEdit() {
    if (setLogEnt == SettingsLogEntry.log) {
      getLogAddEditCategoryDialog(category: category);
    } else if (setLogEnt == SettingsLogEntry.settings) {
      getSettingsAddEditCategoryDialog(category: category);
    }
  }

  _onTapAdd() {
    AppCategory subcategory = AppCategory(parentCategoryId: category.id);
    if (setLogEnt == SettingsLogEntry.log) {
      getLogAddEditSubcategoryDialog(subcategory: subcategory, categories: categories);
    } else if (setLogEnt == SettingsLogEntry.settings) {
      getSettingsAddEditSubcategoryDialog(subcategory: subcategory, categories: categories);
    }
  }

  bool _canAddSubcategory() {
    return expanded && category.id != NO_CATEGORY && category.id != TRANSFER_FUNDS;
  }
}
