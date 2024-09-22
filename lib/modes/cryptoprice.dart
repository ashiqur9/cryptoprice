class Cryptoprice {
  final String symbol;
  final double price;

  const Cryptoprice({required this.symbol, required this.price});

  factory Cryptoprice.fromjson(Map<String, dynamic> json) {
    return Cryptoprice(
        symbol: json['symbol'], price: double.parse(json['price']));
  }
}
