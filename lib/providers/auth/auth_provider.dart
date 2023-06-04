// ignore_for_file: public_member_api_docs, sort_constructors_first, avoid_print
//  The core role of this file is to read "user" stream and check whether
//  the user status value is null and whenever the value changes & based
//  on that value it would generate the "authenticated" & "unauthenticated"
//  state.
import 'package:flutter/material.dart';
//  Since, I required an instance of Firebase Auth here.
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

import '../../repositories/auth_repository.dart';
import './auth_state.dart';

//  Sicne "AuthProvider" needs to notify listener whenever the
//  authentication state changes I'll mixin it with "ChangeNotifier".
class AuthProvider with ChangeNotifier {
  //  First, I'll create an state that will be managed
  //  by the "AuthProvider".
  AuthState _state = AuthState.unknown();
  //  Below is state getter used to get state from outside
  AuthState get state => _state;
  //  The Signout request will also be handled by AuthProvider
  //  bcz it's not be appropriate to handle signout by same
  //  provider that handle signin and signup.
  //  Since signout is defined inside "AuthRepository" I required
  //  an instance of "AuthRepository".
  final AuthRepository authRepository;
  AuthProvider({
    required this.authRepository,
  });
  //  "AuthProvider" listent to "user(getter)" of "AuthRepository"
  //  & informs the listeners of the "authenticated" & "unauthenticated"
  //  states whenever the user value changes. Therefore; "AuthProvider"
  //  should be in form of "ProxyProvider" that depends on StreamProvider
  //  to generate a new value whenever value of user(getter) stream changes.
  //  "AuthProvider" must be "ChangeNotifierProxyProvider" bcz it has to notify
  //  the listeners whenever the state changes. In my case value provided by
  //  "StreamProvider" is "user(getter)" stored in "AuthRepository". So,
  //  "authProvider" must be updated whenever user state changes.
  void update(fb_auth.User? user) {
    if (user != null) {
      //  Meaning the user is authenticated.
      _state =
          _state.copyWith(authStatus: AuthStatus.authenticated, user: user);
    } else {
      _state = _state.copyWith(authStatus: AuthStatus.unauthenticated);
    }
    print('authState: $_state');
    notifyListeners();
  }

  //  When user signout user (stream) will be updated, so "AuthRepository"
  //  function 'update' is called again to change the state & notify listeners.
  void signout() async {
    await authRepository.signOut();
  }
}
