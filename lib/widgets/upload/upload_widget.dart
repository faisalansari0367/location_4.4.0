// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bioplus/constants/index.dart';
import 'package:bioplus/theme/color_constants.dart';
import 'package:bioplus/ui/edec_forms/page/livestock_waybill/livestock_waybill.dart';
import 'package:bioplus/widgets/upload/upload_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class UploadProgress extends StatelessWidget {
  final SyncCvdController controller;
  const UploadProgress({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: controller,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: const _ProgressWidget(),
      ),
    );
  }
}

class _ProgressWidget extends StatelessWidget {
  const _ProgressWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        // color: Colors.white,
        // border: Border.all(width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 205, 202, 255).withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            const SizedBox(width: 10),
            const Expanded(
              child: ProgressIndicatorWidget(
                downloadProgress: 0.5,
                isFetching: true,
                isUploading: false,
              ),
            ),
            // const SizedBox(width: 20),
            const Spacer(),
            const ProgressText(),
            const Spacer(),

            // const SizedBox(width: 10),
            Lottie.asset(
              'assets/animations/folder-upload.json',
              fit: BoxFit.contain,
              width: 50,
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}

class ProgressText extends StatelessWidget {
  const ProgressText({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<SyncCvdController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Uploading File: ${provider.currentFile}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
          // style: ,
        ),
        Gap(5.h),
        Text(
          'Total Files: ${provider.totalFiles}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

class ProgressIndicatorWidget extends StatelessWidget {
  const ProgressIndicatorWidget({
    super.key,
    required this.downloadProgress,
    required this.isUploading,
    required this.isFetching,
  });

  final double downloadProgress;
  final bool isUploading;
  final bool isFetching;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: downloadProgress),
        duration: const Duration(milliseconds: 200),
        builder: (context, progress, child) {
          return Stack(
            alignment: Alignment.center,
            fit: StackFit.expand,
            children: [
              Center(
                child: Text(
                  isFetching ? '' : '${(progress * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              CircularProgressIndicator(
                backgroundColor: isUploading
                    ? CupertinoColors.lightBackgroundGray
                    : Colors.white,
                valueColor: AlwaysStoppedAnimation(
                  isFetching ? CupertinoColors.black : kPrimaryColor,
                ),
                strokeWidth: 2,
                value: isFetching ? null : progress,
              ),
            ],
          );
        },
      ),
    );
  }
}
