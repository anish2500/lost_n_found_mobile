//internet xa ki xaina check garney

import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract interface class INetworkInfo {
  Future<bool> get isConnected;
}

final networkInfoProvider = Provider<NetworkInfo>((ref) {
  return NetworkInfo(Connectivity());
});

class NetworkInfo implements INetworkInfo {
  final Connectivity _connectivity;

  NetworkInfo(this._connectivity);
  @override
  Future<bool> get isConnected async {
    final hasInternet = await _isInternetReallyAvailable();
    if (hasInternet) {
      return true;
    }

    //check wifi or mobile data is on
    final result = await _connectivity
        .checkConnectivity(); //check garney kaam esle garxa wifi ki mobile data bhanera
    return !result.contains(ConnectivityResult.none);
  }

  //internet xa ki nai check garney

  Future<bool> _isInternetReallyAvailable() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }
}
