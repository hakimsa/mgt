import 'package:Upmstyle/models/user.dart';
import 'package:Upmstyle/services/provider_user.dart';
import 'package:flutter/material.dart';

class MyForm extends StatefulWidget {
  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controller_email = TextEditingController();
  final TextEditingController _controller_firstname = TextEditingController();
  final TextEditingController _controller_lastname = TextEditingController();
  final TextEditingController _controller_avatar = TextEditingController();
  final TextEditingController _controller_address = TextEditingController();
  final TextEditingController _controller_age = TextEditingController();
  final TextEditingController _controller_description = TextEditingController();
  final TextEditingController _controller_nacion = TextEditingController();
  final TextEditingController _controller_role = TextEditingController();
  final TextEditingController _controller_telefon = TextEditingController();
  final TextEditingController _controller_token = TextEditingController();
  final TextEditingController _controller_password = TextEditingController();
  final TextEditingController _controller_formacion = TextEditingController();
  final TextEditingController _controller_lenguage = TextEditingController();
  final TextEditingController _controller_redes = TextEditingController();

  bool _loading = false;
  ProviderUser providerUser = ProviderUser();

  // Método para construir los campos de texto
  Widget buildTextFormField(TextEditingController controller, String labelText,
      {bool isEmail = false, bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(color: Colors.blue),
        ),
        filled: true,
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        labelText: labelText,
      ),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$labelText es requerido';
        }
        if (isEmail &&
            !RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                .hasMatch(value)) {
          return 'Ingrese un correo válido';
        }
        return null;
      },
    );
  }

  // Método de envío del formulario
  void submitForm(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      // Verifica si el email ya existe
      bool exists = await providerUser.checkUserExists(_controller_email.text);
      if (exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("El usuario ya existe")),
        );
        return;
      }

      // Construye el objeto de usuario y envíalo a la API
      User user = User(
        id: 3,
        email: _controller_email.text,
        firstname: _controller_firstname.text,
        lastname: _controller_lastname.text,
        avatar: _controller_avatar.text,
        addess: _controller_address.text,
        age: int.parse(_controller_age.text),
        description: _controller_description.text,
        nacion: _controller_nacion.text,
        role: _controller_role.text,
        telefon: _controller_telefon.text,
        token: _controller_token.text,
        password: _controller_password.text,
        formacion: _controller_formacion.text,
        lenguage: _controller_lenguage.text,
        redes: _controller_redes.text,
      );

      setState(() => _loading = true);

      await providerUser.addData(context, user.toJson());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Usuario insertado exitosamente")),
      );

      setState(() => _loading = false);
      Navigator.pushNamed(context, "/");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 26.0),
        child: Container(
          color: const Color.fromARGB(11, 0, 0, 0),
          margin: const EdgeInsets.all(15),
          child: Column(
            children: [
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                childAspectRatio: 23,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  buildTextFormField(_controller_email, 'Email', isEmail: true),
                  buildTextFormField(_controller_firstname, 'Firstname'),
                  buildTextFormField(_controller_lastname, 'Lastname'),
                  buildTextFormField(_controller_avatar, 'Avatar'),
                  buildTextFormField(_controller_address, 'Domicile'),
                  buildTextFormField(_controller_age, 'Age', isNumber: true),
                  buildTextFormField(_controller_description, 'Description'),
                  buildTextFormField(_controller_nacion, 'Nacion'),
                  buildTextFormField(_controller_role, 'Role'),
                  buildTextFormField(_controller_telefon, 'Telefon',
                      isNumber: false),
                  buildTextFormField(_controller_token, 'Token'),
                  buildTextFormField(_controller_password, 'Password'),
                  buildTextFormField(_controller_formacion, 'Formacion'),
                  buildTextFormField(_controller_lenguage, 'Lenguage'),
                  buildTextFormField(_controller_redes, 'Redes'),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _loading
                        ? null
                        : () async {
                            submitForm(context);
                          },
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: _loading
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color.fromARGB(255, 153, 208, 75)))
                        : const Row(
                            children: [
                              Text("Submit "),
                              Icon(Icons.person_add,
                                  color: Color.fromARGB(255, 54, 244, 98)),
                            ],
                          ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _formKey.currentState?.reset();
                      _controller_email.clear();
                      _controller_firstname.clear();
                      _controller_lastname.clear();
                      _controller_avatar.clear();
                      _controller_address.clear();
                      _controller_age.clear();
                      _controller_description.clear();
                      _controller_nacion.clear();
                      _controller_role.clear();
                      _controller_telefon.clear();
                      _controller_token.clear();
                      _controller_password.clear();
                      _controller_formacion.clear();
                      _controller_lenguage.clear();
                      _controller_redes.clear();
                    },
                    child: Text("Clear"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancel"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
