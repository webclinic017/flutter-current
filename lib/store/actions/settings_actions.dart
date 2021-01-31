part of 'actions.dart';

//TODO load setting from JSON file, change settings

AppState _updateSettingsState(
  AppState appState,
  SettingsState update(SettingsState settingsState),
) {
  return appState.copyWith(settingsState: update(appState.settingsState));
}

class UpdateSettings implements Action {
  final Maybe<Settings> settings;

  UpdateSettings({@required this.settings});

  @override
  AppState updateState(AppState appState) {
    Env.settingsFetcher.writeAppSettings(settings.value);

    return _updateSettingsState(
        appState,
        (settingsState) => settingsState.copyWith(
              settings: settings,
            ));
  }
}

class ChangeDefaultLog implements Action {
  final Log log;

  ChangeDefaultLog({this.log});

  @override
  AppState updateState(AppState appState) {
    Settings settings = appState.settingsState.settings.value;
    Map<String, Log> logs = appState.logsState.logs;
    if (log != null && logs.containsKey(log.id)) {
      settings = settings.copyWith(defaultLogId: log.id);
    }

    Env.settingsFetcher.writeAppSettings(settings);

    return _updateSettingsState(appState, (settingsState) => settingsState.copyWith(settings: Maybe.some(settings)));
  }
}

class SettingsAddEditCategory implements Action {
  final MyCategory category;

  SettingsAddEditCategory({@required this.category});

  @override
  AppState updateState(AppState appState) {
    Settings settings = appState.settingsState.settings.value;
    List<MyCategory> categories = List.from(settings.defaultCategories);

    if (category.id != null) {
      categories[categories.indexWhere((e) => e.id == category.id)] = category;
    } else {
      categories.add(category.copyWith(id: Uuid().v4()));
    }

    settings = settings.copyWith(defaultCategories: categories);
    Env.settingsFetcher.writeAppSettings(settings);

    return _updateSettingsState(appState, (settingsState) => settingsState.copyWith(settings: Maybe.some(settings)));
  }
}

class SettingsDeleteCategory implements Action {
  final MyCategory category;

  SettingsDeleteCategory({@required this.category});

  @override
  AppState updateState(AppState appState) {
    Settings settings = appState.settingsState.settings.value;
    List<MyCategory> categories = List.from(settings.defaultCategories);

    if (category.id != NO_CATEGORY) {
      //remove as long as the it is not NO_CATEGORY
      categories = categories.where((element) => element.id != category.id).toList();
      settings = settings.copyWith(defaultCategories: categories);
      Env.settingsFetcher.writeAppSettings(settings);
    }

    return _updateSettingsState(appState, (settingsState) => settingsState.copyWith(settings: Maybe.some(settings)));
  }
}

class SettingsAddEditSubcategory implements Action {
  final MyCategory subcategory;

  SettingsAddEditSubcategory({@required this.subcategory});

  @override
  AppState updateState(AppState appState) {
    Settings settings = appState.settingsState.settings.value;
    List<MyCategory> subcategories = settings.defaultSubcategories;

    if (subcategory.id != null) {
      subcategories[subcategories.indexWhere((e) => e.id == subcategory.id)] = subcategory;
    } else {
      subcategories.add(subcategory.copyWith(id: Uuid().v4()));
    }

    settings = settings.copyWith(defaultSubcategories: subcategories);
    Env.settingsFetcher.writeAppSettings(settings);

    return _updateSettingsState(appState, (settingsState) => settingsState.copyWith(settings: Maybe.some(settings)));
  }
}

class SettingsDeleteSubcategory implements Action {
  final MyCategory subcategory;

  SettingsDeleteSubcategory({@required this.subcategory});

  @override
  AppState updateState(AppState appState) {
    Settings settings = appState.settingsState.settings.value;
    List<MyCategory> subcategories = settings.defaultSubcategories;

    if (subcategory.id != NO_SUBCATEGORY) {
      //remove as long as the it is not NO_CATEGORY
      subcategories = subcategories.where((element) => element.id != subcategory.id).toList();
      settings = settings.copyWith(defaultSubcategories: subcategories);
      Env.settingsFetcher.writeAppSettings(settings);
    }

    return _updateSettingsState(appState, (settingsState) => settingsState.copyWith(settings: Maybe.some(settings)));
  }
}

