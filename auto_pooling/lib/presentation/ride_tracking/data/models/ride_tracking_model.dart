import 'package:json_annotation/json_annotation.dart';

part 'ride_tracking_model.g.dart';

@JsonSerializable()
class RideTrackingModel {
  const RideTrackingModel();

  factory RideTrackingModel.fromJson(Map<String, dynamic> json) =>
      _$RideTrackingModelFromJson(json);

  Map<String, dynamic> toJson() => _$RideTrackingModelToJson(this);
}
