import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/index.dart';

class MyListTile extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Future<void> Function() onTap;
  final Widget? trailing, title;
  const MyListTile({
    Key? key,
    required this.text,
    required this.onTap,
    this.trailing,
    this.title, this.style,
  }) : super(key: key);

  @override
  State<MyListTile> createState() => _MyListTileState();
}

class _MyListTileState extends State<MyListTile> {
  bool isLoading = false;

  void setLoading(bool value) {
    if (!mounted) return;
    setState(() {
      isLoading = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.backgroundColor,
        borderRadius: kBorderRadius,
        border: Border.all(color: Colors.grey.shade400),
      ),

      // color: Colors.white,
      child: ListTile(
        dense: false,
        selected: true,
        // selectedTileColor: context.theme.primaryColor.withOpacity(1.0),
        // shape: MyDecoration.inputBorder.copyWith(
        //   borderRadius: kBorderRadius,
        // ),
        onTap: () async {
          setLoading(true);
          await widget.onTap();
          setLoading(false);
        },
        selectedColor: Colors.black,
        title: widget.title ??
            Text(
              widget.text,
              style: context.textTheme.subtitle2?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 15.w,
              ).merge(widget.style),
            ),
        trailing: isLoading
            ? SizedBox.square(
                dimension: 5.width,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
            : widget.trailing ??
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey.shade800,
                ),
      ),
    );
  }
}
