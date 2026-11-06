import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: const Color.fromARGB(255, 211, 192, 244),
      ),

      body: Center(
        child: Card(
          elevation: 5,
          color: const Color.fromARGB(255, 211, 192, 244),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),

          child: SizedBox(
            width: 250,
            height: 320,

            child: Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Profile Icon
                  const Icon(Icons.person, size: 70, color: Colors.black54),

                  const SizedBox(height: 10),

                  // Name
                  const Text(
                    "Your Name",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  // Designation
                  const Text(
                    "Student",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),

                  const SizedBox(height: 10),

                  // Divider
                  const Divider(thickness: 2, color: Colors.black38),

                  // Email
                  const Row(
                    children: [
                      Icon(Icons.email, size: 20, color: Colors.black54),

                      SizedBox(width: 8),

                      Text(
                        "example@gmail.com",
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Location
                  const Row(
                    children: [
                      Icon(Icons.location_on, size: 20, color: Colors.black54),

                      SizedBox(width: 8),

                      Text(
                        "Sylhet, Bangladesh",
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  // View Profile Button
                  ElevatedButton(
                    onPressed: () {
                      print("View Profile Clicked");
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black54,
                    ),

                    child: const Text("View Profile"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
