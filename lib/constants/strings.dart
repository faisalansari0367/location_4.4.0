import 'package:get/get.dart';

class Strings {
// AppName
  static const String appName = 'iTRAK';

  static const name = 'Name',
      email = 'Email',
      first = 'First',
      last = 'Last',
      password = 'Password',
      confirm = 'Confirm',
      surname = 'Surname',
      sign = 'Sign',
      in_ = 'In',
      up = 'Up',
      mobile = 'Mobile',
      submit = 'Submit',
      role = 'Role',
      select = 'Select',
      details = 'Details',
      your = 'Your',
      pic = 'PIC',
      property = 'Property',
      address = 'Address',
      welcome = 'Welcome',
      to = 'To',
      login = 'Login',
      logout = 'Logout',
      you = 'You',
      are = 'Are',
      a = 'A',
      i = 'I',
      am = 'Am',
      retry = 'Retry',
      forgot = 'Forgot',
      new_ = 'New',
      register = 'Register',
      reset = 'Reset',
      state = 'State',
      postCode = 'Post Code',
      town = 'Town',
      street = 'Street',
      please = 'Please',
      enter = 'Enter',
      the = 'The',
      field = 'Field',
      otp = 'Otp',
      sent = 'Sent',
      verified = 'Verified',
      something = 'Somthing',
      went = 'Went',
      wrong = 'Wrong',
      successfully = 'Successfully',
      home = 'Home',
      map = 'Map',
      settings = 'Settings',
      yes = 'Yes',
      no = 'No',
      ok = 'Ok';

  static String get firstName => '$first $name';
  static String get lastName => '$last $name';
  static String get selectYourRole => '$select $your $role';
  static String get roleDetails => '$role $details';
  static String get yourDetails => '$your $details';
  static String get properyName => '$property $name';
  static String get propertyAddress => '$property $address';
  static String get welcomeTo => '$welcome $to';
  static String get signUp => '$sign $up';
  static String get forgotPassword => '$forgot $password';
  static String get newToItrack => '$new_ $to $appName';
  // confirm password
  static String get confirmPassword => '$confirm $password';

  // select state
  static String get selectState => '$select $state';

  // field name
  static String get fieldNameMsg => '$please $enter $the $field $name'.capitalizeFirst!;

  /// Otp
  static String get otpSentToVerifiedEmail => '$otp $sent $to $your $verified $email'.capitalizeFirst!;

  // otp verified successfully
  static String get otpVerifiedSuccessfully => '$otp $verified $successfully'.capitalizeFirst!;

  // forgot password
  static String get forgotPasswordMessage =>
      "Don't worry! it happens. Please enter the address associated with your account.";

  // Errors
  // something went wrong
  static String somethingWentWrong = '$something $went $wrong'.capitalizeFirst!;

  // privacy policy message
  static String get privacyPolicyMessage => 'By signing up, you agree to our Terms of Service and Privacy Policy.';
}
