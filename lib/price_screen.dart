import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String currencySelected = 'USD';
  double btcPrice;
  List<Crypto> cryptoData = [];

  bool isWaiting = true;

  DropdownButton<String> getDropdownButton() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (var currency in currenciesList) {
      dropdownItems
          .add(DropdownMenuItem(child: Text(currency), value: currency));
    }

    return DropdownButton<String>(
      style: TextStyle(color: Colors.red),
      items: dropdownItems,
      value: currencySelected,
      onChanged: (value) {
        setState(() {
          currencySelected = value;
          getData();
        });
      },
    );
  }

  CupertinoPicker getCupertinoPicker() {
    List<Text> dropdownItems = [];
    for (var currency in currenciesList) {
      dropdownItems.add(Text(currency));
    }
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      children: dropdownItems,
      itemExtent: 36.0,
      onSelectedItemChanged: (int value) {
        setState(() {
          currencySelected = currenciesList[value];
          getData();
        });
      },
    );
  }

  void getData() async {
    isWaiting = true;
    try {
      var data = await CoinData().getData(currency: currencySelected);

      isWaiting = false;
      setState(() {
        cryptoData = data;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Container(
            height: 100.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            child: Platform.isIOS ? getCupertinoPicker() : getDropdownButton(),
          ),
          Expanded(
            flex: 8,
            child: makeCards(),
          ),
        ],
      ),
    );
  }

  Container makeCards() {
    List<CryptoCard> cryptoCards = [];
    for (Crypto crypto in cryptoData) {
      cryptoCards.add(
        CryptoCard(
          crypto: crypto,
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF1C284E),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40), topRight: Radius.circular(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: cryptoCards,
      ),
    );
  }
}

class StatiticsData extends StatelessWidget {
  final String title;
  final String value;

  const StatiticsData({Key key, this.title, this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      textBaseline: TextBaseline.alphabetic,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          title,
          textAlign: TextAlign.end,
          style: TextStyle(
            fontSize: 10.0,
            color: Color(0xFFB5c1e9),
          ),
        ),
        Text(
          value,
          textAlign: TextAlign.end,
          style: TextStyle(
            fontSize: 14.0,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class CryptoCard extends StatelessWidget {
  const CryptoCard({
    this.crypto,
  });

  final Crypto crypto;

  @override
  Widget build(BuildContext context) {
    String price = crypto.price.toStringAsFixed(2);
    double changePercent = crypto.changePercentDay;
    String changePrice = crypto.changePriceDay.toStringAsFixed(2);
    String name = crypto.name;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
      child: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 28.0),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(right: 2.0),
                          child: Image(
                            image: NetworkImage(
                              'https://bitcoinaverage.com/markets/assets/img/logo/32/$name.png',
                            ),
                            width: 15.0,
                            colorBlendMode: BlendMode.srcOut,
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              crypto.name,
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Color(0xFFD1D8EE),
                              ),
                            ),
                            Text(
                              crypto.simbol,
                              style: TextStyle(
                                fontSize: 10.0,
                                color: Color(0xFFB5c1e9),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                  flex: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        price,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24.0,
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Icon(
                            crypto.changePercentDay.isNegative
                                ? Icons.trending_down
                                : Icons.trending_up,
                            color: crypto.changePercentDay < 0
                                ? Colors.red.shade400
                                : Colors.green,
                            size: 14.0,
                          ),
                          Text(
                            '$changePrice',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: crypto.changePercentDay.isNegative
                                  ? Colors.red.shade400
                                  : Colors.green,
                            ),
                          ),
                          Text(
                            '($changePercent%)',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: crypto.changePercentDay.isNegative
                                  ? Colors.red
                                  : Colors.green,
                            ),
                          ),
                        ],
                      )
                    ],
                  )),
              Expanded(
                  flex: 4,
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Today',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10.0,
                          color: Color(0xFFD1D8EE),
                        ),
                      ),
                      StatiticsData(
                          title: 'Open',
                          value: crypto.priceOpen.toStringAsFixed(2)),
                      StatiticsData(
                          title: 'High',
                          value: crypto.priceHigh.toStringAsFixed(2)),
                      StatiticsData(
                          title: 'Low',
                          value: crypto.priceLow.toStringAsFixed(2)),
                    ],
                  ))
            ],
          ),

          /* Text(
            '1 $cryptoCurrency = $value $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.black,
            ),
          ), */
        ),
      ),
    );
  }
}
