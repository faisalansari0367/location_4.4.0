class Endpoints {
  /// Base url for the api
  static const baseUrl = 'http://13.55.174.146:3000';

  static const records = '/records';
  static const users = '/users';
  static const auth = '/auth';
  static const functions = '/functions';

  static const cvdFormUrl =
      'https://uniquetowinggoa.com/safemeat/public/api/declaration';

  static const String geofences = '/geofences';
  static const String delegation = '$geofences/delegation';
  static const String removeDelegation = '$geofences/removeDelegation';
  static String geofence(String? id) => '/geofences/$id';
  static const String notifyProperyManager = '$users/notify-property-manager';

  static const payment = '/payment', createSession = '$payment/create-session';
  static const String createPortal = '$payment/create-portal-session';
  static const planDetails = '/default';

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
      getForms = '$records/getForm',
      roles = '$records/roles',
      deleteUser = '$users/me',
      deleteUserById = users,

      // users
      getFields = '$users/fields',
      updateMe = '$users/me',
      createCvd = '$users/createCvd',
      cvd = '$users/cvd',
      // updateUser = '$users/users',
      usersForms = '$users/forms',
      exportLogRecords = '$users/export-log-records';

  // log records
  static const logRecords = '/log-records';
  static const markExit = '$logRecords/mark-exit';
  static const logRecordsOffline = '$logRecords/offline';

  static const qrCode = '$functions/qrcode';
  static const sendEmergencyNotification =
      '$functions/send-emergency-notification';
  static const getSentNotifications = '$functions/getNotificationRecord';
  static const sendSos = '$functions/send-sos';
  static const getSosRecord = '$functions/getSosRecord';

  // static String user(int id) => '/user/$id';
}
