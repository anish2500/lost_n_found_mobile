import 'package:hive/hive.dart';
import 'package:lost_n_found/core/constants/hive_table_constant.dart';
import 'package:lost_n_found/features/batch/domain/entities/batch_entity.dart';
import 'package:uuid/uuid.dart';

part 'batch_hive_model.g.dart';

//two things in hive
// first box and then
// adapter : binary lai object ma convert
@HiveType(typeId: HiveTableConstant.batchTypeId)
class BatchHiveModel extends HiveObject {
  @HiveField(0)
  final String? batchId;
  @HiveField(1)
  final String batchName;
  @HiveField(2)
  final String? status;

  //constructor
  //34A this is inserted default
  //1, 34A, active // yo ni inserted hunu paryo
  BatchHiveModel({String? batchId, required this.batchName, String? status})
    : batchId = batchId ?? Uuid().v4(),
      status = status ?? 'active';

  //toEntity : tala bata mathi jada : get request
  BatchEntity toEntity() {
    return BatchEntity(
      batchId: batchId,
      batchName: "Chitwan $batchName",
      status: status,
    );
  }

  //from entity
  factory BatchHiveModel.fromEntity(BatchEntity entity) {
    return BatchHiveModel(batchName: entity.batchName);
  }

  // toEnitityList
  static List<BatchEntity> toEntityList(List<BatchHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
