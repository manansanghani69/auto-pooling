import 'package:auto_pooling_driver/presentation/auth/domain/entities/otp_request_result.dart';

class OtpRequestResultModel extends OtpRequestResult {
  const OtpRequestResultModel({
    required super.expiresInSeconds,
    super.debugOtp,
  });

  factory OtpRequestResultModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> data =
        json['data'] as Map<String, dynamic>? ?? <String, dynamic>{};

    return OtpRequestResultModel(
      expiresInSeconds: (data['expiresIn'] as num?)?.toInt() ?? 0,
      debugOtp: data['otp']?.toString(),
    );
  }
}
