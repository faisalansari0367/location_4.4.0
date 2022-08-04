class Endpoints {
  static const String signUp = '/auth/signup',
      verifyOtp = '/auth/verify',
      users = '/users',
      signIn = '/auth/signin';
  static String user(int id) => '/user/$id';
}
