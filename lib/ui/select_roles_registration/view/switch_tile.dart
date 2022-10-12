import 'package:background_location/ui/select_roles_registration/models/select_role_model.dart';
import 'package:background_location/widgets/my_listTile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MySwitchTile extends StatefulWidget {
  final SelectRoleModel model;
  const MySwitchTile({Key? key, required this.model}) : super(key: key);

  @override
  State<MySwitchTile> createState() => _MySwitchTileState();
}

class _MySwitchTileState extends State<MySwitchTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: MyDecoration.decoration().copyWith(
      //   // border: Border.all(color: Colors.grey.shade300),
      //   boxShadow: [],
      // ),
      child: MyListTile(
        text: widget.model.role,
        onTap: () async {
          widget.model.setSelect(!widget.model.isSelected);
          setState(() {});
        },
        trailing: Switch(
          value: widget.model.isSelected,
          activeColor: context.theme.primaryColor,
          onChanged: (v) {
            widget.model.setSelect(v);
            setState(() {});
          },
        ),
      ),
    );
  }
}
