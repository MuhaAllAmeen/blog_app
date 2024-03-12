import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/features/auth/domain/entities/user.dart';
import 'package:fpdart/fpdart.dart';
abstract interface class AuthRepository{
  Future<Either<Failure, User>> signUpwithEmailPassword({required String name, required String email, required String password});
  Future<Either<Failure, User>> loginwithEmailPassword({required String email, required String password}); 
}