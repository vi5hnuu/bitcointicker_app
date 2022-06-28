import 'package:bitcointicker/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  const PriceScreen({Key? key}) : super(key: key);

  @override
  State<PriceScreen> createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen>{
  String selectedCurrency='USD';
  List<String> eqPrices=List.filled(3, 'NAN',growable: false);

  DropdownButton<String> androidDropDownButton(){
    return DropdownButton<String>(
        value: selectedCurrency,
        onChanged: (String? value){
          setState((){
            selectedCurrency=value!;
            updatePrice(selectedCurrency);
          });
        },
        items: currenciesList.map<DropdownMenuItem<String>>((element){
          return DropdownMenuItem(value:element,child: Text(element));
        }).toList(growable:false),
        elevation: 5,
        borderRadius: BorderRadius.circular(15.0),
        icon: Icon(Icons.check_circle_outline),
        menuMaxHeight: 300,
        iconSize: 30,
      );
  }
  CupertinoPicker iosPicker(){
        return CupertinoPicker(
          itemExtent: 32.0,
          children: currenciesList.map((cur)=>Text(cur)).toList(growable: false),
          onSelectedItemChanged: (index){
            setState((){
              selectedCurrency=currenciesList[index];
              updatePrice(selectedCurrency);
            });
          },
          looping: true,
        );
  }
  Widget getPicker(){
    if(Platform.isAndroid)
        return androidDropDownButton();
    else
        return iosPicker();
  }

  void updatePrice(String selectedCurr)async{
    CoinData coinData=CoinData(fromCur: selectedCurrency);
    await coinData.loadPrice();

      setState((){
        for(int i=0;i<3;i++)
          eqPrices[i]=coinData.conPrice[i];
      });
  }
  @override
  void initState() {
    super.initState();
    updatePrice("BTC");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment:MainAxisAlignment.spaceBetween ,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for(int i=0;i<3;i++)
                ReusableCard(eqPrice: eqPrices[i], selectedCurrency: selectedCurrency,toCurr: cryptoList[i],),
            ],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child:getPicker(),
          ),
        ],

      ),
    );
  }
}

class ReusableCard extends StatelessWidget {
  const ReusableCard({
    Key? key,
    required this.eqPrice,
    required this.selectedCurrency,
    required this.toCurr
  }) : super(key: key);

  final String eqPrice;
  final String selectedCurrency;
  final String toCurr;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 20.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0,horizontal: 28.0),
          child: Text(
            '1 ${selectedCurrency}\n${eqPrice} ${toCurr}',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20.0,
                color: Colors.white
            ),
          ),
        ),
      ),
    );
  }
}

