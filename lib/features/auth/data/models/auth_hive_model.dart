import 'package:hive/hive.dart';
import 'package:lost_n_found/core/constants/hive_table_constant.dart';
import 'package:lost_n_found/features/auth/domain/entities/auth_entity.dart';
import 'package:uuid/uuid.dart';

part 'auth_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.authTypeId)
class AuthHiveModel extends HiveObject {
  @HiveField(0)
  final String? authId;

  @HiveField(1)
  final String fullName;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String phone;

  @HiveField(4)
  final String countryCode;

  @HiveField(5)
  final String batchId;

  @HiveField(6)
  final String? password;

  @HiveField(7)
  final String? profilePicture;

  AuthHiveModel({
    String? authId,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.countryCode,
    required this.batchId,
    this.password,
    this.profilePicture,
  }) : authId = authId ?? Uuid().v4();

  // From Entity
  factory AuthHiveModel.fromEntity(AuthEntity entity) {
    return AuthHiveModel(
      authId: entity.authId,
      fullName: entity.fullName,
      email: entity.email,
      phone: entity.phone,
      countryCode: entity.countryCode,
      batchId: entity.batchId,
      password: entity.password,
      profilePicture: entity.profilePicture,
    );
  }

  // To Entity
  AuthEntity toEntity() {
    return AuthEntity(
      authId: authId,
      fullName: fullName,
      email: email,
      phone: phone,
      countryCode: countryCode,
      batchId: batchId,
      password: password,
      profilePicture: profilePicture,
    );
  }

  // To Entity List
  static List<AuthEntity> toEntityList(List<AuthHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}