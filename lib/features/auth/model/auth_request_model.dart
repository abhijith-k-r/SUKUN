class AuthRequestModel {
  final String name;
  final String phone;

  AuthRequestModel({required this.name, required this.phone});

  Map<String, dynamic> toJson() {
    return {'name': name, 'phone': phone};
  }
}
