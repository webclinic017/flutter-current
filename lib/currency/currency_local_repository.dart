import '../env.dart';
import '../utils/db_consts.dart';
import 'package:hive/hive.dart';

import 'currency_models/conversion_rates.dart';

abstract class CurrencyLocalRepository {
  Future<Map<String, ConversionRates>> loadAllConversionRates();

  Future<void> saveConversionRates({required Map<String, ConversionRates> conversionRateMap});
}

class HiveCurrencyRepository extends CurrencyLocalRepository {
  @override
  Future<Map<String, ConversionRates>> loadAllConversionRates() async {
    var box = Hive.box<Map<String, ConversionRates>>(CURRENCY_BOX);
    Map<String, ConversionRates> conversionRateMap =
        Map<String, ConversionRates>.from(Env.store.state.currencyState.conversionRateMap);

    conversionRateMap = box.get(CONVERSION_RATE_MAP)!.cast<String, ConversionRates>();

    return conversionRateMap;
  }

  @override
  Future<void> saveConversionRates({required Map<String, ConversionRates> conversionRateMap}) async {
    var box = Hive.box<Map<String, ConversionRates>>(CURRENCY_BOX);
    box.put(CONVERSION_RATE_MAP, conversionRateMap);
  }
}
