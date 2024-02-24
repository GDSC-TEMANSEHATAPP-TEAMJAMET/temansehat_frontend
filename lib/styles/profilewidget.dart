import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:temansehat_app/styles/color.dart';

class ProfileWidget extends StatelessWidget {
  final String? imagePath;
  final VoidCallback onClicked;

  const ProfileWidget(
      {Key? key, required this.imagePath, required this.onClicked});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Center(
      child: Stack(children: [
        buildImage(context),
        Positioned(bottom: 0, right: 4, child: buildEditButton(color)),
      ]),
    );
  }

  Widget buildImage(context) {
    final width = MediaQuery.of(context).size.width;

    final image = MemoryImage(
      base64Decode(imagePath ?? ''),
    );

    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: image,
          fit: BoxFit.cover,
          width: width * 0.3,
          height: width * 0.3,
          child: InkWell(
            onTap: onClicked,
          ),
        ),
      ),
    );
  }

  buildEditButton(Color color) => buildCircle(
        all: 8,
        color: bluePrimary,
        child: Icon(
          Icons.camera_alt_rounded,
          color: Colors.white,
          size: 20,
        ),
      );

  buildCircle(
          {required double all, required Widget child, required Color color}) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}
