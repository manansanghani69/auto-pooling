import 'package:json_annotation/json_annotation.dart';

part 'payments_model.g.dart';

@JsonSerializable()
class PaymentsModel {
  const PaymentsModel();

  factory PaymentsModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentsModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentsModelToJson(this);
}
