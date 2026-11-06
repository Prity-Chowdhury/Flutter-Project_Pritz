import 'package:flutter/material.dart';
import 'registration_page.dart';
import 'home_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        backgroundColor: const Color.fromARGB(255, 211, 192, 244),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.person,
              size: 80,
              color: Color.fromARGB(255, 211, 192, 244),
            ),

            const SizedBox(height: 20),

            const Text(
              "Welcome Back!",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            // Email Field
            const TextField(
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),

            const SizedBox(height: 15),

            // Password Field
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),

            const SizedBox(height: 20),

            // Login Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },

              child: const Text("Login"),
            ),

            const SizedBox(height: 10),

            // Registration Navigation
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegistrationPage(),
                  ),
                );
              },

              child: const Text("Don't have an account? Register"),
            ),
          ],
        ),
      ),
    );
  }
}
