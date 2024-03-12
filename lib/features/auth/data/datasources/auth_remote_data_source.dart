import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Future<UserModel> signUpwithEmailPassword(
      {required String name, required String email, required String password});
  Future<UserModel> loginwithEmailPassword(
      {required String email, required String password});
}

class AuthRemoteDataSourceImp implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImp(this.supabaseClient);
  @override
  Future<UserModel> loginwithEmailPassword(
      {required String email, required String password}) async {
    try {
      final response = await supabaseClient.auth
          .signInWithPassword(password: password, email: email);
      if (response.user == null) {
        throw ServerException('User is null');
      }
      print(response.user!.id);
      return UserModel.fromJson(response.user!.toJson());
    } catch (e) {
      print(e.toString());
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signUpwithEmailPassword(
      {required String name,
      required String email,
      required String password}) async {
    try {
      final response = await supabaseClient.auth
          .signUp(password: password, email: email, data: {"name": name});
      if (response.user == null) {
        throw ServerException('User is null');
      }
      print(response.user!.id);
      return UserModel.fromJson(response.user!.toJson());
    } catch (e) {
      print(e.toString());
      throw ServerException(e.toString());
    }
  }
}
