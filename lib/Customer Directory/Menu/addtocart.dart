import 'package:flutter/material.dart';
import 'package:itt632_nashcafe/Customer%20Directory/Payment/paymentWidget.dart';
import '../Cart/cartModel.dart';
import '../Cart/cartState.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartService _cartService = CartService();
  List<CartItem> cartItems = [];

  @override
  void initState() {
    super.initState();
    loadCartItems();
  }

  Future<void> loadCartItems() async {
    final items = await _cartService.getCartItems();
    setState(() {
      cartItems = items;
    });
  }

  Future<void> updateCartItem(CartItem item, bool isAdd) async {
    if (isAdd) {
      await _cartService.addToCart(item);
    } else {
      await _cartService.removeFromCart(item.id);
    }
    await loadCartItems();
  }

  Future<void> removeFromCart(CartItem item) async {
    setState(() {
      cartItems.remove(item);
    });
    await _cartService.removeFromCart(item.id); // Remove item from SharedPreferences
    await loadCartItems(); // Reload cart items to reflect changes
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Text(
                  'Your Cart',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  height: 300, // Adjust height as needed
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return CartItemCard(
                        title: item.name,
                        imageUrl: item.imageUrl,
                        subtitle: 'Quantity: ${item.quantity}',
                        totalPrice: item.price * item.quantity,
                        onAdd: () async {
                          setState(() {
                            item.quantity++;
                          });
                          await _cartService.addToCart(item);
                          await loadCartItems();
                        },
                        onTrash: () async {
                          await removeFromCart(item);
                        },
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                AddressSection(),
                SizedBox(height: 20),
                SummarySection(cartItems: cartItems),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFFA726),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () async {
                    double totalAmount = cartItems.fold(0, (sum, item) => sum + item.price *item.quantity);
                    await PaymentService.processPayment(totalAmount,context);
                  },
                  child: Center(child: Text('Place Order')),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CartItemCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String subtitle;
  final double totalPrice;
  final VoidCallback onAdd;
  final VoidCallback onTrash;

  CartItemCard({
    required this.title,
    required this.imageUrl,
    required this.subtitle,
    required this.totalPrice,
    required this.onAdd,
    required this.onTrash,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(width: 10),
          Image.network(
            imageUrl,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.remove),
                    color: Colors.white,
                    // onPressed: onRemove,
                    onPressed: onTrash,
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    color: Colors.white,
                    onPressed: onAdd,
                  ),
                ],
              ),
            ],
          ),
          Spacer(),
          Text(
            '\RM${totalPrice.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class AddressSection extends StatefulWidget {
  @override
  _AddressSectionState createState() => _AddressSectionState();
}

class _AddressSectionState extends State<AddressSection> {
  String orderType = 'dine_in'; // Default to pickup
  String orderAddress = '140 Roadway Ave.'; // Example default address
  String tableNumber = ''; // Variable to store table number for dine-in

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(Icons.location_on),
              SizedBox(width: 10),
              DropdownButton<String>(
                value: orderType,
                items: [
                  DropdownMenuItem(
                    value: 'pickup',
                    child: Text('Pickup'),
                  ),
                  DropdownMenuItem(
                    value: 'dine_in',
                    child: Text('Dine In'),
                  ),
                  DropdownMenuItem(
                    value: 'delivery',
                    child: Text('Delivery'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    orderType = value!;
                  });
                },
              ),
              Spacer(),
                  // IconButton(
                  //   icon: Icon(Icons.edit),
                  //   onPressed: () {
                  //     // Handle editing logic here
                  //   },
                  // ),
            ],
          ),
          if (orderType == 'delivery') ...[
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: 'Delivery Address',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  orderAddress = value;
                });
              },
            ),
          ] else if (orderType == 'dine_in') ...[
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: 'Table Number',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  tableNumber = value;
                });
              },
            ),
          ] else if (orderType == 'pickup') ...[
            SizedBox(height: 10),
            Text(
              'Pickup from store',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ],
          SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.timer),
              SizedBox(width: 10),
              Text('25-30 min (ASAP)'),
              Spacer(),
              // Icon(Icons.edit),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.attach_money),
              SizedBox(width: 10),
              Text('Bank Transfer'),
              Spacer(),
              // Icon(Icons.edit),
            ],
          ),
        ],
      ),
    );
  }
}

class SummarySection extends StatelessWidget {
  final List<CartItem> cartItems;

  SummarySection({required this.cartItems});

  double get totalAmount {
    double total = 0.0;
    for (var item in cartItems) {
      total += item.price * item.quantity;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Subtotal'),
              Text('\RM${totalAmount.toStringAsFixed(2)}'),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Delivery fee'),
              Text('\RM5.00'), // Example delivery fee
            ],
          ),
          SizedBox(height: 10),
          Divider(color: Colors.grey),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '\RM${(totalAmount + 5.00).toStringAsFixed(2)}', // Subtotal + delivery fee
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
