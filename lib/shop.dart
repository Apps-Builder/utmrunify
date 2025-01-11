import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Ensure Firebase is initialized
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shop App',
      theme: ThemeData(primarySwatch: Colors.pink),
      home: const ShopPage(),
    );
  }
}

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop'),
        backgroundColor: const Color.fromARGB(255, 119, 0, 50),
        titleTextStyle: const TextStyle(fontSize: 24, color: Colors.white),
        leading: null,
      ),
      body: const ProductList(),
    );
  }
}

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final CollectionReference _collectionRef = FirebaseFirestore.instance
      .collection('shop')
      .doc('shopDB')
      .collection('larianseloka');
  List<Product> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      QuerySnapshot querySnapshot = await _collectionRef.get();

      if (querySnapshot.docs.isEmpty) {
        print('No products found in Firestore.');
      }

      List<Product> fetchedProducts = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        print('Fetched product: $data');
        return Product(
          name: data['name'] ?? 'No Name',
          price: data['price'] ?? 'No Price',
          discountedPrice: data['discountedPrice'] ?? '',
          isDiscounted: data['isDiscounted'] ?? false,
          imagePath: data['imagePath'] ?? '',
          description: data['description'] ?? 'No Description',
        );
      }).toList();

      setState(() {
        _products = fetchedProducts;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching products: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_products.isEmpty) {
      return const Center(
        child: Text(
          'No products available!',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Most Popular',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.7,
              ),
              itemBuilder: (context, index) {
                final product = _products[index];
                return GestureDetector(
                  onTap: () => _showProductDetails(context, product),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                            child: product.imagePath.startsWith('http')
                                ? Image.network(
                                    product.imagePath,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        const Icon(Icons.image_not_supported),
                                  )
                                : Image.asset(
                                    product.imagePath,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        const Icon(Icons.image_not_supported),
                                  ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                product.price,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: product.isDiscounted ? Colors.red : Colors.black,
                                  decoration: product.isDiscounted ? TextDecoration.lineThrough : null,
                                ),
                              ),
                              if (product.isDiscounted)
                                Text(
                                  product.discountedPrice,
                                  style: const TextStyle(fontSize: 14, color: Colors.green),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showProductDetails(BuildContext context, Product product) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ProductDetails(product: product);
      },
    );
  }
}

class ProductDetails extends StatelessWidget {
  final Product product;

  const ProductDetails({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            product.name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            product.description,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _navigateToQR(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 119, 0, 50),
            ),
            child: const Text('Buy Now'),
          ),
        ],
      ),
    );
  }

  void _navigateToQR(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const QRPage()),
    );
  }
}

class QRPage extends StatelessWidget {
  const QRPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Payment Proof'),
        backgroundColor: const Color.fromARGB(255, 119, 0, 50),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/image/qr.jpg',
              width: 400,
              height: 400,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _uploadProof(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 119, 0, 50),
              ),
              child: const Text('Upload Proof of Payment'),
            ),
          ],
        ),
      ),
    );
  }

  void _uploadProof(BuildContext context) async {
    try {
      await FirebaseFirestore.instance.collection('payments').add({
        'proof': 'uploaded_file_url', // Replace with actual file URL
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment proof uploaded successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading proof: $e')),
      );
    }
  }
}

class Product {
  final String name;
  final String price;
  final String discountedPrice;
  final bool isDiscounted;
  final String imagePath;
  final String description;

  Product({
    required this.name,
    required this.price,
    required this.discountedPrice,
    required this.isDiscounted,
    required this.imagePath,
    required this.description,
  });
}
