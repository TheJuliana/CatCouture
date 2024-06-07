import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:online_store/widgets/auth_widgets.dart';

class AuthFunc extends StatelessWidget {
  final bool loggedIn;
  final void Function() signOut;

  const AuthFunc({
    super.key,
    required this.loggedIn,
    required this.signOut,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: StyledButton(
            onPressed: () {
              !loggedIn ? context.push('/sign-in') : signOut();
            },
            child: !loggedIn ? const Text('Log in') : const Text('Logout'),
          ),
        ),
        Visibility(
            visible: loggedIn,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: StyledButton(
                onPressed: () {
                  context.push('/profile');
                }, child: const Text('Profile'),
              ),
            ),
        ),
      ],
    );
  }
}

