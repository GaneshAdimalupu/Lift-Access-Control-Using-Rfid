import 'dart:io';
import 'package:flutter/material.dart';

class ProfileWidget extends StatelessWidget {
  final String imagePath;
  final VoidCallback onClicked;

  const ProfileWidget({
    Key? key,
    required this.imagePath,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: onClicked,
        child: Container(
          width: 128,
          height: 128,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: imagePath.isNotEmpty
                  ? (imagePath.contains('https://')
                      ? NetworkImage(imagePath) as ImageProvider<Object>
                      : FileImage(File(imagePath)) as ImageProvider<Object>)
                  : AssetImage('assets/default_profile_image.png'),
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                right: 4,
                child: buildEditIcon(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildEditIcon() => Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        padding: EdgeInsets.all(3),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue,
          ),
          padding: EdgeInsets.all(8),
          child: Icon(
            Icons.edit,
            color: Colors.white,
            size: 20,
          ),
        ),
      );
}
