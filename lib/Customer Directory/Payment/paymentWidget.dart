

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:itt632_nashcafe/Configuration/networkConfig.dart';
import 'package:itt632_nashcafe/Splash%20Screen/homepage.dart';

import '../Order/orderhistory.dart';

class PaymentService {
  static Future<String?> createPaymentIntent(double amount) async {
    try {
      final response = await http.post(
        Uri.parse('${Config.apiUrl}/create-payment-intent'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'amount': (amount * 100).toInt()}), // amount in cents
      );

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        return body['client_secret'];
      } else {
        throw Exception('Failed to create PaymentIntent');
      }
    } catch (e) {
      print('Error creating PaymentIntent: $e');
      return null;
    }
  }

  static Future<void> processPayment(double amount, BuildContext context) async {
    try {
      final clientSecret = await createPaymentIntent(amount);
      if (clientSecret == null) {
        throw Exception('Failed to process PaymentIntent');
      }

      // Initialize payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Nash Cafe',
        ),
      );

      // Present payment sheet
      await Stripe.instance.presentPaymentSheet();

      // Redirect to order details page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );

      print('Payment successful');
    } catch (e) {
      print('Payment failed: $e');
    }
  }

}
