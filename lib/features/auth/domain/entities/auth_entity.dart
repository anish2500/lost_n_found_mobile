import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String? authId;
  final String fullName;
  final String email;
  final String phone;
  final String countryCode;
  final String batchId;
  final String? password;
  final String? profilePicture;

  const AuthEntity({
    this.authId,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.countryCode,
    required this.batchId,
    this.password,
    this.profilePicture,
  });

  @override
  List<Object?> get props => [
    authId,
    fullName,
    email,
    phone,
    countryCode,
    batchId,
    password,
    profilePicture,
  ];


}