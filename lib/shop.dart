import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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
          isSock: data['isSock'] ?? false,
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
              'Shop',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Divider(
              color: Color.fromARGB(255, 119, 0, 50),
              thickness: 3,
            ),
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

class ProductDetails extends StatefulWidget {
  final Product product;

  const ProductDetails({super.key, required this.product});

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  String _selectedSize = 'M'; // Default size
  int _quantity = 1; // Default quantity
  final TextEditingController _addressController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedFile; // Holds the selected file

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( // Add this to make the content scrollable
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.product.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              widget.product.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            if (!widget.product.isSock) ...[
              const Text(
                'Select Size:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              DropdownButton<String>(
                value: _selectedSize,
                onChanged: (String? newSize) {
                  setState(() {
                    _selectedSize = newSize!;
                  });
                },
                items: ['S', 'M', 'L', 'XL', 'XXL']
                    .map((size) => DropdownMenuItem(value: size, child: Text(size)))
                    .toList(),
              ),
              const SizedBox(height: 20),
            ],
            const Text(
              'Select Quantity:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: _quantity > 1
                      ? () {
                          setState(() {
                            _quantity--;
                          });
                        }
                      : null,
                ),
                Text('$_quantity', style: const TextStyle(fontSize: 16)),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      _quantity++;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Enter Delivery Address:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Delivery Address',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            const Text(
              'Upload Proof of Payment:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _pickFile,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 119, 0, 50),
                textStyle: const TextStyle(color: Colors.white),
              ),
              child: const Text('Pick File'),
            ),
            if (_selectedFile != null) ...[
              Text('Selected File: ${_selectedFile!.name}'),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _navigateToQR(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 119, 0, 50),
                textStyle: const TextStyle(color: Colors.white),
              ),
              child: const Text('Proceed to Payment'),
            ),
          ],
        ),
      ),
    );
  }

  void _pickFile() async {
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _selectedFile = file;
    });
  }

  void _navigateToQR(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QRPage(
          selectedSize: _selectedSize,
          quantity: _quantity,
          product: widget.product, // Pass the product here
          deliveryAddress: _addressController.text, // Pass the address
          selectedFile: _selectedFile, // Pass the selected file
        ),
      ),
    );
  }
}

class QRPage extends StatefulWidget {
  final String selectedSize;
  final int quantity;
  final Product product;
  final String deliveryAddress;
  final XFile? selectedFile; // Add this to hold the file

  const QRPage({
    super.key,
    required this.selectedSize,
    required this.quantity,
    required this.product,
    required this.deliveryAddress,
    required this.selectedFile, // Receive file here
  });

  @override
  _QRPageState createState() => _QRPageState();
}

class _QRPageState extends State<QRPage> {
  double _calculateTotalPrice() {
    double price = double.tryParse(widget.product.price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
    if (widget.product.isDiscounted) {
      double discountedPrice = double.tryParse(widget.product.discountedPrice.replaceAll(RegExp(r'[^0-9.]'), '')) ?? price;
      return discountedPrice * widget.quantity;
    }
    return price * widget.quantity;
  }

  Future<void> _uploadProof(BuildContext context) async {
    try {
      // Remove the file check to always proceed with the upload
      if (widget.selectedFile != null) {
        // Convert XFile to File
        final file = File(widget.selectedFile!.path);

        // Upload the file to Firebase Storage
        FirebaseStorage storage = FirebaseStorage.instance;
        Reference ref = storage.ref().child('paymentProofs/${widget.selectedFile!.name}');
        UploadTask uploadTask = ref.putFile(file);

        // Get the URL of the uploaded file
        String fileURL = await (await uploadTask).ref.getDownloadURL();

        // Save payment data to Firestore
        var paymentData = {
          'quantity': widget.quantity,
          'price': widget.product.price,
          'totalPrice': _calculateTotalPrice(),
          'proof': fileURL, // Store the file URL
          'address': widget.deliveryAddress,
          'name': widget.product.name,
        };

        if (!widget.product.isSock) {
          paymentData['size'] = widget.selectedSize;
        }

        await FirebaseFirestore.instance.collection('payments').add(paymentData);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment proof uploaded successfully!')),
        );
      } else {
        // Proceed without file if no file is selected (force success)
        var paymentData = {
          'quantity': widget.quantity,
          'price': widget.product.price,
          'totalPrice': _calculateTotalPrice(),
          'proof': '', // If no file selected, store an empty proof
          'address': widget.deliveryAddress,
          'name': widget.product.name,
        };

        if (!widget.product.isSock) {
          paymentData['size'] = widget.selectedSize;
        }

        await FirebaseFirestore.instance.collection('payments').add(paymentData);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment information saved successfully')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading proof: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = _calculateTotalPrice();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Summary'),
        backgroundColor: const Color.fromARGB(255, 119, 0, 50),
        titleTextStyle: const TextStyle(fontSize: 24, color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Summary',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text('Product: ${widget.product.name}'),
            Text('Quantity: ${widget.quantity}'),
            if (widget.product.isDiscounted)
              Text('Discounted Price: ${widget.product.discountedPrice}'),
            Text('Total Price: $totalPrice'),
            const SizedBox(height: 20),
            const Text(
              'QR Code for Payment',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Image.asset('assets/image/qr.jpg'), // Display the QR image here
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _uploadProof(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 119, 0, 50),
                textStyle: const TextStyle(color: Colors.white),
              ),
              child: const Text('Upload Payment Proof'),
            ),
          ],
        ),
      ),
    );
  }
}


class Product {
  final String name;
  final String price;
  final String discountedPrice;
  final bool isDiscounted;
  final String imagePath;
  final String description;
  final bool isSock;

  Product({
    required this.name,
    required this.price,
    required this.discountedPrice,
    required this.isDiscounted,
    required this.imagePath,
    required this.description,
    required this.isSock,
  });
}
