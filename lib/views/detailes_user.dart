import 'package:Upmstyle/models/user.dart';
import 'package:Upmstyle/services/provider_user.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.user});

  final User user;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool isEditing = false;
  bool _isUpdating = false;
  bool _loading = false;

  // Controladores para cada campo
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerFirstname = TextEditingController();
  final TextEditingController _controllerLastname = TextEditingController();
  final TextEditingController _controllerAvatar = TextEditingController();
  final TextEditingController _controllerRole = TextEditingController();

  // Provider para manejar la lógica
  ProviderUser providerUser = ProviderUser();

  @override
  void initState() {
    super.initState();
    // Inicializar los controladores con los valores actuales del usuario
    _controllerEmail.text = widget.user.email;
    _controllerFirstname.text = widget.user.firstname;
    _controllerLastname.text = widget.user.lastname;
    _controllerAvatar.text = widget.user.avatar;
    _controllerRole.text = widget.user.role;
  }

  @override
  void dispose() {
    // Limpiar los controladores al finalizar
    _controllerEmail.dispose();
    _controllerFirstname.dispose();
    _controllerLastname.dispose();
    _controllerAvatar.dispose();
    _controllerRole.dispose();
    super.dispose();
  }

  // Método para actualizar datos
  Future<void> updateUser(BuildContext context) async {
    if (_isUpdating) return;

    setState(() {
      _isUpdating = true;
    });

    try {
      User updatedUser = User(
        id: widget.user.id,
        email: _controllerEmail.text,
        firstname: _controllerFirstname.text,
        lastname: _controllerLastname.text,
        avatar: _controllerAvatar.text,
        addess: widget.user.addess,
        age: widget.user.age,
        description: widget.user.description,
        nacion: widget.user.nacion,
        role: _controllerRole.text,
        telefon: widget.user.telefon,
        token: widget.user.token,
        password: widget.user.password,
        formacion: widget.user.formacion,
        lenguage: widget.user.lenguage,
        redes: widget.user.redes,
      );

      await providerUser.updateData(updatedUser);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Usuario actualizado exitosamente")),
      );

      setState(() {
        isEditing = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al actualizar el usuario: $e")),
      );
    } finally {
      setState(() {
        _isUpdating = false;
      });
    }
  }

  // Vista de detalles del usuario
  // Vista de detalles del usuario con diseño minimalista
  Widget buildUserDetails(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar del usuario
          CircleAvatar(
            backgroundImage: NetworkImage(widget.user.avatar),
            radius: 60,
            backgroundColor: Colors.grey[200],
            onBackgroundImageError: (_, __) => const Icon(
              Icons.broken_image,
              size: 50,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 20),

          // Nombre del usuario
          Text(
            "${widget.user.firstname} ${widget.user.lastname}",
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),

          // Rol del usuario
          const SizedBox(height: 10),
          Text(
            widget.user.role,
            style: const TextStyle(
              fontSize: 18,
              fontStyle: FontStyle.italic,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 30),
          Divider(color: Colors.grey[300], thickness: 1),

          // Detalles adicionales del usuario
          buildDetailSection("Personal Info", [
            buildDetailItem("Description", widget.user.description),
            buildDetailItem("Nation", widget.user.nacion),
            buildDetailItem("Phone", widget.user.telefon),
            buildDetailItem("Language", widget.user.lenguage),
          ]),
          const SizedBox(height: 20),

          buildDetailSection("Professional Info", [
            buildDetailItem("Role", widget.user.role),
            buildDetailItem("Education", widget.user.formacion),
            buildDetailItem("Social Media", widget.user.redes),
          ]),
          const SizedBox(height: 20),

          buildDetailSection("Security Info", [
            buildDetailItem("Token", widget.user.token),
            buildDetailItem("Password", widget.user.password),
          ]),

          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              setState(() {
                isEditing = true;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueGrey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Text(
              "Editar",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
          // Botón para borrar
          ElevatedButton(
            onPressed: _loading
                ? null
                : () {
                    // Mostrar AlertDialog de confirmación antes de borrar
                    _showDeleteConfirmationDialog(context);
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: _loading
                ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                : const Text(
                    "Delete",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
          ),
        ],
      ),
    );
  }

// Método para mostrar el AlertDialog de confirmación de borrado
  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('¿Estás seguro de que quieres borrar este usuario?'),
        content: const Text('Esta acción no se puede deshacer.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Cerrar el diálogo si se cancela
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              // Confirmar borrado
              _deleteUser(context);
              Navigator.pop(context); // Cerrar el diálogo de confirmación
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  // Método para borrar al usuario
  void _deleteUser(BuildContext context) {
    setState(() {
      _loading = true; // Habilitar el estado de carga
    });

    // Simulación del proceso de eliminación del usuario
    Future.delayed(const Duration(seconds: 2)).then((_) {
      if (mounted) {
        // Llamar al método para borrar el usuario
        providerUser.deleteUser(context, widget.user.id);

        setState(() {
          _loading = false; // Deshabilitar el estado de carga
        });

        // Mostrar el AlertDialog de éxito
        _showDeleteSuccessDialog(context);
      }
    });
  }

  void _showDeleteSuccessDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Usuario borrado con éxito'),
        content: const Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 40,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Cerrar el diálogo de éxito
              Navigator.pop(context); // Volver a la pantalla anterior
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

// Sección de detalles con título
  Widget buildDetailSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 10),
        ...children,
        const SizedBox(height: 20),
        Divider(color: Colors.grey[300], thickness: 1),
      ],
    );
  }

// Detalle de un campo
  Widget buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Formulario de edición
  // Formulario de edición
  Widget buildEditForm(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          TextFormField(
            controller: _controllerEmail,
            decoration: const InputDecoration(labelText: "Email"),
          ),
          const SizedBox(height: 15),
          TextFormField(
            controller: _controllerFirstname,
            decoration: const InputDecoration(labelText: "Firstname"),
          ),
          const SizedBox(height: 15),
          TextFormField(
            controller: _controllerLastname,
            decoration: const InputDecoration(labelText: "Lastname"),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _controllerAvatar,
                  decoration: const InputDecoration(labelText: "Avatar URL"),
                ),
              ),
              const SizedBox(width: 10),
              CircleAvatar(
                backgroundImage: NetworkImage(_controllerAvatar.text),
                radius: 30,
                onBackgroundImageError: (_, __) =>
                    const Icon(Icons.broken_image),
              ),
            ],
          ),
          const SizedBox(height: 15),
          TextFormField(
            decoration: const InputDecoration(labelText: "Address"),
            initialValue: widget.user.addess,
            onChanged: (value) => widget.user.addess = value,
          ),
          const SizedBox(height: 15),
          TextFormField(
            decoration: const InputDecoration(labelText: "Age"),
            initialValue: widget.user.age.toString(),
            keyboardType: TextInputType.number,
            onChanged: (value) =>
                widget.user.age = int.tryParse(value) ?? widget.user.age,
          ),
          const SizedBox(height: 15),
          TextFormField(
            decoration: const InputDecoration(labelText: "Description"),
            initialValue: widget.user.description,
            onChanged: (value) => widget.user.description = value,
          ),
          const SizedBox(height: 15),
          TextFormField(
            decoration: const InputDecoration(labelText: "Nation"),
            initialValue: widget.user.nacion,
            onChanged: (value) => widget.user.nacion = value,
          ),
          const SizedBox(height: 15),
          TextFormField(
            controller: _controllerRole,
            decoration: const InputDecoration(labelText: "Role"),
          ),
          const SizedBox(height: 15),
          TextFormField(
            decoration: const InputDecoration(labelText: "Phone"),
            initialValue: widget.user.telefon,
            keyboardType: TextInputType.phone,
            onChanged: (value) => widget.user.telefon = value,
          ),
          const SizedBox(height: 15),
          TextFormField(
            decoration: const InputDecoration(labelText: "Token"),
            initialValue: widget.user.token,
            onChanged: (value) => widget.user.token = value,
          ),
          const SizedBox(height: 15),
          TextFormField(
            decoration: const InputDecoration(labelText: "Password"),
            initialValue: widget.user.password,
            obscureText: true,
            onChanged: (value) => widget.user.password = value,
          ),
          const SizedBox(height: 15),
          TextFormField(
            decoration: const InputDecoration(labelText: "Education"),
            initialValue: widget.user.formacion,
            onChanged: (value) => widget.user.formacion = value,
          ),
          const SizedBox(height: 15),
          TextFormField(
            decoration: const InputDecoration(labelText: "Language"),
            initialValue: widget.user.lenguage,
            onChanged: (value) => widget.user.lenguage = value,
          ),
          const SizedBox(height: 15),
          TextFormField(
            decoration: const InputDecoration(labelText: "Social Media Links"),
            initialValue: widget.user.redes,
            onChanged: (value) => widget.user.redes = value,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _isUpdating
                    ? null
                    : () {
                        updateUser(context);
                      },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: _isUpdating
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : const Text("Guardar"),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isEditing = false;
                  });
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text("Cancelar"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing
            ? "Editar Usuario: ${widget.user.id}"
            : "Detalle del Usuario: ${widget.user.id}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: isEditing ? buildEditForm(context) : buildUserDetails(context),
      ),
    );
  }
}
