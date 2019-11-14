import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
  'XMR',
  'DASH',
  'VET',
  'DCR'
];

class CoinData {
  Future getData({String currency}) async {
    //Map<String, String> cryptoPrices = {};
    List<Crypto> cryptoData = [];

    for (String crypto in cryptoList) {
      http.Response response = await http.get(
          'https://apiv2.bitcoinaverage.com/indices/global/ticker/$crypto$currency');

      if (response.statusCode == 200) {
        var decodedData = convert.jsonDecode(response.body);
        double lastPrice = decodedData['last'];
        cryptoData.add(new Crypto(
          name: crypto,
          price: lastPrice,
          changePriceDay: decodedData['changes']['price']['day'],
          changePercentDay: decodedData['changes']['percent']['day'],
          priceOpen: decodedData['open']['day'],
          priceHigh: decodedData['high'],
          priceLow: decodedData['low'],
          simbol: decodedData['display_symbol'],
        ));

        //cryptoPrices[crypto] = lastPrice.toStringAsFixed(0);
      } else {
        print('$crypto$currency : ' + response.reasonPhrase);
      }
    }
    return cryptoData;
  }
}

class Crypto {
  final String name;
  final double price;
  final String simbol;
  final double changePriceDay;
  final double changePercentDay;
  final double priceOpen;
  final double priceHigh;
  final double priceLow;

  Crypto(
      {this.name,
      this.price,
      this.simbol,
      this.changePriceDay,
      this.changePercentDay,
      this.priceOpen,
      this.priceHigh,
      this.priceLow});
}
