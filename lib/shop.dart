import 'package:flutter/material.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop'),
        backgroundColor: const Color.fromARGB(255, 119, 0, 50),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset('assets/image/shop_banner.jpg', fit: BoxFit.cover), 
              const SizedBox(height: 20),
              const Text(
                'Most Popular',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.7,
                ),
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Card(
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
                            child: Image.asset(
                              product.imagePath,
                              fit: BoxFit.cover,
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
                  );
                },
              ),
            ],
          ),
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

  Product({
    required this.name,
    required this.price,
    required this.discountedPrice,
    required this.isDiscounted,
    required this.imagePath,
  });
}

final List<Product> products = [
  Product(
    name: 'JomRun Cycling Jersey - Classic',
    price: 'RM150.00',
    discountedPrice: '',
    isDiscounted: false,
    imagePath: 'assets/image/cycling_jersey.jpg',
  ),
  Product(
    name: 'JomRun X Ultron Batik Collection - Tribal',
    price: 'RM100.00',
    discountedPrice: 'RM29.90',
    isDiscounted: true,
    imagePath: 'assets/image/batik_collection.jpg',
  ),
  Product(
    name: 'Malaysia Batik T-Shirt',
    price: 'RM70.00',
    discountedPrice: 'RM50.00',
    isDiscounted: true,
    imagePath: 'assets/image/malaysia_batik.jpg',
  ),
  Product(
    name: 'JomRun Socks',
    price: 'RM29.90',
    discountedPrice: '',
    isDiscounted: false,
    imagePath: 'assets/image/socks.jpg',
  ),
];
