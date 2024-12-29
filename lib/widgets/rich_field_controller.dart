// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:rich_field_controller/rich_field_controller.dart';

class RichfieldToolBar extends StatefulWidget {
  RichFieldController textController;

  RichfieldToolBar({super.key, required this.textController});

  @override
  State<RichfieldToolBar> createState() => _RichfieldToolBarState();
}

class _RichfieldToolBarState extends State<RichfieldToolBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
            onPressed: () {
              widget.textController
                  .updateStyle(const TextStyle(fontWeight: FontWeight.bold));
            },
            icon: const Icon(Icons.format_bold)),
        IconButton(
            onPressed: () {
              widget.textController
                  .updateStyle(const TextStyle(fontStyle: FontStyle.italic));
            },
            icon: const Icon(Icons.format_italic)),
        IconButton(
          onPressed: () {
            widget.textController.updateStyle(
              const TextStyle(decoration: TextDecoration.underline),
            );
          },
          icon: const Icon(Icons.format_underline),
        )
      ],
    );
  }
}
