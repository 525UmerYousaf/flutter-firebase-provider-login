import 'package:flutter/material.dart';
//  In this page, I would handle user navigation based on user state of authentication.
import 'package:provider/provider.dart';

import '../providers/auth/auth_provider.dart';
import '../providers/auth/auth_state.dart';
import './signin_page.dart';
import './home_page.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});
  static const String routeName = '/';

  @override
  Widget build(BuildContext context) {
    //  First, I would watch the state of AuthProvider in
    //  "build" function & save value in "authState" named var as.
    final authState = context.watch<AuthProvider>().state;

    //  Since, I'm navigating within "build" method I required
    //  "addPostFrameCallback" function & I schedule it to be
    //  called after current build task is finished.
    if (authState.authStatus == AuthStatus.authenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamed(context, HomePage.routeName);
      });
    } else if (authState.authStatus == AuthStatus.unauthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamed(context, SigninPage.routeName);
      });
    }

    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
