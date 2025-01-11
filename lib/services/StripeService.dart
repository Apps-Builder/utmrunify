import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import '../consts.dart';

class StripeService {
  StripeService._();

  static final StripeService instance = StripeService._();

  Future<bool> makePayment(int subtotal) async {
    try {
      String? paymentIntentClientSecret = await _createPaymentIntent(
        subtotal,
        "myr",
      );
      if (paymentIntentClientSecret == null) return false;
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: "UTM RUNIFY",
        ),
      );

      if (await _processPayment()) {
        return true;
      } else {
        return false;
      }

    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<String?> _createPaymentIntent(int amount, String currency) async {
    try {
      final Dio dio = Dio();
      Map<String, dynamic> data = {
        "amount": _calculateAmount(
          amount,
        ),
        "currency": currency,
      };
      var response = await dio.post(
        "https://api.stripe.com/v1/payment_intents",
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            "Authorization": "Bearer $stripeSecretKey",
            "Content-Type": 'application/x-www-form-urlencoded'
          },
        ),
      );
      if (response.data != null) {
        return response.data["client_secret"];
      }
      return null;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<bool> _processPayment() async {
    try {
      await Stripe.instance.presentPaymentSheet();

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  String _calculateAmount(int amount) {
    final calculatedAmount = amount * 100;
    return calculatedAmount.toString();
  }
}
