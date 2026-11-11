import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login_page.dart';
import 'addproduct_page.dart';
import 'editproduct_page.dart';
import 'cart_page.dart';
import 'orders_page.dart';
import 'admin_order_page.dart';
import 'productdetails_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final supabase = Supabase.instance.client;
  final searchController = TextEditingController();

  String selectedCategory = 'All';

  List<Map<String, dynamic>> cartItems = [];

  late Future<List<Map<String, dynamic>>> productsFuture;

  bool isAdmin = false;
  bool isCheckingRole = true;

  @override
  void initState() {
    super.initState();

    productsFuture = loadProducts();
    checkUserRole();
  }

  // Check Admin or Customer
  Future<void> checkUserRole() async {
    try {
      final user = supabase.auth.currentUser;

      if (user == null) return;

      final response = await supabase
          .from('profiles')
          .select('role')
          .eq('id', user.id)
          .maybeSingle();

      if (!mounted) return;

      setState(() {
        isAdmin = response?['role'] == 'admin';
        isCheckingRole = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isAdmin = false;
        isCheckingRole = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Role checking failed: $e')));
    }
  }

  // Read Products
  Future<List<Map<String, dynamic>>> loadProducts() async {
    final response = await supabase
        .from('products')
        .select()
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  // Refresh Products
  void refreshProducts() {
    setState(() {
      productsFuture = loadProducts();
    });
  }

  // Delete Product
  Future<void> deleteProduct(Map<String, dynamic> product) async {
    if (!isAdmin) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Product'),
          content: Text('Are you sure you want to delete ${product['name']}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      try {
        await supabase.from('products').delete().eq('id', product['id']);

        if (!mounted) return;

        refreshProducts();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product deleted successfully!')),
        );
      } catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Delete failed: $e')));
      }
    }
  }

  // Edit Product
  Future<void> editProduct(Map<String, dynamic> product) async {
    if (!isAdmin) return;

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return EditProductPage(product: product);
        },
      ),
    );

    if (result == true) {
      refreshProducts();
    }
  }

  // Add Product
  Future<void> openAddProduct() async {
    if (!isAdmin) return;

    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddProductPage()),
    );

    if (result == true) {
      refreshProducts();
    }
  }

  // Open Cart
  Future<void> openCart() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return CartPage(cartItems: cartItems);
        },
      ),
    );

    if (!mounted) return;

    setState(() {});
  }

  // Add to Cart
  void addToCart(Map<String, dynamic> product) {
    setState(() {
      cartItems.add(product);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product['name']} added to cart!'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // Open Orders
  void openOrders() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const OrdersPage()),
    );
  }

  // Open Product Details
  void openProductDetails(Map<String, dynamic> product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsPage(
          product: product,
          onAddToCart: () => addToCart(product),
        ),
      ),
    );
  }

  // Open Admin Orders
  void openAdminOrders() {
    if (!isAdmin) return;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AdminOrdersPage()),
    );
  }

  // Logout
  Future<void> logout() async {
    await supabase.auth.signOut();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F7),

      appBar: AppBar(
        title: const Text(
          "TaRa's Corner",
          style: TextStyle(
            color: Color(0xFF514064),
            fontWeight: FontWeight.bold,
          ),
        ),

        backgroundColor: const Color(0xFFE6DDF5),

        iconTheme: const IconThemeData(color: Color(0xFF514064)),

        actions: [
          // My Orders
          IconButton(
            icon: const Icon(Icons.receipt_long),
            tooltip: 'My Orders',
            onPressed: openOrders,
          ),
          // Manage Orders - Admin Only
          if (!isCheckingRole && isAdmin)
            IconButton(
              icon: const Icon(Icons.inventory),
              tooltip: 'Manage Orders',
              onPressed: openAdminOrders,
            ),

          // Cart
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: openCart,
              ),

              if (cartItems.isNotEmpty)
                Positioned(
                  right: 5,
                  top: 5,
                  child: CircleAvatar(
                    radius: 9,
                    backgroundColor: Colors.red,
                    child: Text(
                      '${cartItems.length}',
                      style: const TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),

          // Refresh
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: refreshProducts,
          ),

          // Add Product - Admin Only
          if (!isCheckingRole && isAdmin)
            IconButton(
              icon: const Icon(Icons.add_box),
              tooltip: 'Add Product',
              onPressed: openAddProduct,
            ),

          // Logout
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: logout,
          ),
        ],
      ),

      body: Column(
        children: [
          const SizedBox(height: 15),

          // Welcome Text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                isCheckingRole
                    ? "Welcome to TaRa's Corner!"
                    : isAdmin
                    ? "Welcome, Admin!"
                    : "Welcome, Customer!",
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF514064),
                ),
              ),
            ),
          ),

          const SizedBox(height: 5),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                isAdmin
                    ? 'Manage your jewellery and beauty products.'
                    : 'Discover your favourite jewellery and beauty products.',
                style: const TextStyle(color: Color(0xFF514064)),
              ),
            ),
          ),

          const SizedBox(height: 15),

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {});
              },
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Category Filter
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['All', 'Jewellery', 'Beauty'].map((category) {
                final isSelected = selectedCategory == category;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    selectedColor: const Color(0xFFDCCBF0),
                    backgroundColor: Colors.white,
                    labelStyle: const TextStyle(color: Color(0xFF514064)),
                    onSelected: (selected) {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 10),

          // Product List
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: productsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error loading products: ${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                final products = snapshot.data ?? [];

                // Search and Category Filter
                final filteredProducts = products.where((product) {
                  final name = product['name'].toString().toLowerCase();

                  final searchText = searchController.text.toLowerCase();

                  final categoryMatches =
                      selectedCategory == 'All' ||
                      product['category'].toString().toLowerCase() ==
                          selectedCategory.toLowerCase();

                  final searchMatches = name.contains(searchText);

                  return categoryMatches && searchMatches;
                }).toList();

                if (filteredProducts.isEmpty) {
                  return const Center(
                    child: Text(
                      'No products found!',
                      style: TextStyle(fontSize: 17, color: Color(0xFF514064)),
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: filteredProducts.length,

                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.62,
                  ),

                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];

                    return Card(
                      color: Colors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(15),
                        onTap: () {
                          openProductDetails(product);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              // Product Icon
                              Expanded(
                                child: Center(
                                  child: Icon(
                                    product['category']
                                                .toString()
                                                .toLowerCase() ==
                                            'beauty'
                                        ? Icons.spa
                                        : Icons.diamond,
                                    size: 65,
                                    color: const Color(0xFFC5A45D),
                                  ),
                                ),
                              ),

                              // Product Name
                              Text(
                                product['name'].toString(),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Color(0xFF514064),
                                ),
                              ),

                              const SizedBox(height: 5),

                              // Category
                              Text(
                                product['category'].toString(),
                                style: const TextStyle(color: Colors.grey),
                              ),

                              const SizedBox(height: 5),

                              // Price
                              Text(
                                '৳ ${product['price']}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFC5A45D),
                                ),
                              ),

                              const SizedBox(height: 8),

                              // Add to Cart
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFDCCBF0),
                                    foregroundColor: const Color(0xFF514064),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                  ),

                                  onPressed: () {
                                    addToCart(product);
                                  },

                                  child: const Text('Add to Cart'),
                                ),
                              ),

                              const SizedBox(height: 4),

                              // Edit and Delete - Admin Only
                              if (!isCheckingRole && isAdmin)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Color(0xFF514064),
                                      ),
                                      tooltip: 'Edit Product',
                                      onPressed: () {
                                        editProduct(product);
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      tooltip: 'Delete Product',
                                      onPressed: () {
                                        deleteProduct(product);
                                      },
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
