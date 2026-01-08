import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:lost_n_found/core/constants/hive_table_constant.dart';
import 'package:lost_n_found/features/batch/data/models/batch_hive_model.dart';
import 'package:lost_n_found/features/auth/data/models/auth_hive_model.dart';
import 'package:path_provider/path_provider.dart';

final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService();
});

class HiveService {
  static final Map<String, AuthHiveModel> _webStorage = {};

  Future<void> init() async {
    if (!kIsWeb) {
      final directory = await getApplicationCacheDirectory();
      final path = '${directory.path}/${HiveTableConstant.dbName}';
      Hive.init(path);
      _registerAdapter();
      await openBoxes();
      await insertDummybatches();
    }
  }

  Future<void> insertDummybatches() async {
    final box = Hive.box<BatchHiveModel>(HiveTableConstant.batchTable);
    if (box.isNotEmpty) return;
    final dummyBatches = [
      BatchHiveModel(batchName: '35A'),
      BatchHiveModel(batchName: '35B'),
      BatchHiveModel(batchName: '35C'),
      BatchHiveModel(batchName: '36B'),
      BatchHiveModel(batchName: '37C'),
    ];
    for (var batch in dummyBatches) {
      await box.put(batch.batchId, batch);
    }
  }

  void _registerAdapter() {
    if (!kIsWeb) {
      if (!Hive.isAdapterRegistered(HiveTableConstant.batchTypeId)) {
        Hive.registerAdapter(BatchHiveModelAdapter());
      }
      if (!Hive.isAdapterRegistered(HiveTableConstant.authTypeId)) {
        Hive.registerAdapter(AuthHiveModelAdapter());
      }
    }
  }

  Future<void> openBoxes() async {
    if (!kIsWeb) {
      await Hive.openBox<BatchHiveModel>(HiveTableConstant.batchTable);
      await Hive.openBox<AuthHiveModel>(HiveTableConstant.authTable);
    }
  }

  Future<void> close() async {
    await Hive.close();
  }

  //========================BATCH QUERIES==========================//

  Box<BatchHiveModel> get _batchBox =>
      Hive.box<BatchHiveModel>(HiveTableConstant.batchTable);

  Future<BatchHiveModel> createBatch(BatchHiveModel model) async {
    await _batchBox.put(model.batchId, model);
    return model;
  }

  List<BatchHiveModel> getAllBatches() {
    return _batchBox.values.toList();
  }

  Future<void> updateBatch(BatchHiveModel model) async {
    await _batchBox.put(model.batchId, model);
  }

  Future<void> deleteBatch(String batchId) async {
    await _batchBox.delete(batchId);
  }

  //========================AUTH QUERIES==========================//

  Box<AuthHiveModel> get _authBox {
    if (kIsWeb) {
      throw UnsupportedError('Hive box not available on web');
    }
    return Hive.box<AuthHiveModel>(HiveTableConstant.authTable);
  }

  Future<AuthHiveModel> registerUser(AuthHiveModel model) async {
    if (isEmailExists(model.email)) {
      throw Exception('Email already exists');
    }

    if (kIsWeb) {
      _webStorage[model.authId!] = model;
    } else {
      await _authBox.put(model.authId, model);
    }
    return model;
  }

  Future<AuthHiveModel?> loginUser(String email, String password) async {
    if (kIsWeb) {
      final users = _webStorage.values.where(
        (user) => user.email == email && user.password == password,
      );
      return users.isNotEmpty ? users.first : null;
    } else {
      final users = _authBox.values.where(
        (user) => user.email == email && user.password == password,
      );
      return users.isNotEmpty ? users.first : null;
    }
  }

  // NEW: Get User by ID
  AuthHiveModel? getUserById(String authId) {
    if (kIsWeb) {
      return _webStorage[authId];
    } else {
      return _authBox.get(authId);
    }
  }

  // NEW: Get User by Email
  AuthHiveModel? getUserByEmail(String email) {
    if (kIsWeb) {
      final users = _webStorage.values.where((user) => user.email == email);
      return users.isNotEmpty ? users.first : null;
    } else {
      final users = _authBox.values.where((user) => user.email == email);
      return users.isNotEmpty ? users.first : null;
    }
  }

  // NEW: Update User
  Future<void> updateUser(AuthHiveModel model) async {
    if (kIsWeb) {
      _webStorage[model.authId!] = model;
    } else {
      await _authBox.put(model.authId, model);
    }
  }

  // NEW: Delete User
  Future<void> deleteUser(String authId) async {
    if (kIsWeb) {
      _webStorage.remove(authId);
    } else {
      await _authBox.delete(authId);
    }
  }

  AuthHiveModel? getCurrentUser(String authId) {
    return getUserById(authId);
  }

  bool isEmailExists(String email) {
    if (kIsWeb) {
      return _webStorage.values.any((user) => user.email == email);
    } else {
      return _authBox.values.any((user) => user.email == email);
    }
  }
}