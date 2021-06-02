
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'settings/settings_model/settings.dart';
import 'currency/currency_models/conversion_rates.dart';
import 'utils/db_consts.dart';
import 'account/account_ui/account_screen.dart';
import 'app/app_screen.dart';
import 'app/home_screen.dart';
import 'entry/entry_ui/add_edit_entry_screen.dart';
import 'env.dart';
import 'log/log_ui/add_edit_log_Screen.dart';
import 'login_register/login_register_ui/login_register_screen.dart';
import 'settings/settings_ui/settings_screen.dart';
import 'utils/expense_routes.dart';
import 'utils/keys.dart';

void main() async {
  // allows code before runApp
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await Hive.initFlutter();
  Hive.registerAdapter(SettingsAdapter());
  Hive.registerAdapter(ConversionRatesAdapter());
  await Hive.openBox<Settings>(SETTINGS_BOX);
  final currencyBox = await Hive.openBox<Map<String, ConversionRates>>(CURRENCY_BOX);
  Env.userFetcher.startApp();

  runApp(App(currencyBox: currencyBox));
}

class App extends StatelessWidget {
  final Box? currencyBox;

  const App({Key? key, this.currencyBox}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      getPages: [
        GetPage(name: ExpenseRoutes.home, page: () => HomeScreen(key: ExpenseKeys.homeScreen, currencyBox: currencyBox)),
        GetPage(name: ExpenseRoutes.loginRegister, page: () => LoginRegisterScreen(key: ExpenseKeys.loginScreen)),
        GetPage(name: ExpenseRoutes.app, page: () => AppScreen(key: ExpenseKeys.appScreen)),
        GetPage(name: ExpenseRoutes.account, page: () => AccountScreen(key: ExpenseKeys.accountScreen)),
        GetPage(name: ExpenseRoutes.settings, page: () => SettingsScreen(key: ExpenseKeys.settingsScreen)),
        GetPage(name: ExpenseRoutes.addEditLog, page: () => AddEditLogScreen(key: ExpenseKeys.addEditLogScreen)),
        GetPage(
            name: ExpenseRoutes.addEditEntries, page: () => AddEditEntryScreen(key: ExpenseKeys.addEditEntriesScreen)),
      ],
      initialRoute: ExpenseRoutes.home,
      key: ExpenseKeys.main,
    );
  }
}
