import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final supabase = Supabase.instance.client;

  late Future<List<Map<String, dynamic>>> ordersFuture;

  @override
  void initState() {
    super.initState();
    ordersFuture = loadOrders();
  }

  Future<List<Map<String, dynamic>>> loadOrders() async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      return [];
    }

    final response = await supabase
        .from('orders')
        .select()
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  String formatDate(dynamic date) {
    final parsedDate = DateTime.tryParse(date.toString());

    if (parsedDate == null) return 'Unknown date';

    return '${parsedDate.day}/${parsedDate.month}/${parsedDate.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),

      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: ordersFuture,

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Failed to load orders.'));
          }

          final orders = snapshot.data ?? [];

          if (orders.isEmpty) {
            return const Center(
              child: Text(
                'You have no orders yet!',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              final newOrders = loadOrders();

              setState(() {
                ordersFuture = newOrders;
              });

              await newOrders;
            },

            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: orders.length,

              itemBuilder: (context, index) {
                final order = orders[index];

                final items = List<dynamic>.from(order['items'] ?? []);

                return Card(
                  margin: const EdgeInsets.only(bottom: 15),
                  elevation: 3,

                  child: Padding(
                    padding: const EdgeInsets.all(15),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          'Order #${order['id']}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text('Date: ${formatDate(order['created_at'])}'),

                        const Divider(),

                        const Text(
                          'Products:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),

                        ...items.map((item) {
                          final product = Map<String, dynamic>.from(item);

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),

                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,

                              children: [
                                Expanded(
                                  child: Text(product['name'] ?? 'Product'),
                                ),

                                Text('৳${product['price']}'),
                              ],
                            ),
                          );
                        }),

                        const Divider(),

                        Align(
                          alignment: Alignment.centerRight,

                          child: Text(
                            'Total: ৳${order['total']}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.pink,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
