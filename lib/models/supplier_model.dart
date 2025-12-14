class Supplier {
  final int id;
  final String name;
  final String? contact; 
  final String? address; 

  Supplier({
    required this.id, 
    required this.name,
    this.contact,
    this.address,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      id: json['id'],
      name: json['name'],
      contact: json['contact'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'contact': contact,
      'address': address,
    };
  }
}