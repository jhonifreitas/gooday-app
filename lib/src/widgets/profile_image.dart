import 'package:flutter/material.dart';

import 'package:gooday/src/common/theme.dart';

class ProfileImage extends StatelessWidget {
  const ProfileImage({
    required this.onUpload,
    this.image,
    this.color = Colors.grey,
    super.key,
  });

  final Color color;
  final String? image;
  final VoidCallback onUpload;

  @override
  Widget build(BuildContext context) {
    if (image == null || image!.isEmpty) {
      return SizedBox(
        width: 100,
        height: 100,
        child: FloatingActionButton(
          elevation: 0,
          focusElevation: 0,
          hoverElevation: 0,
          highlightElevation: 0,
          tooltip: 'Enviar foto',
          heroTag: 'profile-btn-image',
          backgroundColor: Colors.transparent,
          splashColor: color.withOpacity(0.2),
          shape: StadiumBorder(side: BorderSide(width: 2, color: color)),
          onPressed: onUpload,
          child: Icon(Icons.camera_alt_outlined, color: color, size: 40),
        ),
      );
    }

    return Stack(
      children: [
        Material(
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: Ink.image(
            width: 100,
            height: 100,
            fit: BoxFit.cover,
            image: const AssetImage('assets/images/avatar.png'),
            child: InkWell(onTap: onUpload),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          width: 30,
          height: 30,
          child: IconButton(
            padding: const EdgeInsets.all(6),
            onPressed: onUpload,
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll<Color>(secondaryColor),
            ),
            icon: const Icon(
              size: 15,
              color: Colors.white,
              Icons.photo_camera_outlined,
            ),
          ),
        )
      ],
    );
  }
}