class SetExpandedSettingsCategories implements Action {
  AppState updateState(AppState appState) {
    List<bool> expandedCategories = [];
    appState.settingsState.settings.value.defaultCategories.forEach((element) {
      expandedCategories.add(false);
    });

    return _updateSettingsState(
        appState, (settingsState) => settingsState.copyWith(expandedCategories: expandedCategories));
  }
}

class ExpandCollapseSettingsCategory implements Action {
  final int index;

  ExpandCollapseSettingsCategory({@required this.index});

  AppState updateState(AppState appState) {
    List<bool> expandedCategories = List.from(appState.settingsState.expandedCategories);
    expandedCategories[index] = !expandedCategories[index];

    return _updateSettingsState(
        appState, (settingsState) => settingsState.copyWith(expandedCategories: expandedCategories));
  }
}

class ReorderCategoryFromSettingsScreen implements Action {
  final int oldCategoryIndex;
  final int newCategoryIndex;

  ReorderCategoryFromSettingsScreen({@required this.oldCategoryIndex, @required this.newCategoryIndex});

  AppState updateState(AppState appState) {
    //reorder categories list
    Settings settings = appState.settingsState.settings.value;
    List<MyCategory> categories = List.from(settings.defaultCategories);
    MyCategory movedCategory = categories.removeAt(oldCategoryIndex);
    categories.insert(newCategoryIndex, movedCategory);

    //reorder expanded list
    List<bool> expandedCategories = List.from(appState.settingsState.expandedCategories);
    bool movedExpansion = expandedCategories.removeAt(oldCategoryIndex);
    expandedCategories.insert(newCategoryIndex, movedExpansion);

    return _updateSettingsState(
        appState,
        (settingsState) => settingsState.copyWith(
            settings: Maybe.some(settings.copyWith(defaultCategories: categories)),
            expandedCategories: expandedCategories));
  }
}

class ReorderSubcategoryFromSettingsScreen implements Action {
  final int oldCategoryIndex;
  final int newCategoryIndex;
  final int oldSubcategoryIndex;
  final int newSubcategoryIndex;

  ReorderSubcategoryFromSettingsScreen(
      {@required this.oldCategoryIndex,
      @required this.newCategoryIndex,
      @required this.oldSubcategoryIndex,
      @required this.newSubcategoryIndex});

  AppState updateState(AppState appState) {
    Settings settings = appState.settingsState.settings.value;
    String oldParentId = settings.defaultCategories[oldCategoryIndex].id;
    String newParentId = settings.defaultCategories[newCategoryIndex].id;
    List<MyCategory> subcategories = List.from(settings.defaultSubcategories);
    List<MyCategory> subsetOfSubcategories = List.from(settings.defaultSubcategories);
    subsetOfSubcategories
        .retainWhere((subcategory) => subcategory.parentCategoryId == oldParentId); //get initial subset
    MyCategory subcategory = subsetOfSubcategories[oldSubcategoryIndex];

    //NO_SUBCATEGORY cannot be altered and no subcategories may be moved to NO_CATEGORY
    if (subcategory.id != NO_SUBCATEGORY && newParentId != NO_CATEGORY) {
      if (oldParentId == newParentId) {
        //subcategory has not moved parents
        subsetOfSubcategories.remove(subcategory);
        subsetOfSubcategories.insert(newSubcategoryIndex, subcategory);
      } else {
        //category has moved parents, organize in new list with revised parent
        subsetOfSubcategories = List.from(subcategories); //reinitialize subset list
        subsetOfSubcategories.retainWhere((subcategory) => subcategory.parentCategoryId == newParentId);
        subsetOfSubcategories.insert(newSubcategoryIndex, subcategory.copyWith(parentCategoryId: newParentId));
      }

      //remove from subcategory list
      subsetOfSubcategories.forEach((reordedSub) {
        subcategories.removeWhere((sub) => reordedSub.id == sub.id);
      });
      //reinsert in subcategory list in revised order
      subsetOfSubcategories.forEach((subcategory) {
        subcategories.add(subcategory);
      });
    }

    return _updateSettingsState(
        appState,
        (settingsState) =>
            settingsState.copyWith(settings: Maybe.some(settings.copyWith(defaultSubcategories: subcategories))));
  }
}
