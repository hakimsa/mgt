import 'package:Upmstyle/models/user.dart';
import 'package:Upmstyle/search/provider_search_data.dart';
import 'package:Upmstyle/services/provider_user.dart';
import 'package:Upmstyle/widgets/Menu.dart';
import 'package:flutter/material.dart';
import 'package:form_floating_action_button/form_floating_action_button.dart';
import 'package:provider/provider.dart';
import 'detailes_user.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomepageState();
}

class _HomepageState extends State<HomePage> {
  TextEditingController searchController = TextEditingController();
  ProviderUser providerUser = ProviderUser();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false).getUsersData();
  }

  void _onSubmit() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bienvenido a UPM Style",
            style: TextStyle(color: Colors.black)),
        backgroundColor: Color.fromARGB(255, 123, 244, 246),
        elevation: 0,
        centerTitle: true,
      ),
      drawer: Menu(),
      floatingActionButton: FormFloatingActionButton(
        icon: Icons.add,
        loading: _loading,
        onSubmit: () {
          setState(() => _loading = true);
          Future.delayed(Duration(seconds: 1)).then((_) {
            if (mounted) {
              setState(() {
                _loading = false;
                Navigator.pushNamed(context, "add");
              });
            }
          });
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              FutureBuilder<List<User>>(
                future: providerUser.getallUsers(),
                builder:
                    (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline,
                              color: Colors.red, size: 60),
                          SizedBox(height: 16),
                          Text('Error: ${snapshot.error}',
                              style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text("No hay usuarios disponibles."));
                  }

                  var users = snapshot.data!;
                  return Column(
                    children: [
                      Icon(Icons.person_2_sharp,
                          color: Color.fromARGB(255, 2, 120, 122), size: 70),
                      SizedBox(
                        width: 350,
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            hintText: "Buscar usuarios...",
                            suffixIcon: IconButton(
                              icon: Icon(Icons.search),
                              onPressed: () {
                                showSearch(
                                  context: context,
                                  delegate: ProviderSearchData(),
                                );
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide(color: Colors.blueAccent),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(63, 111, 84, 1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListView.builder(
                          itemCount: users.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return Hero(
                              tag: users[index].id,
                              child: Card(
                                margin: EdgeInsets.symmetric(vertical: 8),
                                elevation: 5,
                                child: ListTile(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DetailScreen(user: users[index]),
                                      ),
                                    );
                                  },
                                  title: Text(
                                    "${users[index].firstname} ${users[index].lastname}",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(users[index].role),
                                  leading: ClipOval(
                                    child: Image.network(
                                      users[index].avatar.toString(),
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  trailing: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: Colors.amber,
                                    ),
                                    width: 30,
                                    height: 30,
                                    child: Center(
                                      child: Text(
                                        users[index]
                                            .nacion
                                            .toString()
                                            .substring(0, 2)
                                            .toUpperCase(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
