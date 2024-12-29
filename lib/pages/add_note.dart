// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rich_field_controller/rich_field_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddNote extends StatefulWidget {
  bool isEdit;
  Map<String, dynamic>? note;

  AddNote({Key? key, required this.isEdit, this.note}) : super(key: key);

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  late final FocusNode _fieldFocusNode;
  late final RichFieldController _controller;
  var supabase = Supabase.instance.client;

  bool isAddNote = false;

  Future<void> addNote() async {
    try {
      setState(() {
        isAddNote = true;
      });

      if (widget.isEdit) {
        await supabase
            .from('notes')
            .update({'body': _controller.text}).eq('id', widget.note!['id']);
      } else {
        await supabase.from('notes').insert({'body': _controller.text});
      }

      setState(() {
        isAddNote = false;
      });

      Get.offAllNamed('/');
    } catch (error) {
      print(error);
      setState(() {
        isAddNote = false;
      });
    }
  }

  Future<void> deleteNote() async {
    try {
      setState(() {
        isAddNote = true;
      });

      await supabase.from('notes').delete().eq('id', widget.note!['id']);

      setState(() {
        isAddNote = false;
      });

      Navigator.of(context).pop();
    } catch (error) {
      print(error);
      setState(() {
        isAddNote = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fieldFocusNode = FocusNode();
    _controller = RichFieldController(focusNode: _fieldFocusNode);

    if (widget.isEdit) {
      _controller.text = widget.note!['body'];
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _fieldFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.isEdit ? const Text('Edit Note') : const Text('Add Note'),
        actions: [
          IconButton(
              onPressed: deleteNote,
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              )),
          isAddNote
              ? const SizedBox(
                  height: 15,
                  width: 15,
                  child: CircularProgressIndicator(
                    color: Colors.black,
                    strokeWidth: 3,
                  ),
                )
              : IconButton(onPressed: addNote, icon: const Icon(Icons.save))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // RichfieldToolBar(textController: _controller),
            Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 900),
                padding: const EdgeInsets.all(0),
                child: TextField(
                  controller: _controller,
                  focusNode: _fieldFocusNode,
                  style: const TextStyle(
                    fontSize:
                        26, // Set the font size for the text inside the TextField
                    color: Colors.black, // Text color
                  ),
                  maxLines: null,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Write something here...',
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.all(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
