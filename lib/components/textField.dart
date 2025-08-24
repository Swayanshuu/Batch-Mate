// ignore_for_file: non_constant_identifier_names, must_be_immutable, body_might_complete_normally_nullable, camel_case_types, file_names

import 'package:flutter/material.dart';

class textField extends StatelessWidget {
  String lebelText;
  bool obScureText;
  TextEditingController Controller;
  String ValidatorMessage;
  textField({
    super.key,
    required this.lebelText,
    required this.obScureText,
    required this.Controller,
    required this.ValidatorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: false,
      obscureText: obScureText,
      decoration: InputDecoration(
        label: Text(lebelText),
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(20),
        ),

        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: const Color.fromARGB(255, 255, 255, 255),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      controller: Controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value.toString().length < 3) {
          return ValidatorMessage;
        }
      },
    );
  }
}
