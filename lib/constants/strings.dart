import 'package:get/get.dart';

class Strings {
// AppName
  static const String appName = 'BIOPLUS';
  static const String appVersion = '1.0.2';

  static const name = 'Name',
      warakirri = 'Warakirri',
      email = 'Email',
      first = 'First',
      last = 'Last',
      password = 'Password',
      confirm = 'Confirm',
      continue_ = 'Continue',
      surname = 'Surname',
      sign = 'Sign',
      records = 'Records',
      declaration = 'Declaration',
      in_ = 'In',
      up = 'Up',
      mobile = 'Mobile',
      submit = 'Submit',
      form = 'Form',
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

      /// Drawer items
      admin = 'Admin',
      home = 'Home',
      map = 'Map',
      settings = 'Settings',
      //
      yes = 'Yes',
      no = 'No',
      ok = 'Ok',
      cancel = 'Cancel',
      terms = 'Terms',
      and = 'And',
      conditions = 'Conditions',
      dashboard = 'Dashboard',
      visitor = 'Visitor',
      log = 'Log',
      privacy = 'Privacy',
      policy = 'Policy',
      book = 'Book',
      geofence = 'Geofence',
      envds = 'eNVD',
      livestock = 'Livestock',
      movement = 'Movement',
      waybill = 'Waybill',
      links = 'Links',
      check = 'Check',
      commodities = 'Commodities';

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
  static String get visitorLogBook => '$visitor $log$book';
  static String get geofences => '${geofence}s';
  static String get visitorCheckIn => '$visitor $check-${in_}s';
  static String get selectCommodities => '$select $commodities';

  // livestock movement declaration
  static String get livestockWaybillDeclaration => '$livestock $waybill $declaration';

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

  static const String deleteGeofenceMsg = 'Are you sure you want to delete this Geofence?';

  // Errors
  // something went wrong
  static String somethingWentWrong = '$something $went $wrong'.capitalizeFirst!;

  static String get privacyPolicy => '$privacy $policy';

  // terms and conditions
  static String get termsAndConditions => '$terms & $conditions';

  // privacy policy message
  static String get privacyPolicyMessage => 'By signing up, you agree to our Terms of Service and Privacy Policy.';

  //
  static String get areYouVisitingBelowPic => 'Are you visiting below PIC?';

  /// dashboard
  static const edecForms = 'eDEC ${form}s';

  static String get cvdForm => 'CVD $form'.toUpperCase();
  static String get cvdForms => 'CVD ${form}s';
}
