class Endpoints {
  static const String signUp = '/auth/signup',
      verifyOtp = '/auth/verify',
      forgotPassword = '/auth/forgot-password',
      resetPassword = '/auth/reset-password',
      signIn = '/auth/signin',

      /// users
      users = '/users',
      getRoles = '$users/roles',
      getFields = '$users/fields',
      updateUser = '$users/me',
      formQuestions = '$users/forms',
      userSpecies = '$users/species',
      logRecords = '$users/log-records';

  // static String user(int id) => '/user/$id';
}
