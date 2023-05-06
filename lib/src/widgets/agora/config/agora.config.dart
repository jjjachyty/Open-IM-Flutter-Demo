/// Get your own App ID at https://dashboard.agora.io/
String get appId {
  // Allow pass an `appId` as an environment variable with name `TEST_APP_ID` by using --dart-define
  return const String.fromEnvironment('TEST_APP_ID',
      defaultValue: 'b50fc6db8a764cef811ee040cc67b217');
}


/// Your channel ID
// String get channelId {
//   // Allow pass a `channelId` as an environment variable with name `TEST_CHANNEL_ID` by using --dart-define
//   return const String.fromEnvironment(
//     'TEST_CHANNEL_ID',
//     defaultValue: 'meeting',
//   );
// }

/// Your int user ID
// const int uid = 0;

/// Your user ID for the screen sharing
// const int screenSharingUid = 10;

/// Your string user ID
// const String stringUid = '0';

// String get musicCenterAppId {
//   // Allow pass a `token` as an environment variable with name `TEST_TOKEN` by using --dart-define
//   return const String.fromEnvironment('MUSIC_CENTER_APPID',
//       defaultValue: '<MUSIC_CENTER_APPID>');
// }
