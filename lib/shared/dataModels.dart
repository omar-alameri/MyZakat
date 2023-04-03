
class Money {
  final int? id;
  final int userId;
  final DateTime date;
  final double amount;
  final String currency;

  const Money({
    this.id,
    required this.userId,
    required this.date,
    required this.amount,
    required this.currency,
  });
  factory Money.fromMap(Map<String, dynamic> json) =>  Money(
    id: json['id'],
    amount: json['amount'],
    currency: json['currency'],
    userId: json['userId'],
    date: DateTime.parse(json['date']),
  );
  // Convert a Money into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'currency': currency,
      'userID': userId,
      'date': date.toIso8601String(),
    };
  }

  // Implement toString to make it easier to see information

  @override
  String toString() {
    return 'Money{id: $id, userID: $userId, date: $date amount: $amount, currency: $currency}';
  }
}

class Gold {
  final int? id;
  final int userId;
  final DateTime date;
  final double amount;
  final String unit;

  const Gold({
    this.id,
    required this.userId,
    required this.date,
    required this.amount,
    required this.unit,
  });
  factory Gold.fromMap(Map<String, dynamic> json) =>  Gold(
    id: json['id'],
    amount: json['amount'],
    unit: json['unit'],
    userId: json['userId'],
    date: DateTime.parse(json['date']),
  );
  // Convert a Gold into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'unit': unit,
      'userID': userId,
      'date': date.toIso8601String(),
    };
  }

  // Implement toString to make it easier to see information

  @override
  String toString() {
    return 'Gold{id: $id, userID: $userId, date: $date amount: $amount, unit: $unit}';
  }
}
class Silver {
  final int? id;
  final int userId;
  final DateTime date;
  final double amount;
  final String unit;

  const Silver({
    this.id,
    required this.userId,
    required this.date,
    required this.amount,
    required this.unit,
  });
  factory Silver.fromMap(Map<String, dynamic> json) =>  Silver(
    id: json['id'],
    amount: json['amount'],
    unit: json['unit'],
    userId: json['userId'],
    date: DateTime.parse(json['date']),
  );
  // Convert a Silver into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'unit': unit,
      'userID': userId,
      'date': date.toIso8601String(),
    };
  }

  // Implement toString to make it easier to see information

  @override
  String toString() {
    return 'Silver{id: $id, userID: $userId, date: $date amount: $amount, unit: $unit}';
  }
}

class Cattle {
  final int? id;
  final int userId;
  final DateTime date;
  final int amount;
  final String type;

  const Cattle({
    this.id,
    required this.userId,
    required this.date,
    required this.amount,
    required this.type,
  });
  factory Cattle.fromMap(Map<String, dynamic> json) =>  Cattle(
    id: json['id'],
    amount: json['amount'],
    type: json['type'],
    userId: json['userId'],
    date: DateTime.parse(json['date']),
  );
  // Convert a Cattle into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'type': type,
      'userID': userId,
      'date': date.toIso8601String(),
    };
  }

  // Implement toString to make it easier to see information

  @override
  String toString() {
    return 'Cattle{id: $id, userID: $userId, date: $date amount: $amount, type: $type}';
  }
}

class Crops {
  final int? id;
  final int userId;
  final DateTime date;
  final double amount;
  final String type;
  final double price;

  const Crops({
    this.id,
    required this.userId,
    required this.date,
    required this.amount,
    required this.type,
    required this.price,
  });
  factory Crops.fromMap(Map<String, dynamic> json) =>  Crops(
    id: json['id'],
    amount: json['amount'],
    price: json['price'],
    type: json['type'],
    userId: json['userId'],
    date: DateTime.parse(json['date']),
  );
  // Convert a Crops into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'price': price,
      'type': type,
      'userID': userId,
      'date': date.toIso8601String(),
    };
  }
  // Implement toString to make it easier to see information
  @override
  String toString() {
    return 'Crops{id: $id, userID: $userId, date: $date amount: $amount, type: $type, price: $price}';
  }
}
class Stock {
  final int? id;
  final int userId;
  final DateTime date;
  final int amount;
  final String stock;
  final double price;

  const Stock({
    this.id,
    required this.userId,
    required this.date,
    required this.amount,
    required this.stock,
    required this.price,
  });
  factory Stock.fromMap(Map<String, dynamic> json) =>  Stock(
    id: json['id'],
    amount: json['amount'],
    price: json['price'],
    stock: json['stock'],
    userId: json['userId'],
    date: DateTime.parse(json['date']),
  );
  // Convert a Crops into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'price': price,
      'stock': stock,
      'userID': userId,
      'date': date.toIso8601String(),
    };
  }
  // Implement toString to make it easier to see information
  @override
  String toString() {
    return 'Stock{id: $id, userID: $userId, date: $date amount: $amount, stock: $stock, price: $price}';
  }
}