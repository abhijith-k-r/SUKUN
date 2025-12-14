class UsreModel {
  final String id;
  final String name;
  final String phone;

  UsreModel({required this.name, required this.phone, required this.id});

  factory UsreModel.fromJson(Map<String, dynamic> map) {
    return UsreModel(id: map['id'], name: map['name'], phone: map['phone']);
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'phone': phone};
  }
}
