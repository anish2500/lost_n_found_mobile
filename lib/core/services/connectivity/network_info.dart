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
    //check wifi or mobile data is on
    final result = await _connectivity
        .checkConnectivity(); //check garney kaam esle garxa wifi ki mobile data bhanera
    if (result.contains(ConnectivityResult.none)) {
      return false;
    }
    // return await _isInternetReallyAvailable();//decides to return true or false 
    return true;
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
