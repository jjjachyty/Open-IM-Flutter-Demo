import 'dart:convert';

class LoginCertificate {
  String userID;
  String token; // im的
  // String chatToken; // 业务服务器的

  LoginCertificate.fromJson(Map<String, dynamic> map)
      : userID = map["userID"] ?? '',
        token = map["token"] ?? '';
  // chatToken = map['token'] ?? '';

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['userID'] = userID;
<<<<<<< HEAD:lib/src/models/login_certificate.dart
    data['token'] = token;
    // data['chatToken'] = chatToken;

=======
    data['imToken'] = imToken;
    data['chatToken'] = chatToken;
>>>>>>> 20248c558d5e13fd7fc35a425db26ae62f1cc068:openim_common/lib/src/models/login_certificate.dart
    return data;
  }

  @override
  String toString() {
    return jsonEncode(this);
  }
}
