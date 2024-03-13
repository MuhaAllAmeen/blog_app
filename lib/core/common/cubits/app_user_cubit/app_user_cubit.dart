import 'package:blog_app/core/common/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_user_state.dart';

class AppUserCubit extends Cubit<AppUserState> {
  AppUserCubit() : super(AppUserInitial());

  void updateUser(User? user){
    //when user is null, it means the user has logged out so we need to bring the app to initial state
    // i.e, initial state is the logged out state
    if (user == null){
      emit(AppUserInitial());
    } else{
      emit(AppUserLoggedIn(user: user));
    }
  }
}
