import 'dart:convert';

import 'package:http/http.dart' as http;

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
];
//${baseUrl}/BTC/USD?apikey=${kApiKey}
class CoinData {
  static const kApiKey='9A33082F-75A9-498C-847C-48698D450E70';
  static const baseUrl='https://rest.coinapi.io/v1/exchangerate';
  String fromCur;
  List<String> conPrice=[];
  CoinData({required this.fromCur});

  Future<void> loadPrice() async{
    for(int i=0;i<3;i++){
      http.Response response= await http.get(Uri.parse('${baseUrl}/${this.fromCur}/${cryptoList[i]}?apikey=${kApiKey}'));
      if(response.statusCode==200){
        var coinConversionData=jsonDecode(response.body);
        conPrice.add(coinConversionData['rate'].toString());
      }
      else{
        conPrice.add("NAN");
        print(response.statusCode);//429 limit of request exceed
      }
    }

  }
}