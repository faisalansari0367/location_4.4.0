class Endpoints {
  /// Base url for the api
  static const baseUrl = 'http://13.55.174.146:3000';

  static const records = '/records';
  static const users = '/users';
  static const auth = '/auth';
  static const functions = '/functions';

  static const String signUp = '$auth/signup',
      verifyOtp = '$auth/verify',
      forgotPassword = '$auth/forgot-password',
      resetPassword = '$auth/reset-password',
      signIn = '$auth/signin',

      /// records
      getRoles = '$records/roles',
      userSpecies = '$records/species',
      licenceCategories = '$records/licenceCategories',
      fieldsRecords = '$records/fieldsRecord',
      forms = '$records/forms',
      roles = '$records/roles',
      deleteUser = '$users/me',

      // users
      getFields = '$users/fields',
      updateMe = '$users/me',
      // updateUser = '$users/users',
      usersForms = '$users/forms',
      exportLogRecords = '$users/export-log-records';

  // log records
  static const logRecords = '/log-records';
  static const markExit = '$logRecords/mark-exit';

  static const qrCode = '$functions/qrcode';
  static const sendEmergencyNotification = '$functions/send-emergency-notification';
  static const getSentNotifications = '$functions/getNotificationRecord';
  static const sendSos = '$functions/send-sos';

  // static String user(int id) => '/user/$id';
}
