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
    data['token'] = token;
    // data['chatToken'] = chatToken;

    return data;
  }
}
