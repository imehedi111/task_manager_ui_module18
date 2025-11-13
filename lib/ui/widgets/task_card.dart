import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      child: ListTile(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8)
        ),
        tileColor: Colors.white,
        title: Text('Title of the Task', style: TextTheme.of(context).titleMedium,),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Description of the task in details.',
              style: TextTheme.of(context).bodyMedium?.copyWith(
                color: Colors.grey,
                fontSize: 15,
              ),
            ),
            SizedBox(height: 10,),
            Text(
              'Date: 12 June 2021',
              style: TextTheme.of(context).bodySmall?.copyWith(
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
            Row(
              children: [
                Chip(
                  label: Text('New', style: TextTheme.of(context).labelSmall?.copyWith(
                    color: Colors.white,
                  ),),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  backgroundColor: Colors.blue,
                  labelPadding: EdgeInsetsGeometry.symmetric(horizontal: 25, vertical: 0,),
                ),
                Spacer(),
                IconButton(onPressed: (){}, icon: Icon(Icons.edit_note_sharp, color: Colors.green,)),
                IconButton(onPressed: (){}, icon: Icon(Icons.delete, color: Colors.red,)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}