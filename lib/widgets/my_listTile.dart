import 'package:background_location/extensions/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../constants/index.dart';

class MyListTile extends StatefulWidget {
  final String text;
  final Future<void> Function() onTap;
  const MyListTile({Key? key, required this.text, required this.onTap}) : super(key: key);

  @override
  State<MyListTile> createState() => _MyListTileState();
}

class _MyListTileState extends State<MyListTile> {
  bool isLoading = false;

  setLoading(bool value) {
    if (!mounted) return;
    setState(() {
      isLoading = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: false,
      selected: true,
      // selectedTileColor: context.theme.primaryColor.withOpacity(1.0),
      shape: MyDecoration.inputBorder.copyWith(
        borderRadius: kBorderRadius,
      ),
      onTap: () async {
        setLoading(true);
        await widget.onTap();
        setLoading(false);
      },
      selectedColor: Colors.black,
      title: Text(
        widget.text,
        style: context.textTheme.subtitle2?.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 15.w,
        ),
      ),
      trailing: isLoading
          ? SizedBox.square(
              dimension: 5.width,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
          : Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey.shade800,
            ),
    );
  }
}
