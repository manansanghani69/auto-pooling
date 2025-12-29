import 'package:json_annotation/json_annotation.dart';

part 'ride_request_model.g.dart';

@JsonSerializable()
class RideRequestModel {
  const RideRequestModel();

  factory RideRequestModel.fromJson(Map<String, dynamic> json) =>
      _$RideRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$RideRequestModelToJson(this);
}
