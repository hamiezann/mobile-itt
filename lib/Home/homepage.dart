import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Nash Cafe'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Image.asset('assets/logo.jpeg', height: 100), // Your logo here
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Handle login button press
                },
                child: Text('Login'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register'); // Navigate to RegisterScreen
                },
                child: Text('Register'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
              SizedBox(height: 20),
              _buildButton(context, 'Order', Icons.shopping_cart),
              _buildButton(context, 'Contact Us', Icons.contact_mail),
              _buildButton(context, 'Offers', Icons.local_offer),
              _buildButton(context, 'Feedback', Icons.feedback),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: () {
          // Handle button press
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[800],
          minimumSize: Size(double.infinity, 50),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white),
            SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
