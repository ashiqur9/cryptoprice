import 'dart:async';
import 'package:cryptoprice/Service/updateprice.dart';
import 'package:cryptoprice/main.dart';
import 'package:cryptoprice/modes/cryptoprice.dart';
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const _HomeUI(),
      appBar: AppBar(
        title: const Text(
          'Crypto Price',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.teal.shade800,
        centerTitle: true,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          const String symbol = 'TONUSDT';
          Updateprice.request(symbol);
        },
        backgroundColor: Colors.teal.shade800,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

class _HomeUI extends StatefulWidget {
  const _HomeUI({super.key});

  @override
  State<_HomeUI> createState() => __HomeUIState();
}

class __HomeUIState extends State<_HomeUI> {
  TextEditingController _currentSymbol = TextEditingController(text: 'BTCUSDT');
  double price = 0;
  double maxPrice = 0;
  double minPrice = 0;

  void _updatePrice() async {
    Cryptoprice data = await Updateprice.request(_currentSymbol.text);
    setState(() {
      price = data.price;
      if (data.price > maxPrice) {
        maxPrice = data.price;
      }
      if (data.price < minPrice || minPrice == 0) {
        minPrice = data.price;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Track Crypto Prices',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.teal.shade900,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 300,
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Enter Symbol',
                  hintText: 'e.g., BTCUSDT',
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  labelStyle: TextStyle(color: Colors.teal.shade800),
                ),
                controller: _currentSymbol,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Current Price: \$${price.toString()}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Max: \$${maxPrice.toString()}  |  Min: \$${minPrice.toString()}',
              style: TextStyle(
                color: Colors.teal.shade600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              // onPressed: () async {
              //   Cryptoprice data =
              //       await Updateprice.request(_currentSymbol.text);
              //   setState(() {
              //     minPrice = data.price;
              //     maxPrice = data.price;
              //     Timer.periodic(const Duration(seconds: 5), (Timer timer) {
              //       _updatePrice();
              //     });
              //   });
              // },
              onPressed: () async {
                Cryptoprice data =
                    await Updateprice.request(_currentSymbol.text);

                Workmanager().registerPeriodicTask(
                  'cryptoPriceCheck', // Unique task identifier
                  'fetchAndNotify', // Task name
                  frequency:
                      const Duration(seconds: 5), // Check every 15 minutes
                  inputData: {'symbol': _currentSymbol.text},
                );
                setState(() {
                  minPrice = data.price;
                  maxPrice = data.price;
                  Timer.periodic(const Duration(seconds: 5), (Timer timer) {
                    _updatePrice();
                  });
                });
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal.shade800,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Update Price',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
