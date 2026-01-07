import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:lost_n_found/core/constants/hive_table_constant.dart';
import 'package:lost_n_found/features/batch/data/models/batch_hive_model.dart';
import 'package:lost_n_found/features/auth/data/models/auth_hive_model.dart';
// import 'package:lost_n_found/features/batch/presentation/view_model/batch_viewmodel.dart';
import 'package:path_provider/path_provider.dart';

//yo step 13 ma garnu parney ho so proper steps haru follow garera matra yo craeate garney ho
final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService();
});

class HiveService {
  // In-memory storage for web platform
  static final Map<String, AuthHiveModel> _webStorage = {};
  
  // initiaize database databae banauney
  Future<void> init() async {
    if (!kIsWeb) {
      final directory = await getApplicationCacheDirectory();
      // C drive ma lost and found ko folder ko path example ma
      //yesma database ko naame constants bhanney ma j xa tehi rakhney ho
      final path = '${directory.path}/${HiveTableConstant.dbName}';
      Hive.init(path);
      _registerAdapter();
      await openBoxes();
      await insertDummybatches(); //dummy data insert
    }
  }

  //step 21 ya auney dummy data insert
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
    // await box.close();
  }

  // reigster adapter// adapter lai register garnu paryo
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

  // Open boxes box lai open garnu paryo first ma
  Future<void> openBoxes() async {
    if (!kIsWeb) {
      await Hive.openBox<BatchHiveModel>(HiveTableConstant.batchTable);
      await Hive.openBox<AuthHiveModel>(HiveTableConstant.authTable);
    }
  }

  // close boxes
  Future<void> close() async {
    await Hive.close();
  }

  //========================BATCH QUERIEST INSERTION==========================//
  //Tes paxi ball queries haru lekhney
  //batch ko box nikalera first ma ani garney

  Box<BatchHiveModel> get _batchBox =>
      Hive.box<BatchHiveModel>(HiveTableConstant.batchTable);

  //create

  Future<BatchHiveModel> createBatch(BatchHiveModel model) async {
    await _batchBox.put(model.batchId, model);
    return model;
  }

  // getallbatch
  List<BatchHiveModel> getAllBatches() {
    return _batchBox.values.toList();
  }

  //update

  Future<void> updateBatch(BatchHiveModel model) async {
    await _batchBox.put(model.batchId, model);
  }

  //delete
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

  //regiseter user ko lagi
  Future<AuthHiveModel> registerUser(AuthHiveModel model) async {
    // Check if email already exists
    if (isEmailExists(model.email)) {
      throw Exception('Email already exists');
    }
    
    if (kIsWeb) {
      // Use in-memory storage for web
      _webStorage[model.authId!] = model;
    } else {
      // Use Hive for mobile/desktop
      await _authBox.put(model.authId, model);
    }
    return model;
  }

  //Login user ko lagi
  Future<AuthHiveModel?> loginUser(String email, String password) async {
    if (kIsWeb) {
      // Use in-memory storage for web
      final users = _webStorage.values.where(
        (user) => user.email == email && user.password == password,
      );
      return users.isNotEmpty ? users.first : null;
    } else {
      // Use Hive for mobile/desktop
      final users = _authBox.values.where(
        (user) => user.email == email && user.password == password,
      );
      if (users.isNotEmpty) {
        return users.first;
      }
      return null;
    }
  }

  //logout ko lagi
  Future<void> logoutUser() async {}

  //get current user
  AuthHiveModel? getCurrentUser(String authId) {
    if (kIsWeb) {
      return _webStorage[authId];
    } else {
      return _authBox.get(authId);
    }
  }

  //isemail exists
  bool isEmailExists(String email) {
    if (kIsWeb) {
      // Use in-memory storage for web
      final users = _webStorage.values.where((user) => user.email == email);
      return users.isNotEmpty;
    } else {
      // Use Hive for mobile/desktop
      final users = _authBox.values.where((user) => user.email == email);
      return users.isNotEmpty;
    }
  }
}
