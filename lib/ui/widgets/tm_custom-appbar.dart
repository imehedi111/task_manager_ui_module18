import 'package:flutter/material.dart';
import 'package:task_management_project_module18/ui/screens/update_profile_screen.dart';

class TMCustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TMCustomAppBar({super.key});

  void _onTapProfileImage(BuildContext context){
    Navigator.pushNamed(context, UpdateProfileScreen.name);
  }

  @override
  Widget build(BuildContext context) {
    //var taking for text style...//
    final textTheme = Theme.of(context).textTheme;
    //
    return AppBar(
      backgroundColor: Colors.green,
      title: GestureDetector(
        onTap: ()=> _onTapProfileImage(context),
        child: Row(
          spacing: 12,
          children: [
            CircleAvatar(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Md Mehedi Hasan',
                  style: textTheme.bodyLarge?.copyWith(color: Colors.white),
                ),
                Text(
                  'imehedi111@gmail.com',
                  style: textTheme.bodySmall?.copyWith(color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }



  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
