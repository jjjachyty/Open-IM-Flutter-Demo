import 'config.dart';

class Urls {
  static var appversion = "${Config.imApiUrl()}/third/get_download_url";
  static var register2 = "${Config.imApiUrl()}/demo/user_register";
  static var rtcToken = "${Config.imApiUrl()}/auth/rtc_token";

  static var login2 = "${Config.imApiUrl()}/demo/user_token";
  static var userLive = "${Config.imApiUrl()}/user/user_live";

  static var userSelfInfo = "${Config.imApiUrl()}/user/get_self_user_info";
  static var importFriends = "${Config.imApiUrl()}/friend/import_friend";
  static var inviteToGroup = "${Config.imApiUrl()}/group/invite_user_to_group";
  static var onlineStatus =
      "${Config.imApiUrl()}/manager/get_users_online_status";
  static var userOnlineStatus =
      "${Config.imApiUrl()}/user/get_users_online_status";
  static var queryAllUsers = "${Config.imApiUrl()}/manager/get_all_users_uid";
  static var updateUserInfo = "${Config.imApiUrl()}/user/update_user_info";
  static var getUsersFullInfo =
      "${Config.appAuthUrl()}/user/get_users_full_info";
  static var searchUserFullInfo =
      "${Config.appAuthUrl()}/user/search_users_full_info";

  /// 登录注册是独立于im的业务
  static var getVerificationCode = "${Config.appAuthUrl()}/account/code";
  static var checkVerificationCode = "${Config.appAuthUrl()}/account/verify";
  static var setPwd = "${Config.appAuthUrl()}/account/password";
  static var resetPwd = "${Config.appAuthUrl()}/account/reset_password";
  static var changePwd = "${Config.appAuthUrl()}/account/change_password";
  static var login = "${Config.appAuthUrl()}/account/login";
  static var upgrade = "${Config.appAuthUrl()}/app/check";

  static final getClientConfig = '${Config.imApiUrl()}/init/get_client_config';
  //直播
  static var startLive = "${Config.imApiUrl()}/live/start";
  static var joinLive = "${Config.imApiUrl()}/live/join";
  static var liveUsers = "${Config.imApiUrl()}/live/users";
}
