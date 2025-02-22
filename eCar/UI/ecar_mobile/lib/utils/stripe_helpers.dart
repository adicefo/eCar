import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

Future<String> createStripeCustomer(
    String? email, String? name, String? surname) async {
  try {
    String stripeSecretKey = await dotenv.env['STRIPE_SECRET_KEY'] ?? '';
    if (stripeSecretKey.isEmpty) {
      print("Stripe secret key is not set in .env file");
    }
    var response = await http.post(
      Uri.parse('https://api.stripe.com/v1/customers'),
      body: {
        'email': email,
        'name': '${name} ${surname}',
      },
      headers: {
        'Authorization': 'Bearer $stripeSecretKey',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    );

    var customerResponse = jsonDecode(response.body);
    String customerId = customerResponse['id'];
    return customerId;
  } catch (err) {
    print('err creating stripe customer: ${err.toString()}');
    throw err;
  }
}

Future<Map<String, dynamic>> createPaymentIntent(
    String amount,
    String currency,
    String? customerEmail,
    String customerId,
    String? name,
    String? surname) async {
  try {
    String stripeSecretKey = await dotenv.env['STRIPE_SECRET_KEY'] ?? '';
    Map<String, dynamic> body = {
      'amount': calculateAmount(amount),
      'currency': currency,
      'payment_method_types[]': 'card',
      'customer': customerId,
      'receipt_email': customerEmail,
      'description': 'Payment for drive by ${name} ${surname}',
    };
    var response = await http.post(
      Uri.parse('https://api.stripe.com/v1/payment_intents'),
      body: body,
      headers: {
        'Authorization': 'Bearer $stripeSecretKey',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    );
    print('Create Intent reponse ===> ${response.body.toString()}');
    return jsonDecode(response.body);
  } catch (err) {
    print('err charging user: ${err.toString()}');
    throw err;
  }
}

Future<bool> confirmPaymentSheetPayment() async {
  try {
    await Stripe.instance.confirmPaymentSheetPayment();
    return true;
  } on StripeException catch (e) {
    print('Error confirming payment: $e');
    return false;
  }
}

String calculateAmount(String amount) {
  final double parsedAmount = double.parse(amount);
  final int multipliedAmount = (parsedAmount * 100).toInt();
  return multipliedAmount.toString();
}
