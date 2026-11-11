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

  // Load Customer Orders
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

  // Format Date
  String formatDate(dynamic date) {
    final parsedDate = DateTime.tryParse(date.toString());

    if (parsedDate == null) return 'Unknown date';

    return '${parsedDate.day}/${parsedDate.month}/${parsedDate.year}';
  }

  // Status Color
  Color getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;

      case 'Processing':
        return Colors.blue;

      case 'Delivered':
        return Colors.green;

      case 'Cancelled':
        return Colors.red;

      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F7),

      appBar: AppBar(
        title: const Text('My Orders'),
        backgroundColor: const Color(0xFFE6DDF5),
        foregroundColor: const Color(0xFF514064),
      ),

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
              setState(() {
                ordersFuture = loadOrders();
              });

              await ordersFuture;
            },

            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: orders.length,

              itemBuilder: (context, index) {
                final order = orders[index];

                final items = List<dynamic>.from(order['items'] ?? []);

                final status = order['status']?.toString() ?? 'Pending';

                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 15),
                  elevation: 3,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(15),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        // Order Number
                        Text(
                          'Order #${order['id']}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF514064),
                          ),
                        ),

                        const SizedBox(height: 5),

                        // Date
                        Text('Date: ${formatDate(order['created_at'])}'),

                        const SizedBox(height: 12),

                        // Order Status
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            const Text(
                              'Order Status:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),

                              decoration: BoxDecoration(
                                color: getStatusColor(
                                  status,
                                ).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(20),
                              ),

                              child: Text(
                                status,
                                style: TextStyle(
                                  color: getStatusColor(status),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const Divider(height: 25),

                        // Products
                        const Text(
                          'Products:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),

                        const SizedBox(height: 8),

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

                        const Divider(height: 25),

                        // Total
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
