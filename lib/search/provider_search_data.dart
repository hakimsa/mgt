import 'package:Upmstyle/models/user.dart';
import 'package:Upmstyle/services/provider_user.dart';
import 'package:Upmstyle/views/detailes_user.dart';
import 'package:flutter/material.dart';

class ProviderSearchData extends SearchDelegate {
  String seleccion = '';
  ProviderUser providerAyuda = ProviderUser();
  late List<User> ayudas;
  // final peliculasProvider = new Provider();

  @override
  List<Widget> buildActions(BuildContext context) {
    // Las acciones de nuestro AppBar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del AppBar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los resultados que vamos a mostrar

    return Center(
      child: Container(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 25,
              ),
              Center(child: Text("No data found")),
              Text("Try again ")
            ],
          ),
        ),
        decoration: BoxDecoration(
            color: const Color.fromARGB(137, 18, 17, 17),
            borderRadius: BorderRadius.all(Radius.circular(100))),
        height: 150.0,
        width: 350.0,
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Son las sugerencias que aparecen cuando la persona escribe
    if (query.isEmpty) {
      return Container();
    }

    final fetchUsersStream = providerAyuda.fetchUsersStream();
    return StreamBuilder<List<User>>(
      stream: fetchUsersStream,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          final users = snapshot.data as List<User>;

          final listaSugerida = (query.isEmpty)
              ? users
              : users
                  .where((p) =>
                      p.firstname.toLowerCase().startsWith(query.toLowerCase()))
                  .toList();
          return ListView.builder(
            itemCount: listaSugerida.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                elevation: 5,
                child: ListTile(
                  leading: FadeInImage(
                    image: NetworkImage(listaSugerida[index].avatar),
                    placeholder: AssetImage('assets/images/loader.gif'),
                    width: 50.0,
                    fit: BoxFit.contain,
                  ),
                  title: Text(listaSugerida[index].firstname.toString()),
                  subtitle: Text(listaSugerida[index].description),
                  onTap: () {
                    close(context, null);
                    // pelicula.uniqueId = '';
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                DetailScreen(user: listaSugerida[index])));
                  },
                ),
              );
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
