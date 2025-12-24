enum PaymentsStatus {
  initial,
}

class PaymentsState {
  final PaymentsStatus status;

  const PaymentsState({required this.status});

  factory PaymentsState.initial() =>
      const PaymentsState(status: PaymentsStatus.initial);

  PaymentsState copyWith({PaymentsStatus? status}) {
    return PaymentsState(status: status ?? this.status);
  }
}
