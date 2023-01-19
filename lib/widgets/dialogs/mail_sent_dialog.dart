import 'package:bioplus/gen/assets.gen.dart';
import 'package:bioplus/widgets/dialogs/status_dialog_new.dart';
import 'package:flutter/material.dart';

class MailSentDialog extends StatelessWidget {
  final String message;
  final VoidCallback onContinue;

  const MailSentDialog({super.key, required this.message, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return StatusDialog(
      lottieAsset: Assets.animations.mailSent,
      message: message,
      onContinue: onContinue,
    );
  }
}
