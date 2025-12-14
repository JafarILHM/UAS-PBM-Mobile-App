class Unit {
  final int id;
  final String name;
  final String symbol;

  Unit({
    required this.id, 
    required this.name, 
    required this.symbol
  });

  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
      id: json['id'],
      name: json['name'],
      symbol: json['symbol'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'symbol': symbol,
    };
  }
}