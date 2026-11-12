import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();

  final supabase = Supabase.instance.client;
  final ImagePicker picker = ImagePicker();

  String category = 'Jewellery';

  XFile? selectedImage;
  bool isLoading = false;

  // Select image from computer
  Future<void> pickProductImage() async {
    try {
      final image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null && mounted) {
        setState(() {
          selectedImage = image;
        });
      }
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Image selection error: $error')));
    }
  }

  // Upload image to Supabase Storage
  Future<String?> uploadProductImage() async {
    if (selectedImage == null) return null;

    final bytes = await selectedImage!.readAsBytes();

    final extension = selectedImage!.name.split('.').last.toLowerCase();

    final fileName = '${DateTime.now().millisecondsSinceEpoch}.$extension';

    final contentType = extension == 'png'
        ? 'image/png'
        : extension == 'webp'
        ? 'image/webp'
        : 'image/jpeg';

    await supabase.storage
        .from('product-images')
        .uploadBinary(
          fileName,
          bytes,
          fileOptions: FileOptions(contentType: contentType),
        );

    return supabase.storage.from('product-images').getPublicUrl(fileName);
  }

  // Add product to database
  Future<void> addProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      final user = Supabase.instance.client.auth.currentUser;

      debugPrint('CURRENT USER ID: ${user?.id}');
      debugPrint('CURRENT USER EMAIL: ${user?.email}');
      // Upload image first
      final imageUrl = await uploadProductImage();

      // Insert product into database
      await supabase.from('products').insert({
        'name': nameController.text.trim(),
        'description': descriptionController.text.trim(),
        'price': double.parse(priceController.text.trim()),
        'category': category,
        'image_url': imageUrl,
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product added successfully!')),
      );

      Navigator.pop(context, true);
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $error')));
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F7),

      appBar: AppBar(
        title: const Text('Add New Product'),
        backgroundColor: const Color(0xFFE6DDF5),
        foregroundColor: const Color(0xFF514064),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: _formKey,

          child: Column(
            children: [
              const Icon(
                Icons.add_shopping_cart,
                size: 75,
                color: Color(0xFFC5A45D),
              ),

              const SizedBox(height: 20),

              // Image Preview
              GestureDetector(
                onTap: isLoading ? null : pickProductImage,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6DDF5),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: const Color(0xFFC5A45D),
                      width: 1.5,
                    ),
                  ),
                  child: selectedImage == null
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate,
                              size: 55,
                              color: Color(0xFF514064),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Select Product Image',
                              style: TextStyle(
                                color: Color(0xFF514064),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: FutureBuilder(
                            future: selectedImage!.readAsBytes(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Image.memory(
                                  snapshot.data!,
                                  width: double.infinity,
                                  height: 200,
                                  fit: BoxFit.cover,
                                );
                              }

                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 10),

              TextButton.icon(
                onPressed: isLoading ? null : pickProductImage,
                icon: const Icon(Icons.image),
                label: const Text('Choose Image'),
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                  prefixIcon: Icon(Icons.shopping_bag),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter product name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Product Description',
                  prefixIcon: Icon(Icons.description),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: priceController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Price (৳)',
                  prefixIcon: Icon(Icons.currency_exchange),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final price = double.tryParse(value ?? '');

                  if (price == null || price <= 0) {
                    return 'Enter a valid price';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 15),

              DropdownButtonFormField<String>(
                initialValue: category,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  prefixIcon: Icon(Icons.category),
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Jewellery',
                    child: Text('Jewellery'),
                  ),
                  DropdownMenuItem(value: 'Beauty', child: Text('Beauty')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      category = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : addProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDCCBF0),
                    foregroundColor: const Color(0xFF514064),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                          'ADD PRODUCT',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
