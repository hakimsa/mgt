import 'dart:async';
import 'dart:convert';

import 'package:Upmstyle/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProviderUser {
  get userModel => null;

  final _usersStreamController = StreamController<List<User>>.broadcast();

  Function(List<User>) get usersSink => _usersStreamController.sink.add;

  Stream<List<User>> get userStream => _usersStreamController.stream;

  void disposeStreams() {
    _usersStreamController?.close();
  }

//get All users
  Future<List<User>> getallUsers() async {
    String url = "http://0.0.0.0:8092/api/v1/users/all";
    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return usersModelFromJson(response.body);
    } else {
      throw ("messageErrorCarsApi");
    }
  }

  // Define la URL base de la API
  final String baseUrl = "http://localhost:8092/api/v1/users/save";

  Future<User> updateData(User user) async {
    try {
      final response = await http.put(
        Uri.parse("http://localhost:8092/api/v1/users/update/${user.id}"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(user.toJson()), // Usa el método `toJson` de tu modelo
      );

      if (response.statusCode == 200) {
        // Si el servidor devuelve un código 200, analiza la respuesta
        return User.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else if (response.statusCode == 404) {
        throw Exception('Usuario no encontrado.');
      } else if (response.statusCode == 400) {
        throw Exception('Solicitud incorrecta. Revisa los datos enviados.');
      } else {
        throw Exception('Error desconocido al actualizar el usuario.');
      }
    } catch (e) {
      // Manejo de errores adicionales, como problemas de conexión
      throw Exception('Error al actualizar el usuario: $e');
    }
  }

  // Método para hacer la solicitud POST con los datos de entrada
  Future<void> addData(BuildContext context, Map<String, dynamic> data) async {
    try {
      // Realiza la solicitud POST a la API
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      // Verifica el estado de la respuesta
      if (response.statusCode == 200) {
        _showSuccessMessage(context);
      } else {
        _showErrormessage(context, response.statusCode.toString());
      }
    } catch (e) {
      _showErrormessage(context, e);
    }
  }

  Stream<List<User>> streamDataCollection() {
    return getallUsers().asStream();
  }

  Stream<List<User>> fetchUsersStream() {
    return streamDataCollection();
  }

  void _showSuccessMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Success"),
          content: Text("User inserted successfully!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
                Navigator.pushNamed(context, "/");
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  final String apiUrlDelete = "http://localhost:8092/api/v1/users";

  Future<void> deleteUser(BuildContext context, int userId) async {
    final url = Uri.parse(
        '$apiUrlDelete/$userId'); // Ajusta la URL para incluir el ID del usuario
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      _showDeleteMessage(context);
    } else {
      print("Failed to delete user: ${response.statusCode}");
      print(response.body);
    }
  }

  Future<bool> checkUserExists(String email) async {
    final response = await http.get(
        Uri.parse("http://localhost:8092/api/v1/users/checkUser?email=$email"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data[
          'exists']; // Suponiendo que la API devuelve { "exists": true/false }
    } else {
      throw Exception("Error al verificar el usuario");
    }
  }

  void _showDeleteMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Deleted"),
          content: Text("User deleted successfully!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
                Navigator.pushNamed(context,
                    "/"); // Regresa a la lista actualizada // Regresa a la lista actualizada
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showErrormessage(BuildContext context, message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 30,
              ),
              Text("Error :"),
            ],
          ),
          content: Text("Failed to insert data. Status code:  ${message}"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
                Navigator.pushNamed(
                    context, "/"); // Regresa a la lista actualizada
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}

class UserProvider extends ChangeNotifier {
  List<User> userModel = [];
  ProviderUser userHttpService = ProviderUser();
  void getUsersData() async {
    userModel = await userHttpService.getallUsers();
    notifyListeners();
  }

  Future<User> updateData(User user) async {
    try {
      final response = await http.put(
        Uri.parse("http://localhost:8092/api/v1/users/${user.id}"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(user.toJson()), // Usa el método `toJson` de tu modelo
      );

      if (response.statusCode == 200) {
        // Si el servidor devuelve un código 200, analiza la respuesta
        return User.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else if (response.statusCode == 404) {
        throw Exception('Usuario no encontrado.');
      } else if (response.statusCode == 400) {
        throw Exception('Solicitud incorrecta. Revisa los datos enviados.');
      } else {
        throw Exception('Error desconocido al actualizar el usuario.');
      }
    } catch (e) {
      // Manejo de errores adicionales, como problemas de conexión
      throw Exception('Error al actualizar el usuario: $e');
    }
  }
}
