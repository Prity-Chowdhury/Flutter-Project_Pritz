import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;

  const CartPage({super.key, required this.cartItems});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final supabase = Supabase.instance.client;

  bool isLoading = false;

  double get totalPrice {
    double total = 0;

    for (var product in widget.cartItems) {
      total += double.tryParse(product['price'].toString()) ?? 0;
    }

    return total;
  }

  void removeProduct(int index) {
    setState(() {
      widget.cartItems.removeAt(index);
    });
  }

  Future<void> placeOrder() async {
    if (widget.cartItems.isEmpty) return;

    final user = supabase.auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please login first!')));
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final orderItems = widget.cartItems.map((product) {
        return {
          'product_id': product['id'],
          'name': product['name'],
          'price': product['price'],
          'category': product['category'],
        };
      }).toList();

      await supabase.from('orders').insert({
        'user_id': user.id,
        'customer_email': user.email,
        'items': orderItems,
        'total': totalPrice,
      });

      widget.cartItems.clear();

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order placed successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order failed: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Cart")),

      body: widget.cartItems.isEmpty
          ? const Center(
              child: Text(
                "Your cart is empty!",
                style: TextStyle(fontSize: 18),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.cartItems.length,
                    itemBuilder: (context, index) {
                      final product = widget.cartItems[index];

                      return Card(
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          leading: const Icon(
                            Icons.shopping_bag,
                            color: Colors.pink,
                            size: 35,
                          ),

                          title: Text(product['name'] ?? 'Product'),

                          subtitle: Text("Price: ৳${product['price']}"),

                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              removeProduct(index);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        "Total: ৳${totalPrice.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 15),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : placeOrder,
                          child: isLoading
                              ? const CircularProgressIndicator()
                              : const Text("Place Order"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
