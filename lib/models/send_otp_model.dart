class SendOtpModel {
  bool? success;
  String? message;
  int? otp;

  SendOtpModel({this.success, this.message, this.otp});

  factory SendOtpModel.fromJson(Map<String, dynamic> json) {
    return SendOtpModel(
      success: json["success"],
      message: json["message"],
      otp: json["data"]?["otp"],
    );
  }
}
