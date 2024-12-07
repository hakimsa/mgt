import 'package:Upmstyle/widgets/my_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_floating_action_button/form_floating_action_button.dart';
import 'package:form_validation/form_validation.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Flexible(
      flex: 2,
      child: Container(
          color: const Color.fromARGB(54, 60, 64, 60),
          height: 550,
          width: double.infinity,
          child: SingleChildScrollView(child: MyForm())),
    ));
  }
}
