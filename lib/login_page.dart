import 'package:flutter/material.dart';
import 'registration_page.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Form controllers
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isPasswordVisible = false;

  void login() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Validation successful!")));

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F7),

      appBar: AppBar(
        title: const Text(
          "TaRa's Corner",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFE6DDF5),
        foregroundColor: const Color(0xFF514064),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),

        child: Form(
          key: _formKey,

          child: Column(
            children: [
              const SizedBox(height: 40),

              const Icon(
                Icons.shopping_bag_outlined,
                size: 85,
                color: Color(0xFFC5A45D),
              ),

              const SizedBox(height: 20),

              const Text(
                "Welcome Back!",
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF514064),
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Login to TaRa's Corner",
                style: TextStyle(fontSize: 16),
              ),

              const SizedBox(height: 35),

              // Email Field
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,

                decoration: const InputDecoration(
                  labelText: "Email Address",
                  prefixIcon: Icon(Icons.email),
                ),

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter email";
                  }

                  String pattern =
                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';

                  if (!RegExp(pattern).hasMatch(value.trim())) {
                    return "Enter a valid email";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Password Field
              TextFormField(
                controller: passwordController,
                obscureText: !isPasswordVisible,

                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: const Icon(Icons.lock),

                  suffixIcon: IconButton(
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),

                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                  ),
                ),

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter password";
                  }

                  if (value.length < 8) {
                    return "Minimum 8 characters required";
                  }

                  if (!RegExp(r'[0-9]').hasMatch(value)) {
                    return "Password must contain a number";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 30),

              // Login Button
              SizedBox(
                width: double.infinity,
                height: 50,

                child: ElevatedButton(
                  onPressed: login,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDCCBF0),
                    foregroundColor: const Color(0xFF514064),
                  ),

                  child: const Text(
                    "LOGIN",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // Registration Button
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegistrationPage(),
                    ),
                  );
                },

                child: const Text(
                  "Don't have an account? Register",
                  style: TextStyle(color: Color(0xFF514064)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
