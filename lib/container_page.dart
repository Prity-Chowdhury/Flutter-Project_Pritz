import 'package:flutter/material.dart';

class ContainerPage extends StatelessWidget {
  const ContainerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Container, Size & Card"),
        backgroundColor: Colors.pink,
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Container (Box)
            Container(
              height: 150,
              width: 150,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(width: 3, color: Colors.purple),
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Color.fromARGB(255, 227, 103, 144), Colors.purple],
                ),
              ),
              child: const Text(
                "Hello Container",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),

            // SizedBox (Space)
            const SizedBox(height: 20),

            // Card
            Card(
              elevation: 8,
              color: Colors.pink.shade100,
              margin: const EdgeInsets.all(10),
              child: const SizedBox(
                width: 200,
                height: 100,
                child: Center(
                  child: Text(
                    "Hello Card",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
