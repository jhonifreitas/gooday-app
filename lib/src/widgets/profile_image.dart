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
        child: Tooltip(
          message: 'Enviar foto',
          child: Material(
            color: Colors.transparent,
            clipBehavior: Clip.hardEdge,
            shape: CircleBorder(side: BorderSide(width: 2, color: color)),
            child: InkWell(
              onTap: onUpload,
              child: Icon(Icons.camera_alt_outlined, color: color, size: 40),
            ),
          ),
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
            image: NetworkImage(image!),
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
