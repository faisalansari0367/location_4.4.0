import 'dart:convert';
import 'dart:typed_data';

import 'package:background_location/constants/index.dart';
import 'package:background_location/extensions/size_config.dart';
import 'package:background_location/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:signature/signature.dart';

import '../my_appbar.dart';

class SignatureWidget extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final String? signature;
  const SignatureWidget({Key? key, this.onChanged, this.signature}) : super(key: key);

  @override
  State<SignatureWidget> createState() => _SignatureWidgetState();
}

class _SignatureWidgetState extends State<SignatureWidget> {
  Uint8List? _image;
  bool showImage = false;

  @override
  void initState() {
    if (widget.signature != null) {
      try {
        _image = base64Decode(widget.signature!);
        showImage = true;
      } on Exception {}
    }
    super.initState();
  }

  void onDone(Uint8List? signature) {
    if (signature != null) {
      setState(() {
        _image = signature;
        showImage = true;
      });
      final file = base64Encode(signature);
      widget.onChanged?.call(file);
    }
  }

  @override
  Widget build(BuildContext context) {
    print(_image?.length);
    // print((1.sh / 1.sw));/
    if (showImage) {
      return Stack(
        children: [
          Container(
            clipBehavior: Clip.antiAlias,
            width: double.infinity,

            decoration: MyDecoration.decoration(),
            // margin: EdgeInsets.all(10),
            child: Image.memory(
              _image!,
              // controller: _controller,

              // width: 300,
              height: 300,
              // frameBuilder: ,

              errorBuilder: (context, _, __) => SizedBox(
                height: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: context.theme.errorColor,
                      size: (1.sh / 1.sw) * 20,
                    ),
                    // Lottie.asset(
                    //   'assets/animations/signature.json',
                    //   height: 200,
                    // ),
                    Gap(2.height),
                    Text(
                      'Failed to load signature',
                      style: context.textTheme.bodyText1?.copyWith(
                        color: context.theme.errorColor,
                      ),
                    ),
                  ],
                ),
              ),
              // backgroundColor: Colors.white,
              // dynamicPressureSupported: true,
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: GestureDetector(
              onTap: _goToSignaturePage,
              child: Container(
                // padding: kPadding,
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                decoration: MyDecoration.decoration(isCircle: true),
                child: Icon(
                  Icons.edit,
                  color: context.theme.primaryColor,
                ),
              ),
            ),
          ),
        ],
      );
    }
    return MyElevatedButton(
      text: 'Add Signature',
      color: Colors.red.withOpacity(0.8),
      onPressed: () async => _goToSignaturePage(),
    );
  }

  void _goToSignaturePage() {
    Get.to(() => _Signature(onDone: onDone));
  }
}

class _Signature extends StatefulWidget {
  final Function(Uint8List? signature) onDone;
  const _Signature({Key? key, required this.onDone}) : super(key: key);

  @override
  State<_Signature> createState() => __SignatureState();
}

class __SignatureState extends State<_Signature> {
  late SignatureController _controller;
  // Uint8List? image;
  bool showImage = false;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    _controller = SignatureController(
      penStrokeWidth: 5,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
      exportPenColor: Colors.grey.shade900,
    );
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  void onDone() async {
    final image = await _controller.toPngBytes();
    widget.onDone(image);
    _controller.clear();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () {
          onDone();

          Get.back();
        },
      ),
      appBar: MyAppBar(
        title: Text('Signature'),
      ),
      body: Signature(
        controller: _controller,

        // width: 300,
        // height: 300,
        backgroundColor: Colors.white,
        dynamicPressureSupported: false,
      ),
    );
  }
}
