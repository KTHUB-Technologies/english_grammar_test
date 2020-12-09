class Constants {
  static const String REGEX_PHONE_NUMBER =
      '^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*\$';
  static const int BOTTOM_TAB_PAGE_COUNT = 4;
  static const int HOME_PAGE = 0;
  static const int SERVICE_PAGE = 1;
  static const int PRODUCT_PAGE = 2;
  static const int ACCOUNT_PAGE = 3;
  /// AppStore and PlayStore
  static const APP_STORE_URL =
      'https://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftwareUpdate?id=YOUR-APP-ID&mt=8';
  static const PLAY_STORE_URL =
      'https://play.google.com/store/apps/details?id=dev.kthub.tocviet_manager';
  ///Member class
  static const int NEW_MEMBER = 0;
  static const int SILVER = 10000000;
  static const int GOLD = 20000000;
  static const int RUBY = 40000000;
  static const int DIAMOND = 60000000;
  static const int KEEP_RANK = 80000000;

  ///Firestore
  static const String USER_COLLECTION = 'USERS';
  static const String NEWS_COLLECTION = 'NEWS_VERSION_2';
  static const String ITEMS_COLLECTION = 'ITEMS';
  static const String SERVICES_COLLECTION = 'SERVICES';
  static const String PRODUCTS_COLLECTION = 'PRODUCTS';
  static const String PREPAID_COLLECTION = 'PREPAID';
  static const String ANDROID_NOTIFY = 'ANDROID_NOTIFY';
  static const String IOS_NOTIFY = 'IOS_NOTIFY';
  static const String SALON_COLLECTION = 'SALON_COLLECTION';
  static const String BOOKINGS_COLLECTION = 'BOOKING';
  static const String HISTORIES_COLLECTION = 'HISTORIES';
  static const String SERVICES = 'SERVICES';
  static const String PRODUCTS = 'PRODUCT';
  static const String REFERRAL = 'REFERRAL';
  static const String CN_LQD = 'CN_LQD';
  static const String CN_HHT = 'CN_HHT';
  static const String HOT_IMAGES_COLLECTION = 'HOT_IMAGES';


  ///Params
  static const String UID = 'uid';
  static const String USERSTORE = 'userStore';
  static const String PHONE_NUMBER = 'PHONE';
}
