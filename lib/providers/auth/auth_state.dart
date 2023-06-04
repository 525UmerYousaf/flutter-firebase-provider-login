// ignore_for_file: public_member_api_docs, sort_constructors_first
//  Inisde "AuthState" I required an info about Firebase Auth.
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

//  As size of app grows it's better to have state & class inside
//  seperate files. The "AuthStatus" is used to display authentication
//   status.
enum AuthStatus {
  //  It will be null indicating status before authentication is decieded.
  //  For Example; when app first starts or rebooting.
  unknown,
  //  It will indicate the status when user has successfully login into app.
  authenticated,
  unauthenticated,
}

//  Below is class to store User Authentication State.
class AuthState extends Equatable {
  final AuthStatus authStatus;
  final fb_auth.User? user;
  const AuthState({
    required this.authStatus,
    this.user,
  });

  //  Below constructor will be used as initial state
  factory AuthState.unknown() {
    return const AuthState(authStatus: AuthStatus.unknown);
  }

  @override
  List<Object?> get props => [authStatus, user];
  //  Aobe is of type nullable because my member variable
  //  is of type nullable.

  @override
  bool get stringify => true;

  AuthState copyWith({
    AuthStatus? authStatus,
    fb_auth.User? user,
  }) {
    return AuthState(
      authStatus: authStatus ?? this.authStatus,
      user: user ?? this.user,
    );
  }
}
