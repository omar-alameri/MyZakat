
class Money {
  final int? id;
  final String userEmail;
  final DateTime date;
  final double amount;
  final String currency;

  const Money({
    this.id,
    required this.userEmail,
    required this.date,
    required this.amount,
    required this.currency,
  });
  factory Money.fromMap(Map<String, dynamic> json) =>  Money(
    id: json['id'],
    amount: json['amount'],
    currency: json['currency'],
    userEmail: json['userEmail'],
    date: DateTime.parse(json['date']),
  );
  // Convert a Money into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'currency': currency,
      'userEmail': userEmail,
      'date': date.toIso8601String(),
    };
  }

  // Implement toString to make it easier to see information

  @override
  String toString() {
    return 'Money{id: $id, userEmail: $userEmail, date: $date amount: $amount, currency: $currency}';
  }
}

class Gold {
  final int? id;
  final String userEmail;
  final DateTime date;
  final double amount;
  final String unit;

  const Gold({
    this.id,
    required this.userEmail,
    required this.date,
    required this.amount,
    required this.unit,
  });
  factory Gold.fromMap(Map<String, dynamic> json) =>  Gold(
    id: json['id'],
    amount: json['amount'],
    unit: json['unit'],
    userEmail: json['userEmail'],
    date: DateTime.parse(json['date']),
  );
  // Convert a Gold into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'unit': unit,
      'userEmail': userEmail,
      'date': date.toIso8601String(),
    };
  }

  // Implement toString to make it easier to see information

  @override
  String toString() {
    return 'Gold{id: $id, userEmail: $userEmail, date: $date amount: $amount, unit: $unit}';
  }
}
class Silver {
  final int? id;
  final String userEmail;
  final DateTime date;
  final double amount;
  final String unit;

  const Silver({
    this.id,
    required this.userEmail,
    required this.date,
    required this.amount,
    required this.unit,
  });
  factory Silver.fromMap(Map<String, dynamic> json) =>  Silver(
    id: json['id'],
    amount: json['amount'],
    unit: json['unit'],
    userEmail: json['userEmail'],
    date: DateTime.parse(json['date']),
  );
  // Convert a Silver into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'unit': unit,
      'userEmail': userEmail,
      'date': date.toIso8601String(),
    };
  }

  // Implement toString to make it easier to see information

  @override
  String toString() {
    return 'Silver{id: $id, userEmail: $userEmail, date: $date amount: $amount, unit: $unit}';
  }
}

class Livestock {
  final int? id;
  final String userEmail;
  final DateTime date;
  final int amount;
  final String type;

  const Livestock({
    this.id,
    required this.userEmail,
    required this.date,
    required this.amount,
    required this.type,
  });
  factory Livestock.fromMap(Map<String, dynamic> json) =>  Livestock(
    id: json['id'],
    amount: json['amount'],
    type: json['type'],
    userEmail: json['userEmail'],
    date: DateTime.parse(json['date']),
  );
  // Convert a Livestock into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'type': type,
      'userEmail': userEmail,
      'date': date.toIso8601String(),
    };
  }

  // Implement toString to make it easier to see information

  @override
  String toString() {
    return 'Livestock{id: $id, userEmail: $userEmail, date: $date amount: $amount, type: $type}';
  }
}

class Crops {
  final int? id;
  final String userEmail;
  final DateTime date;
  final double amount;
  final String type;
  final double price;

  const Crops({
    this.id,
    required this.userEmail,
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
    userEmail: json['userEmail'],
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
      'userEmail': userEmail,
      'date': date.toIso8601String(),
    };
  }
  // Implement toString to make it easier to see information
  @override
  String toString() {
    return 'Crops{id: $id, userEmail: $userEmail, date: $date amount: $amount, type: $type, price: $price}';
  }
}
class Stock {
  final int? id;
  final String userEmail;
  final DateTime date;
  final int amount;
  final String stock;
  final double price;

  const Stock({
    this.id,
    required this.userEmail,
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
    userEmail: json['userEmail'],
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
      'userEmail': userEmail,
      'date': date.toIso8601String(),
    };
  }
  // Implement toString to make it easier to see information
  @override
  String toString() {
    return 'Stock{id: $id, userEmail: $userEmail, date: $date amount: $amount, stock: $stock, price: $price}';
  }
}
class Language {
  final int? id;
  final String language;
  final String page;
  final String name;
  final String data;

  const Language({
    this.id,
    required this.language,
    required this.page,
    required this.name,
    required this.data,
  });
  factory Language.fromMap(Map<String, dynamic> json) =>  Language(
    id: json['id'],
    language: json['language'],
    page: json['page'],
    name: json['name'],
    data: json['data'],
  );
  // Convert a Crops into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'language': language,
      'page': page,
      'name': name,
      'data': data,
    };
  }
  // Implement toString to make it easier to see information
  @override
  String toString() {
    return 'Language{id: $id, language: $language, page: $page name: $name, data: $data}';
  }
}