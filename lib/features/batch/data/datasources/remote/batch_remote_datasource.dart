import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/core/api/api_client.dart';
import 'package:lost_n_found/core/api/api_endpoints.dart';
import 'package:lost_n_found/features/batch/data/datasources/batch_datasource.dart';
import 'package:lost_n_found/features/batch/data/models/batch_api_model.dart';
import 'package:lost_n_found/features/batch/data/models/batch_hive_model.dart';

//provider

final batchRemoteProvider = Provider<IBatchRemoteDataSource>((ref) {
  return BatchRemoteDatasource(apiClient: ref.read(apiClientProvider));
});

//api ma depend hunxa yo
class BatchRemoteDatasource implements IBatchRemoteDataSource {
  final ApiClient _apiClient;
  BatchRemoteDatasource({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<bool> createBatch(BatchHiveModel model) async {
    //profesionally you should not implement try catch since it can be done in repository itself
    final response = await _apiClient.post(ApiEndpoints.batches);
    return response.data['success'] == true; 
  }

  @override
  Future<List<BatchApiModel>> getAllBatches() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.batches);
      final data = response.data['data'] as List;
      return data.map((json) => BatchApiModel.fromJson(json)).toList();
    } catch (e) {
      // Re-throw to let repository handle fallback
      throw Exception('API call failed: $e');
    }
  }

  @override
  Future<BatchApiModel?> getBatchById(String batchId) {
    // TODO: implement getBatchById
    throw UnimplementedError();
  }

  @override
  Future<bool> updateBatch(BatchApiModel model) {
    // TODO: implement updateBatch
    throw UnimplementedError();
  }
}
