import 'package:blog_app/core/common/cubits/app_user_cubit/app_user_cubit.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/core/common/entities/user.dart';
import 'package:blog_app/features/auth/domain/usecases/current_user.dart';
import 'package:blog_app/features/auth/domain/usecases/user_login.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;
  AuthBloc({
    required UserSignUp userSignUp,
    required UserLogin userLogin,
    required CurrentUser currentUser,
    required AppUserCubit appUserCubit,
  })  : _userSignUp = userSignUp,
        _userLogin = userLogin,
        _currentUser = currentUser,
        _appUserCubit = appUserCubit,
        super(AuthInitial()) {
    //so that authloading is emitted on every event first
    on<AuthEvent>(
      (event, emit) {
        emit(AuthLoading());
      },
    );
    on<AuthSignUp>((event, emit) async {
      final response = await _userSignUp(UserSignUpParams(
          email: event.email, password: event.password, name: event.name));
      response.fold((l) => emit(AuthFailure(l.message)),
          (user) => _emitAuthSuccess(user, emit));
    });
    on<AuthLogin>(
      (event, emit) async {
        final response = await _userLogin.call(
            UserLoginParams(email: event.email, password: event.password));
        response.fold((l) => emit(AuthFailure(l.message)),
            (user) => _emitAuthSuccess(user, emit));
      },
    );
    on<AuthIsUserLoggedIn>(
      (event, emit) async {
        final res = await _currentUser(NoParams());
        res.fold((l) => emit(AuthFailure(l.message)),
            (user) => _emitAuthSuccess(user, emit));
      },
    );
  }

  void _emitAuthSuccess(User user, Emitter<AuthState> emit) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user));
  }
}
