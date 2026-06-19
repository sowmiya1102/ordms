import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayService {
  late Razorpay _razorpay;

  Function(String paymentId)? onSuccess;
  Function(String error)? onFailure;

  void init() {
    _razorpay = Razorpay();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handleSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handleError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleWallet);
  }

  void openCheckout({
    required int amount,
    required String name,
    required String description,
  }) {
    var options = {
      'key': 'rzp_test_T3ZfDlgU7eiiti', // test key first
      'amount': amount * 100, // paise
      'name': name,
      'description': description,
      'prefill': {},
      'theme': {'color': '#2196F3'},
    };

    _razorpay.open(options);
  }

  void _handleSuccess(PaymentSuccessResponse response) {
    onSuccess?.call(response.paymentId ?? "");
  }

  void _handleError(PaymentFailureResponse response) {
    onFailure?.call(response.message ?? "Payment failed");
  }

  void _handleWallet(ExternalWalletResponse response) {}

  void dispose() {
    _razorpay.clear();
  }
}