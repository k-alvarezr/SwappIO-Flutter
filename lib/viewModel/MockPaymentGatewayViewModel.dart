import 'dart:math';

import '../model/MockPaymentResultModel.dart';
import 'PaymentGatewayViewModel.dart';

class MockPaymentGatewayViewModel implements PaymentGatewayViewModel {
  final Random _random = Random();

  @override
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
  }) async {
    final normalizedName = cardholderName.trim();
    final digits = cardNumber.replaceAll(RegExp(r'\D'), '');
    final normalizedExpiry = expiryDate.trim();
    final normalizedCvv = cvv.trim();

    if (amount <= 0) {
      throw Exception('El monto del pago no es valido.');
    }
    if (normalizedName.isEmpty) {
      throw Exception('Ingresa el nombre del titular.');
    }
    if (digits.length < 16) {
      throw Exception('Ingresa un numero de tarjeta mock de 16 digitos.');
    }
    if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(normalizedExpiry)) {
      throw Exception('La fecha debe tener formato MM/AA.');
    }
    if (!RegExp(r'^\d{3,4}$').hasMatch(normalizedCvv)) {
      throw Exception('El CVV mock debe tener 3 o 4 digitos.');
    }

    await Future<void>.delayed(const Duration(milliseconds: 1400));

    if (digits.endsWith('0000')) {
      throw Exception('La pasarela mock rechazo la tarjeta. Usa una terminada en otro numero.');
    }

    final lastFour = digits.substring(digits.length - 4);
    final authorizationCode = 'MOCK-${100000 + _random.nextInt(899999)}';
    final transactionId = 'TX-${DateTime.now().millisecondsSinceEpoch}-$productId';

    return MockPaymentResultModel(
      approved: true,
      authorizationCode: authorizationCode,
      transactionId: transactionId,
      maskedCardNumber: '**** **** **** $lastFour',
      paymentMethod: paymentMethod,
      cardholderName: normalizedName,
      amount: amount,
      installments: installments,
      processedAt: DateTime.now(),
      message: 'Pago aprobado para $productName.',
    );
  }
}
