import '../model/MockPaymentResultModel.dart';

abstract class PaymentGatewayViewModel {
  Future<MockPaymentResultModel> authorizePayment({
    required double amount,
    required String productId,
    required String productName,
    required String paymentMethod,
    required String cardholderName,
    required String cardNumber,
    required String expiryDate,
    required String cvv,
    required int installments,
  });
}
