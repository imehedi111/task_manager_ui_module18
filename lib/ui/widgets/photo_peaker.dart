import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class photo_peaker extends StatelessWidget {
  const photo_peaker({
    super.key, required this.pickedImage,
  });
  
  final XFile? pickedImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        spacing: 8,
        children: [
          Container(
            height: 50,
            width: 80,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
            ),
            alignment: Alignment.center,
            child: Text('Photo', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),),
          ),
          Expanded(child: pickedImage == null ? Text('Select photo') : Text(pickedImage!.name)),
        ],
      ),
    );
  }
}