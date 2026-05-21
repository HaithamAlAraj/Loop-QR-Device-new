import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'api_url.dart';
import '../services/auth_storage.dart';

class ApiService {
  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<Map<String, String>> get _headers async => {
        'Content-Type': 'application/json',
        if (await AuthStorage.getAccessToken() != null)
          'Authorization': 'Bearer ${await AuthStorage.getAccessToken()}',
      };

  Future<http.Response> _request(Future<http.Response> Function() call) {
    return call().timeout(const Duration(seconds: 10));
  }

  Future<Map<String, dynamic>> shopAdminLogin(
    String email,
    String password,
  ) async {
    final response = await _request(() async => _client.post(
          Uri.parse(ApiUrl.shopAdminLogin),
          headers: await _headers,
          body: jsonEncode({'email': email, 'password': password}),
        ));
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> shopAdminRefresh(String refreshToken) async {
    final response = await _request(() async => _client.post(
          Uri.parse(ApiUrl.shopAdminRefresh),
          headers: await _headers,
          body: jsonEncode({'refreshToken': refreshToken}),
        ));
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> logout() async {
    final response = await _request(() async => _client.post(
          Uri.parse(ApiUrl.logout),
          headers: await _headers,
        ));
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getActiveShopStamps() async {
    final response = await _request(() async => _client.get(
          Uri.parse(ApiUrl.getActiveShopStamps),
          headers: await _headers,
        ));
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> generateCollectQr(
    String stampId,
    int stampsCount,
  ) async {
    final response = await _request(() async => _client.post(
          Uri.parse(
            '${ApiUrl.stamps}/$stampId/collection-qr',
          ).replace(queryParameters: {'stampsCount': stampsCount.toString()}),
          headers: await _headers,
        ));
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> scanCollectQr(String qrId) async {
    final response = await _request(() async => _client.post(
          Uri.parse(ApiUrl.scanCollectQr),
          headers: await _headers,
          body: jsonEncode({'qrId': qrId}),
        ));
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> generateRedemptionQr(String stampId) async {
    final response = await _request(() async => _client.post(
          Uri.parse('${ApiUrl.stamps}/$stampId/redemption-qr'),
          headers: await _headers,
        ));
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> confirmRedemptionQr(String qrId) async {
    final response = await _request(() async => _client.post(
          Uri.parse(ApiUrl.confirmRedemptionQr),
          headers: await _headers,
          body: jsonEncode({'qrId': qrId}),
        ));
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> confirmPointsRedemptionQr(String qrId) async {
    final response = await _request(() async => _client.post(
          Uri.parse(ApiUrl.confirmPointsRedemptionQr),
          headers: await _headers,
          body: jsonEncode({'qrId': qrId}),
        ));
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> generatePointsRedemptionQr(
    int pointsToRedeem,
  ) async {
    final response = await _request(() async => _client.post(
          Uri.parse(ApiUrl.generatePointsRedemptionQr),
          headers: await _headers,
          body: jsonEncode({'pointsToRedeem': pointsToRedeem}),
        ));
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getUserStampCards() async {
    final response = await _request(() async => _client.get(
          Uri.parse(ApiUrl.userStampCards),
          headers: await _headers,
        ));
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> addPoints(int amount) async {
    final response = await _request(() async => _client.post(
          Uri.parse(ApiUrl.addPoints),
          headers: await _headers,
          body: jsonEncode({'amount': amount}),
        ));
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _request(() async => _client.post(
          Uri.parse(ApiUrl.authLogin),
          headers: await _headers,
          body: jsonEncode({'email': email, 'password': password}),
        ));
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    final response = await _request(() async => _client.post(
          Uri.parse(ApiUrl.authRefresh),
          headers: await _headers,
          body: jsonEncode({'refreshToken': refreshToken}),
        ));
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> forgotPassword(String email) async {
    final response = await _request(() async => _client.post(
          Uri.parse(ApiUrl.forgotPassword),
          headers: await _headers,
          body: jsonEncode({'email': email}),
        ));
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> resetPassword(
    String email,
    String resetToken,
    String newPassword,
  ) async {
    final response = await _request(() async => _client.post(
          Uri.parse(ApiUrl.resetPassword),
          headers: await _headers,
          body: jsonEncode({
            'email': email,
            'resetToken': resetToken,
            'newPassword': newPassword,
          }),
        ));
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> register(
    String email,
    String firstName,
    String lastName,
    String phone,
    String gender,
    String password,
  ) async {
    final response = await _request(() async => _client.post(
          Uri.parse(ApiUrl.userRegister),
          headers: await _headers,
          body: jsonEncode({
            'email': email,
            'firstName': firstName,
            'lastName': lastName,
            'phone': phone,
            'gender': gender,
            'password': password,
          }),
        ));
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getUserById(String id) async {
    final response = await _request(() async => _client.get(
          Uri.parse('${ApiUrl.users}/$id'),
          headers: await _headers,
        ));
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getLoginUserDetails() async {
    final response = await _request(() async => _client.get(
          Uri.parse(ApiUrl.getLoginUserDetails),
          headers: await _headers,
        ));
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getUserPointsBalance(String mallId) async {
    final response = await _request(() async => _client.get(
          Uri.parse(ApiUrl.getUserPointsBalance)
              .replace(queryParameters: {'mallId': mallId}),
          headers: await _headers,
        ));
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> updateMyProfile(
    Map<String, dynamic> data,
  ) async {
    final response = await _request(() async => _client.put(
          Uri.parse(ApiUrl.updateMyProfile),
          headers: await _headers,
          body: jsonEncode(data),
        ));
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> uploadProfileImage(String filePath) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(ApiUrl.uploadProfileImage),
    );
    final token = await AuthStorage.getAccessToken();
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }
    request.files.add(await http.MultipartFile.fromPath('ImageFile', filePath));
    final streamed = await _client.send(request).timeout(
          const Duration(seconds: 10),
        );
    final response = await http.Response.fromStream(streamed);
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getShops(
    String mallId, {
    String? categoryId,
    String? searchTerm,
  }) async {
    final queryParams = <String, String>{};
    if (categoryId != null) queryParams['categoryId'] = categoryId;
    if (searchTerm != null) queryParams['searchTerm'] = searchTerm;
    final uri = Uri.parse(ApiUrl.shops).replace(queryParameters: queryParams);
    final response = await _request(() async => _client.get(
          uri,
          headers: {
            ...await _headers,
            'X-Mall-Id': mallId,
          },
        ));
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getShopById(
    String mallId,
    String shopId,
  ) async {
    final response = await _request(() async => _client.get(
          Uri.parse('${ApiUrl.shops}/$shopId'),
          headers: {
            ...await _headers,
            'X-Mall-Id': mallId,
          },
        ));
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getCategories(String mallId) async {
    final response = await _request(() async => _client.get(
          Uri.parse(ApiUrl.categories)
              .replace(queryParameters: {'mallId': mallId}),
          headers: await _headers,
        ));
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getOffers(String mallId) async {
    final response = await _request(() async => _client.get(
          Uri.parse(ApiUrl.offers).replace(queryParameters: {'mallId': mallId}),
          headers: await _headers,
        ));
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getOffersByShop(
    String mallId,
    String shopId,
  ) async {
    final response = await _request(() async => _client.get(
          Uri.parse('${ApiUrl.offers}/$mallId/$shopId'),
          headers: await _headers,
        ));
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getStamps(
    String mallId,
    String shopId,
  ) async {
    final response = await _request(() async => _client.get(
          Uri.parse(ApiUrl.stamps).replace(queryParameters: {
            'mallId': mallId,
            'shopId': shopId,
          }),
          headers: await _headers,
        ));
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getCompletedStamps() async {
    final response = await _request(() async => _client.get(
          Uri.parse(ApiUrl.getCompletedStamps),
          headers: await _headers,
        ));
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> scanReceiptOcr(
    String mallId,
    String filePath,
  ) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(ApiUrl.receiptOcr),
    );
    final token = await AuthStorage.getAccessToken();
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }
    request.headers['X-Mall-Id'] = mallId;
    request.files.add(await http.MultipartFile.fromPath(
      'file',
      filePath,
      contentType: MediaType('image', 'jpeg'),
    ));
    final streamed = await _client.send(request).timeout(
          const Duration(seconds: 10),
        );
    final response = await http.Response.fromStream(streamed);
    return _handleResponse(response);
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return {'success': true, 'data': null};
      }
      return {'success': true, 'data': jsonDecode(response.body)};
    }
    if (response.body.isEmpty) {
      return {
        'success': false,
        'error': 'Request failed with status ${response.statusCode}'
      };
    }
    return {'success': false, 'error': jsonDecode(response.body)};
  }

  void dispose() => _client.close();
}
