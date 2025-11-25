import 'package:flutter/material.dart';

class center_circular_progress_indicator extends StatelessWidget {
  const center_circular_progress_indicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: Colors.green,
      ),
    );
  }
}