import 'dart:async';
import 'package:bloc/bloc.dart';
import '../../bloc/authentication_bloc.dart';
import '../../repository/user_repository.dart';
import 'package:equatable/equatable.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository;
  final AuthenticationBloc authenticationBloc;

  LoginBloc({
    required this.userRepository,
    required this.authenticationBloc,
  }) : super(LoginInitial()) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
  }

  Future<void> _onLoginButtonPressed(
      LoginButtonPressed event, Emitter<LoginState> emit) async {
    emit(LoginInitial());
    print('Login button pressed now authenticating');
    try {
      final user = await userRepository.authenticate(
        username: event.username,
        password: event.password,
      );
      authenticationBloc.add(LoggedIn(user: user));
      emit(LoginInitial());
    } catch (error) {
      emit(LoginFailure(error: error.toString()));
    }
  }
}
