import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/core/services/connectivity/network_info.dart';
import 'package:lost_n_found/features/item/data/datasources/item_datasource.dart';
import 'package:lost_n_found/features/item/data/datasources/local/item_local_datasource.dart';
import 'package:lost_n_found/features/item/data/datasources/remote/item_remote_datasource.dart';
import 'package:lost_n_found/features/item/data/models/item_api_model.dart';
import 'package:lost_n_found/features/item/data/models/item_hive_model.dart';
import 'package:lost_n_found/features/item/domain/entities/item_entity.dart';
import 'package:lost_n_found/features/item/domain/repositories/item_repository.dart';

final itemRepositoryProvider = Provider<IItemRepository>((ref) {
  final localDatasource = ref.read(itemLocalDatasourceProvider);
  final itemRemoteDatasource = ref.read(itemRemoteDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return ItemRepository(
    localDatasource: localDatasource,
    itemRemoteDatasource: itemRemoteDatasource,
    networkInfo: networkInfo,
  );
});

class ItemRepository implements IItemRepository {
  final IItemLocalDataSource _localDataSource;
  final IItemRemoteDataSource _itemRemoteDataSource;
  final NetworkInfo _networkInfo;

  ItemRepository({
    required IItemLocalDataSource localDatasource,
    required IItemRemoteDataSource itemRemoteDatasource,
    required NetworkInfo networkInfo,
  }) : _localDataSource = localDatasource,
       _itemRemoteDataSource = itemRemoteDatasource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, bool>> createItem(ItemEntity item) async {
    if (await _networkInfo.isConnected) {
      try {
        final itemApiModel = ItemApiModel.fromEntity(item);
        await _itemRemoteDataSource.createItem(itemApiModel);
        return const Right(true);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(ApiFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteItem(String itemId) async {
    if (await _networkInfo.isConnected) {
      try {
        await _itemRemoteDataSource.deleteItem(itemId);
        return const Right(true);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final result = await _localDataSource.deleteItem(itemId);
        if (result) {
          return const Right(true);
        }
        return const Left(
          LocalDatabaseFailure(message: "Failed to delete item"),
        );
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<ItemEntity>>> getAllItems() async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _itemRemoteDataSource.getAllItems();
        final entities = ItemApiModel.toEntityList(models);
        return Right(entities);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final models = await _localDataSource.getAllItems();
        final entities = ItemHiveModel.toEntityList(models);
        return Right(entities);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, ItemEntity>> getItemById(String itemId) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = await _itemRemoteDataSource.getItemById(itemId);
        return Right(model.toEntity());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final model = await _localDataSource.getItemById(itemId);
        if (model != null) {
          return Right(model.toEntity());
        }
        return const Left(LocalDatabaseFailure(message: 'Item not found'));
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<ItemEntity>>> getItemsByUser(
    String userId,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _itemRemoteDataSource.getItemsByUser(userId);
        final entities = ItemApiModel.toEntityList(models);
        return Right(entities);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final models = await _localDataSource.getItemsByUser(userId);
        final entities = ItemHiveModel.toEntityList(models);
        return Right(entities);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<ItemEntity>>> getLostItems() async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _itemRemoteDataSource.getLostItems();
        final entities = ItemApiModel.toEntityList(models);
        return Right(entities);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final models = await _localDataSource.getLostItems();
        final entities = ItemHiveModel.toEntityList(models);
        return Right(entities);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<ItemEntity>>> getFoundItems() async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _itemRemoteDataSource.getFoundItems();
        final entities = ItemApiModel.toEntityList(models);
        return Right(entities);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final models = await _localDataSource.getFoundItems();
        final entities = ItemHiveModel.toEntityList(models);
        return Right(entities);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<ItemEntity>>> getItemsByCategory(
    String categoryId,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _itemRemoteDataSource.getItemsByCategory(categoryId);
        final entities = ItemApiModel.toEntityList(models);
        return Right(entities);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final models = await _localDataSource.getItemsByCategory(categoryId);
        final entities = ItemHiveModel.toEntityList(models);
        return Right(entities);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> updateItem(ItemEntity item) async {
    if (await _networkInfo.isConnected) {
      try {
        final itemApiModel = ItemApiModel.fromEntity(item);
        await _itemRemoteDataSource.updateItem(itemApiModel);
        return const Right(true);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final itemModel = ItemHiveModel.fromEntity(item);
        final result = await _localDataSource.updateItem(itemModel);
        if (result) {
          return const Right(true);
        }
        return const Left(
          LocalDatabaseFailure(message: "Failed to update item"),
        );
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, String>> uploadImage(File image) async {
    //remote ma matrai insert huna paryo 
    if (await _networkInfo.isConnected) {
      try {
        final fileName = await _itemRemoteDataSource.uploadImage(image);
        return Right(fileName);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(ApiFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, String>> uploadVideo(File video) async {
    if (await _networkInfo.isConnected) {
      try {
        final url = await _itemRemoteDataSource.uploadVideo(video);
        return Right(url);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(ApiFailure(message: 'No internet connection'));
    }
  }
}