import 'package:flutter/material.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  // Step 1: Form Key and Controllers
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Step 2: Password Visibility
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  // Step 3: Registration Function
  void register() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "All information is valid! Firebase registration is next.",
          ),
        ),
      );
    }
  }

  // Step 4: Controller Cleanup
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F7),

      appBar: AppBar(
        title: const Text(
          "Create Account",
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
              const SizedBox(height: 15),

              const Icon(
                Icons.person_add_alt_1,
                size: 75,
                color: Color(0xFFC5A45D),
              ),

              const SizedBox(height: 15),

              const Text(
                "Join TaRa's Corner!",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF514064),
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Create your account and start shopping",
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),

              // Full Name
              TextFormField(
                controller: nameController,

                decoration: const InputDecoration(
                  labelText: "Full Name",
                  prefixIcon: Icon(Icons.person),
                ),

                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter your name";
                  }

                  if (value.trim().length < 3) {
                    return "Name must be at least 3 characters";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 18),

              // Email
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,

                decoration: const InputDecoration(
                  labelText: "Email Address",
                  prefixIcon: Icon(Icons.email),
                ),

                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter your email";
                  }

                  String pattern =
                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';

                  if (!RegExp(pattern).hasMatch(value.trim())) {
                    return "Enter a valid email address";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 18),

              // Phone Number
              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,

                decoration: const InputDecoration(
                  labelText: "Phone Number",
                  hintText: "01XXXXXXXXX",
                  prefixIcon: Icon(Icons.phone),
                ),

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your phone number";
                  }

                  if (!RegExp(r'^01[3-9][0-9]{8}$').hasMatch(value)) {
                    return "Enter a valid BD phone number";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 18),

              // Password
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
                    return "Please enter your password";
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

              const SizedBox(height: 18),

              // Confirm Password
              TextFormField(
                controller: confirmPasswordController,
                obscureText: !isConfirmPasswordVisible,

                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  prefixIcon: const Icon(Icons.lock_outline),

                  suffixIcon: IconButton(
                    icon: Icon(
                      isConfirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        isConfirmPasswordVisible = !isConfirmPasswordVisible;
                      });
                    },
                  ),
                ),

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please confirm your password";
                  }

                  if (value != passwordController.text) {
                    return "Passwords do not match";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 28),

              // Register Button
              SizedBox(
                width: double.infinity,
                height: 50,

                child: ElevatedButton(
                  onPressed: register,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDCCBF0),
                    foregroundColor: const Color(0xFF514064),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),

                  child: const Text(
                    "REGISTER",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // Back to Login
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },

                child: const Text(
                  "Already have an account? Login",
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
