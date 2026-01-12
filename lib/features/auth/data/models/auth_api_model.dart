import 'package:lost_n_found/features/auth/domain/entities/auth_entity.dart';
import 'package:lost_n_found/features/batch/data/models/batch_api_model.dart';

class AuthApiModel {
  final String? id;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String username;
  final String? batchId;
  final String? password;
  final String? profilePicture;
  final BatchApiModel? batch;

  AuthApiModel({
    this.id,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    required this.username,
    this.batchId,
    this.password,
    this.profilePicture,
    this.batch,
  });

  // toJson: Matches your database/API keys
  Map<String, dynamic> toJson() {
    return {
      "name": fullName,
      "email": email,
      "phoneNumber": phoneNumber,
      "username": username,
      "password": password,
      "batchId": batchId,
      "profilePicture": profilePicture,
    };
  }

  // fromJson: Maps API response to the Model
  factory AuthApiModel.fromJson(Map<String, dynamic> json) {
    return AuthApiModel(
      id: json['_id'] as String? ?? json['id'] as String?,
      fullName: (json['fullName'] ?? json['name'] ?? '') as String,
      email: (json['email'] ?? '') as String,
      phoneNumber: json['phoneNumber'] as String?,
      username: (json['username'] ?? '') as String,
      password: json['password'] as String?,
      batchId: json['batchId'] as String?,
      profilePicture: json['profilePicture'] as String?,
      batch: json['batch'] != null
          ? BatchApiModel.fromJson(json['batch'] as Map<String, dynamic>)
          : null,
    );
  }

  // toEntity: Converts Model to Domain Layer Entity
  AuthEntity toEntity() {
    return AuthEntity(
      authId: id,
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      username: username,
      batchId: batchId,
      password: password,
      profilePicture: profilePicture,
      batch: batch?.toEntity(),
    );
  }

  // fromEntity: Converts Domain Layer Entity to Model
  factory AuthApiModel.fromEntity(AuthEntity entity) {
    return AuthApiModel(
      // id: entity.authId,
      fullName: entity.fullName,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      username: entity.username,
      batchId: entity.batchId,
      password: entity.password,
      profilePicture: entity.profilePicture,
      batch: entity.batch != null
          ? BatchApiModel.fromEntity(entity.batch!)
          : null,
    );
  }

  //to Entity list
  static List<AuthEntity> toEntityList(List<AuthApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
