import 'package:hdsaison_signing/src/helpers/untils/logger.dart';

enum TickerType { ascending, descending }

class Ticker {
  const Ticker();
  Stream<int> tick({required int ticks, required TickerType tickerType}) {
    return Stream.periodic(const Duration(seconds: 1), (x) {
      UtilLogger.log('Ticker', tickerType == TickerType.ascending ? '${ticks + x + 1}' : '${ticks - x - 1}');
      return tickerType == TickerType.ascending ? ticks + x + 1 : ticks - x - 1;
    });
  }
}
