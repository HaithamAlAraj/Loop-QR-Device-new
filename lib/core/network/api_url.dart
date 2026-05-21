class ApiUrl {
  static const String baseUrl = 'http://192.168.1.44:8080/api';

  // ====== Auth (regular users) ======
  static const String authLogin = '$baseUrl/auth/login';
  static const String authRefresh = '$baseUrl/auth/refresh';
  static const String logout = '$baseUrl/auth/logout';
  static const String forgotPassword = '$baseUrl/auth/forgot-password';
  static const String resetPassword = '$baseUrl/auth/reset-password';

  // ====== Shop Admin Auth ======
  static const String shopAdminLogin = '$baseUrl/shop-admins/login';
  static const String shopAdminRefresh = '$baseUrl/shop-admins/refresh';

  // ====== Shops ======
  static const String shops = '$baseUrl/shops';

  // ====== Categories ======
  static const String categories = '$baseUrl/categories';

  // ====== Offers ======
  static const String offers = '$baseUrl/offers';

  // ====== Stamps ======
  static const String stamps = '$baseUrl/stamps';
  static const String getActiveShopStamps = '$baseUrl/stamps/active';
  static const String getCompletedStamps = '$baseUrl/stamps/completed';
  static const String scanCollectQr = '$baseUrl/stamps/collection-qr/scan';
  static const String confirmRedemptionQr = '$baseUrl/stamps/redemption-qr/confirm';

  // ====== Users ======
  static const String users = '$baseUrl/users';
  static const String userRegister = '$baseUrl/users/register';
  static const String getLoginUserDetails = '$baseUrl/users/me';
  static const String getUserPointsBalance = '$baseUrl/users/points/balance';
  static const String confirmPointsRedemptionQr =
      '$baseUrl/shop-admins/points/redemption-qr/confirm';
  static const String generatePointsRedemptionQr =
      '$baseUrl/users/points/redemption-qr';
  static const String addPoints = '$baseUrl/users/points';
  static const String updateMyProfile = '$baseUrl/users/me';
  static const String uploadProfileImage = '$baseUrl/users/profile-image';

  // ====== User Stamp Cards ======
  static const String userStampCards = '$baseUrl/users/stamp-cards';

  // ====== Receipts ======
  static const String receiptOcr = '$baseUrl/receipts/ocr';
}
