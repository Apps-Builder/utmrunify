import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class MyOrderPage extends StatefulWidget {
  const MyOrderPage({super.key});

  @override
  _MyOrderPageState createState() => _MyOrderPageState();
}

class _MyOrderPageState extends State<MyOrderPage> {
  List<Order> _orders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('payments')
          .get();

      if (querySnapshot.docs.isEmpty) {
        print('No orders found in Firestore.');
      }

      List<Order> fetchedOrders = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Order(
          name: data['name'] ?? 'No Name',
          price: data['price'] ?? 'No Price',
          quantity: data['quantity'] ?? 1,
          totalPrice: data['totalPrice'] ?? 0.0,
          deliveryAddress: data['address'] ?? 'No Address',
          proof: data['proof'] ?? '',
          size: data['size'] ?? 'N/A',
        );
      }).toList();

      setState(() {
        _orders = fetchedOrders;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching orders: $e');
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

    if (_orders.isEmpty) {
      return const Center(
        child: Text(
          'No orders found!',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and Divider on top
            const Text(
              'My Orders',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Divider(
              color: Color.fromARGB(255, 119, 0, 50),
              thickness: 3,
            ),
            // The ListView.builder with orders list
            Expanded(
              child: ListView.builder(
                itemCount: _orders.length,
                itemBuilder: (context, index) {
                  final order = _orders[index];
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.all(8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.name,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          Text('Price: ${order.price}'),
                          Text('Quantity: ${order.quantity}'),
                          Text('Size: ${order.size}'),
                          Text('Total Price: ${order.totalPrice}'),
                          const SizedBox(height: 10),
                          Text(
                            'Delivery Address:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(order.deliveryAddress),
                          const SizedBox(height: 10),
                          if (order.proof.isNotEmpty)
                            Column(
                              children: [
                                const Text(
                                  'Payment Proof:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Image.network(order.proof),
                              ],
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );

  }
}

class Order {
  final String name;
  final String price;
  final int quantity;
  final double totalPrice;
  final String deliveryAddress;
  final String proof;
  final String size;

  Order({
    required this.name,
    required this.price,
    required this.quantity,
    required this.totalPrice,
    required this.deliveryAddress,
    required this.proof,
    required this.size,
  });
}
