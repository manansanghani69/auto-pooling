import 'package:auto_pooling_driver/presentation/onboarding/screens/document_upload/widgets/document_upload_body.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class DriverOnboardingDocumentUploadScreen extends StatelessWidget {
  const DriverOnboardingDocumentUploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DocumentUploadBody();
  }
}
