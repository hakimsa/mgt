import 'package:flutter/material.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 18.5),
      color: Color.fromARGB(130, 0, 0, 0),
      width: 350,
      child: Column(
        children: [
          Center(
            child: Column(
              children: [
                SizedBox(
                  height: 35,
                ),
                DrawerHeader(
                    child: Container(
                  color: Color.fromARGB(49, 0, 0, 0),
                  child: Center(
                    child: CircleAvatar(),
                  ),
                ))
              ],
            ),
          ),
          Card(
            color: Color.fromARGB(130, 0, 0, 0),
            child: ListTile(
              onTap: () {
                Navigator.pushNamed(context, "login");
              },
              title: Text(
                "Iniciar session",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Card(
            color: Color.fromARGB(130, 0, 0, 0),
            child: ListTile(
              onTap: () {
                Navigator.pushNamed(context, "Nove");
              },
              title: Text(
                "About",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Card(
            color: Color.fromARGB(130, 0, 0, 0),
            child: ListTile(
              title: Text(
                "Setting",
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
