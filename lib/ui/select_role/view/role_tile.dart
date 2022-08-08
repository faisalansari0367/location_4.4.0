import 'package:background_location/extensions/size_config.dart';
import 'package:flutter/material.dart';

import '../../../constants/index.dart';

class RoleTile extends StatefulWidget {
  final String role;
  final Future<void> Function() onTap;
  const RoleTile({Key? key, required this.role, required this.onTap}) : super(key: key);

  @override
  State<RoleTile> createState() => _RoleTileState();
}

class _RoleTileState extends State<RoleTile> {
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
      shape: MyDecoration.inputBorder.copyWith(
        borderRadius: kBorderRadius,
      ),
      onTap: () async {
        setLoading(true);
        await widget.onTap();
        setLoading(false);
      },
      selectedColor: Colors.black,
      title: Text(widget.role),
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
