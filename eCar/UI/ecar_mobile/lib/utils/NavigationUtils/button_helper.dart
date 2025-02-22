import 'dart:io';

import 'package:flutter/material.dart';

//added for purposes of navigation func
Widget getOptionsButton(
  BuildContext context, {
  required void Function()? onPressed,
  ButtonStyle? style,
}) =>
    ElevatedButton.icon(
      style: style ?? ElevatedButton.styleFrom(minimumSize: const Size(80, 36)),
      icon: const Icon(Icons.settings),
      onPressed: onPressed,
      label: const Text('Options'),
    );

Widget getOverlayOptionsButton(BuildContext context,
        {required void Function()? onPressed, ButtonStyle? style}) =>
    SafeArea(
      child: Align(
        alignment:
            Platform.isAndroid ? Alignment.bottomCenter : Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: getOptionsButton(context, onPressed: onPressed, style: style),
        ),
      ),
    );
