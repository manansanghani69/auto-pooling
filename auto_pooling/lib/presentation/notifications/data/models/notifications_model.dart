import 'package:json_annotation/json_annotation.dart';

part 'notifications_model.g.dart';

@JsonSerializable()
class NotificationsModel {
  const NotificationsModel();

  factory NotificationsModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationsModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationsModelToJson(this);
}
