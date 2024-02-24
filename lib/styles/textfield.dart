import 'package:flutter/material.dart';
import 'package:temansehat_app/styles/color.dart';

final InputDecoration passwordForm = InputDecoration(
  hintText: 'Password',
  filled: true,
  fillColor: formColor,
  contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: BorderSide.none,
  ),
);

final InputDecoration confirmPassForm = InputDecoration(
  hintText: 'Confirm Password',
  filled: true,
  fillColor: formColor,
  contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: BorderSide.none,
  ),
);

final InputDecoration usernameForm = InputDecoration(
  hintText: 'Username',
  filled: true,
  fillColor: formColor,
  contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: BorderSide.none,
  ),
);

final InputDecoration emailForm = InputDecoration(
  hintText: 'Email',
  filled: true,
  fillColor: formColor,
  contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: BorderSide.none,
  ),
);

class TextFieldEdit extends StatefulWidget {
  final String label;
  final String text;
  final ValueChanged<String> onChanged;
  const TextFieldEdit(
      {super.key,
      required this.label,
      required this.text,
      required this.onChanged});

  @override
  State<TextFieldEdit> createState() => _TextFieldEditState();
}

class _TextFieldEditState extends State<TextFieldEdit> {
 late final TextEditingController controller;


  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        widget.label,
        style:  TextStyle(fontWeight: FontWeight.bold, color: bluePrimary),
      ),
      

      TextFormField(
                          controller: controller,
                          decoration: InputDecoration(
                              labelText: 'Name',
                              labelStyle: TextStyle(color: bluePrimary)),
                          maxLength: 30,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
    ],
  );
}


