class Endpoints {
  static const records = '/records';
  static const users = '/users';
  static const auth = '/auth';

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

      // users
      getFields = '$users/fields',
      updateUser = '$users/me',
      usersForms = '$users/forms',
      exportLogRecords = '$users/export-log-records';

  // log records
  static const logRecords = '/log-records';

  // static String user(int id) => '/user/$id';
}
