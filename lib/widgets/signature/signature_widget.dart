import 'dart:convert';
import 'dart:typed_data';

import 'package:background_location/constants/index.dart';
import 'package:background_location/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:signature/signature.dart';

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
    if (![null, ''].contains(widget.signature)) {
      // if (widget.signature != null) {
      try {
        _image = base64Decode(widget.signature!);
        showImage = true;
      } catch (e) {
        print(e);
      }
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SignatureWidget oldWidget) {
    if (oldWidget.signature != widget.signature) {
      if (![null, ''].contains(widget.signature)) {
        // if (widget.signature != null) {
        try {
          _image = base64Decode(widget.signature!);
          showImage = true;
        } catch (e) {
          print(e);
        }
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  void onDone(String? signature) {
    if (signature != null) {
      setState(() {
        _image = base64Decode(signature);
        showImage = true;
      });
      widget.onChanged?.call(signature);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (showImage) {
      return Stack(
        children: [
          Container(
            clipBehavior: Clip.antiAlias,
            width: double.infinity,
            decoration: MyDecoration.decoration(),
            child: Image.memory(
              _image!,
              height: 300,
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
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: GestureDetector(
              onTap: _goToSignaturePage,
              child: Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
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
    Get.to(() => CreateSignature(onDone: onDone));
  }
}

class CreateSignature extends StatefulWidget {
  final Function(String? signature) onDone;
  const CreateSignature({Key? key, required this.onDone}) : super(key: key);

  @override
  State<CreateSignature> createState() => _CreateSignatureState();
}

class _CreateSignatureState extends State<CreateSignature> {
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
    if (image != null) {
      widget.onDone(base64Encode(image));
      _controller.clear();
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.check),
        onPressed: () {
          onDone();
          Get.back();
        },
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Theme(
          data: Theme.of(context).copyWith(
            appBarTheme: AppBarTheme(
              color: context.theme.backgroundColor,
              elevation: 0,
              iconTheme: const IconThemeData(
                color: Colors.black,
              ),
              // titleTextStyle: TextStyle(
              //   color: Colors.black,
              //   // fontSize: 20.w,
              // ),
            ),
          ),
          child: AppBar(
            title: const Text(
              'Signature',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            elevation: 0,
            backgroundColor: context.theme.backgroundColor,
          ),
        ),
      ),
      body: Signature(
        controller: _controller,

        // width: 300,
        // height: 300,
        backgroundColor: Colors.white,
      ),
    );
  }
}
