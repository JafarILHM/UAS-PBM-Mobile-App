import 'category_model.dart';
import 'unit_model.dart';

class Item {
  final int id;
  final String sku;
  final String name;
  final int stock;
  final int? stockMinimum; // Bisa null
  final int categoryId;
  final int unitId;
  
  // Objek Relasi (untuk ditampilkan di List)
  final Category? category;
  final Unit? unit;

  Item({
    required this.id,
    required this.sku,
    required this.name,
    required this.stock,
    this.stockMinimum,
    required this.categoryId,
    required this.unitId,
    this.category,
    this.unit,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      sku: json['sku'],
      name: json['name'],
      stock: json['stock'],
      stockMinimum: json['stock_minimum'],
      categoryId: int.parse(json['category_id'].toString()),
      unitId: int.parse(json['unit_id'].toString()),
      category: json['category'] != null ? Category.fromJson(json['category']) : null,
      unit: json['unit'] != null ? Unit.fromJson(json['unit']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sku': sku,
      'name': name,
      'stock': stock,
      'stock_minimum': stockMinimum,
      'category_id': categoryId,
      'unit_id': unitId,
    };
  }
}