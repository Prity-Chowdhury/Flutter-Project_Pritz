import 'package:flutter/material.dart';

class ProductDetailsPage extends StatelessWidget {
  final Map<String, dynamic> product;
  final VoidCallback onAddToCart;

  const ProductDetailsPage({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F7),
      appBar: AppBar(
        title: const Text('Product Details'),
        backgroundColor: const Color(0xFFE6DDF5),
        foregroundColor: const Color(0xFF514064),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 280,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFE6DDF5),
                borderRadius: BorderRadius.circular(20),
              ),

              child:
                  product['image_url'] != null &&
                      product['image_url'].toString().isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        product['image_url'].toString(),
                        width: double.infinity,
                        height: 280,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.broken_image,
                            size: 110,
                            color: Color(0xFFC5A45D),
                          );
                        },
                      ),
                    )
                  : Icon(
                      product['category'].toString().toLowerCase() == 'beauty'
                          ? Icons.spa
                          : Icons.diamond,
                      size: 110,
                      color: const Color(0xFFC5A45D),
                    ),
            ),
            const SizedBox(height: 25),
            Text(
              product['name'].toString(),
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color(0xFF514064),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Category: ${product['category']}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 15),
            Text(
              '৳ ${product['price']}',
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color(0xFFC5A45D),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Product Description',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Color(0xFF514064),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product['description']?.toString().isNotEmpty == true
                  ? product['description'].toString()
                  : 'A beautiful product from TaRa\'s Corner. '
                        'Thank you for choosing us!',
              style: const TextStyle(
                fontSize: 15,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: onAddToCart,
                icon: const Icon(Icons.shopping_cart),
                label: const Text(
                  'Add to Cart',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDCCBF0),
                  foregroundColor: const Color(0xFF514064),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
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
