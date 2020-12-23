class ReqPayAppointmnet {
  final String appointmentId;
  final String token;
  final String amount;
  final String customer;
  ReqPayAppointmnet({
    this.appointmentId,
    this.token,
    this.amount,
    this.customer,
  });

  Map<String, dynamic> toMap() {
    return {
      'appointmentId': appointmentId,
      'token': token,
      'amount': amount,
      'customer': customer,
    };
  }
}
