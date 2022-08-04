import 'package:background_location/gen/assets.gen.dart';
import 'package:background_location/widgets/dialogs/status_dialog_new.dart';
import 'package:flutter/material.dart';

class MailSentDialog extends StatelessWidget {
  final String message;
  final VoidCallback onContinue;

  const MailSentDialog({Key? key, required this.message, required this.onContinue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatusDialog(
      lottieAsset: Assets.animations.mailSent,
      message: message,
      onContinue: onContinue,
    );
  }
}
