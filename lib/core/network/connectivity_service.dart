import 'dart:io';

class ConnectivityService {
  Future<bool> isConnected() async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 3));
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
      throw Exception('NO INTERNET CONNECTION');
    } catch (e) {
      throw Exception('NO INTERNET CONNECTION');
    }
  }
}
