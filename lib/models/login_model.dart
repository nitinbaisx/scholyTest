class LoginModel {
  bool? success;
  String? message;
  UserData? data;

  LoginModel({this.success, this.message, this.data});

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      success: json["success"],
      message: json["message"],
      data: json["data"] != null
          ? UserData.fromJson(json["data"])
          : null,
    );
  }
}

class UserData {
  int? id;
  String? name;
  String? email;
  String? token;

  UserData({this.id, this.name, this.email, this.token});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      token: json["token"],
    );
  }
}
