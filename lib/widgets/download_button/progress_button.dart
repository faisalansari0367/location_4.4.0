// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bioplus/constants/index.dart';
import 'package:bioplus/widgets/download_button/download_controller.dart';
import 'package:flutter/material.dart';

class ProgressButton extends StatelessWidget {
  final DownloadController controller;
  final EdgeInsets? padding;
  final String? buttonText;
  const ProgressButton({
    super.key,
    required this.controller,
    this.padding,
    this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) => _ProgressButton(
        // padding: padding,
        status: controller.downloadStatus,
        // buttonTitle: buttonText,
        downloadProgress: controller.progress,
        // onDownload: controller.startDownload,
        // onOpen: controller.openDownload,
        // onCancel: controller.stopDownload,
        transitionDuration: 300.milliseconds,
      ),
    );
  }
}

class _ProgressButton extends StatelessWidget {
  const _ProgressButton({
    required this.status,
    required this.downloadProgress,
    required this.transitionDuration,
  });
  final DownloadStatus status;
  // final String? buttonTitle;
  final double downloadProgress;
  // final VoidCallback onDownload;
  // final EdgeInsets? padding;
  // final VoidCallback onCancel;
  // final VoidCallback onOpen;
  final Duration transitionDuration;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: transitionDuration,
      alignment: Alignment.topCenter,
      curve: kCurve,
      child: status.isDownloaded || status.isNotDownloaded
          ? const SizedBox.shrink()
          : LinearProgressIndicator(
              // color: CupertinoColors.activeBlue,
              value: status.isFetching ? null : downloadProgress,
            ),
    );
  }
}
