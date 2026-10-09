import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("homepage"),
        backgroundColor: const Color.fromARGB(255, 89, 11, 90),
        foregroundColor: const Color.fromARGB(109, 7, 33, 54),
        //leading: Icon(Icons.home),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.person)),
          IconButton(onPressed: () {}, icon: Icon(Icons.logout)),
        ],
      ),

      //appbar
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text("Name"),
              accountEmail: Text("Email"),
            ),

            ListTile(
              leading: Icon(Icons.settings),
              hoverColor: const Color.fromARGB(255, 59, 171, 228),
              title: Text("homepage"),
              onTap: () {},
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.settings),
              hoverColor: const Color.fromARGB(255, 140, 189, 214),
              title: Text("location"),
              onTap: () {},
            ),
            Spacer(),
            ListTile(
              leading: Icon(Icons.person),
              trailing: IconButton(onPressed: () {}, icon: Icon(Icons.logout)),
              hoverColor: const Color.fromARGB(255, 221, 190, 104),
              title: Text("profile"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color.fromARGB(255, 94, 8, 121),
        foregroundColor: Colors.white,
        hoverColor: const Color.fromARGB(255, 105, 34, 12),
        tooltip: "Write",
        shape: CircleBorder(),
        child: Icon(Icons.add),
      ),
      body: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                side: BorderSide(color: Color(0xFF6C63FF)),
                backgroundColor: Color(0xFFEDE9FE),
                foregroundColor: Color(0xFF5B21B6),
                shadowColor: Colors.grey,
                elevation: 5,
                fixedSize: Size(100, 50),
              ),
              child: Text("blue"),
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              side: BorderSide(color: Color(0xFF059669)),
              backgroundColor: Color(0xFFD1FAE5),
              foregroundColor: Color(0xFF047857),
              shadowColor: Colors.grey,
              elevation: 5,
              fixedSize: Size(100, 50),
            ),
            child: Text("Green"),
          ),

          OutlinedButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              side: BorderSide(color: Color(0xFFEC4899)),
              backgroundColor: Color(0xFFFCE7F3),
              foregroundColor: Color(0xFFBE185D),
              shadowColor: Colors.grey,
              elevation: 5,
              fixedSize: Size(100, 50),
            ),
            child: Text("Pink"),
          ),
        ],
      ),
    );
  }
}
