class MockPaymentResultModel {
  const MockPaymentResultModel({
    required this.approved,
    required this.authorizationCode,
    required this.transactionId,
    required this.maskedCardNumber,
    required this.paymentMethod,
    required this.cardholderName,
    required this.amount,
    required this.installments,
    required this.processedAt,
    this.message,
  });

  final bool approved;
  final String authorizationCode;
  final String transactionId;
  final String maskedCardNumber;
  final String paymentMethod;
  final String cardholderName;
  final double amount;
  final int installments;
  final DateTime processedAt;
  final String? message;
}
