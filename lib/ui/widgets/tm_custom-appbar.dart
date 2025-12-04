import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:task_management_project_module18/ui/controllers/authentication_controller.dart';
import 'package:task_management_project_module18/ui/screens/sign_in_screen.dart';
import 'package:task_management_project_module18/ui/screens/update_profile_screen.dart';

class TMCustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TMCustomAppBar({super.key, this.fromUpdateProfile = false});

  final bool fromUpdateProfile;

  void _onTapProfileImage(BuildContext context) {
    if (fromUpdateProfile) {
      return;
    } else {
      Navigator.pushNamed(context, UpdateProfileScreen.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    //var taking for text style...//
    final textTheme = Theme.of(context).textTheme;
    //
    return AppBar(
      backgroundColor: Colors.green,
      title: GestureDetector(
        onTap: () => _onTapProfileImage(context),
        child: Row(
          spacing: 12,
          children: [
            CircleAvatar(
              backgroundImage: MemoryImage(base64Decode(AuthenticationController.user!.photo ?? '')),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AuthenticationController.user?.fullName ?? '',
                  style: textTheme.bodyLarge?.copyWith(color: Colors.white),
                ),
                Text(
                  AuthenticationController.user?.email ?? '',
                  style: textTheme.bodySmall?.copyWith(color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          onPressed: () async {
            await AuthenticationController.clearUserData();
            Navigator.pushNamedAndRemoveUntil(
              context,
              SignInScreen.name,
              (predicate) => false,
            );
          },
          icon: Icon(Icons.logout, color: Colors.white, size: 24),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
