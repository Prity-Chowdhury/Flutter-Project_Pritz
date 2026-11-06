import 'package:flutter/material.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registration"),
        backgroundColor: const Color.fromARGB(255, 211, 192, 244),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.person_add,
              size: 80,
              color: Color.fromARGB(255, 211, 192, 244),
            ),

            const SizedBox(height: 20),

            const Text(
              "Create Account",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            // Name
            const TextField(
              decoration: InputDecoration(
                labelText: "Full Name",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),

            const SizedBox(height: 15),

            // Email
            const TextField(
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),

            const SizedBox(height: 15),

            // Password
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),

            const SizedBox(height: 20),

            // Register Button
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}
