import 'package:bioplus/constants/index.dart';
import 'package:bioplus/theme/color_constants.dart';
import 'package:bioplus/ui/select_roles_registration/models/select_role_model.dart';
import 'package:bioplus/widgets/my_listTile.dart';
import 'package:flutter/material.dart';

// enum RoleStatus {isPaid, isSubscribed, isSelected}

class MySwitchTile extends StatefulWidget {
  final SelectRoleModel model;
  final VoidCallback? onTap;
  const MySwitchTile({super.key, required this.model, this.onTap});

  @override
  State<MySwitchTile> createState() => _MySwitchTileState();
}

class _MySwitchTileState extends State<MySwitchTile> {
  @override
  Widget build(BuildContext context) {
    return MyListTile(
      text: widget.model.role,
      onTap: () async {
        if (widget.model.isPaidRole) {
          widget.onTap?.call();
        } else {
          widget.model.setSelect(!widget.model.isSelected);
          setState(() {});
        }
      },
      trailing: _buildTag(),
      // trailing: Row(
      //   mainAxisSize: MainAxisSize.min,
      //   children: [
      //     _buildTag(),
      //     // if (widget.model.isPaidRole)
      //     //   Container(
      //     //     decoration: BoxDecoration(
      //     //       color: kPrimaryColor,
      //     //       borderRadius: BorderRadius.circular(20),
      //     //     ),
      //     //     padding:
      //     //         const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      //     //     child: Text(
      //     //       'Pay',
      //     //       style: context.textTheme.bodyMedium?.copyWith(
      //     //         color: Colors.white,
      //     //       ),
      //     //     ),
      //     //   ),
      //     // if (widget.model.isSubscribed) ...[
      //     //   Container(
      //     //     decoration: BoxDecoration(
      //     //       color: Colors.teal,
      //     //       borderRadius: BorderRadius.circular(20),
      //     //     ),
      //     //     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      //     //     child: Text(
      //     //       'Subscribed',
      //     //       style: context.textTheme.bodyMedium?.copyWith(
      //     //         color: Colors.white,
      //     //         fontWeight: FontWeight.bold,
      //     //       ),
      //     //     ),
      //     //   ),
      //     // ] else if (widget.model.isPaidRole) ...[
      //     //   Container(
      //     //     decoration: BoxDecoration(
      //     //       color: kPrimaryColor,
      //     //       borderRadius: BorderRadius.circular(20),
      //     //     ),
      //     //     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      //     //     child: Text(
      //     //       'Pay',
      //     //       style: context.textTheme.bodyMedium?.copyWith(
      //     //         color: Colors.white,
      //     //         fontWeight: FontWeight.bold,
      //     //       ),
      //     //     ),
      //     //   ),
      //     //   const Gap(10),
      //     //   const Icon(Icons.chevron_right_outlined)
      //     // ],
      //     // if (!widget.model.isPaidRole)
      //     //   Switch(
      //     //     value: widget.model.isSelected,
      //     //     activeColor: context.theme.primaryColor,
      //     //     onChanged: (v) {
      //     //       widget.model.setSelect(v);
      //     //       setState(() {});
      //     //     },
      //     //   ),
      //   ],
      // ),
    );
  }

  Widget _buildTag() {
    final isPaid = widget.model.isPaidRole;
    final isSubscribed = widget.model.isSubscribed;

    if (isPaid) {
      return _buildPaidRole();
    } else if (isSubscribed) {
      return _tag('Subscribed', color: Colors.teal.withOpacity(1));
    } else {
      return Switch(
        value: widget.model.isSelected,
        activeColor: context.theme.primaryColor,
        onChanged: (v) {
          widget.model.setSelect(v);
          setState(() {});
        },
      );
    }

    // return Container(
    //   decoration: BoxDecoration(
    //     color: kPrimaryColor,
    //     borderRadius: BorderRadius.circular(20),
    //   ),
    //   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    //   child: Text(
    //     'Pay',
    //     style: context.textTheme.bodyMedium?.copyWith(
    //       color: Colors.white,
    //       fontWeight: FontWeight.bold,
    //     ),
    //   ),
    // );
  }

  Widget _buildPaidRole() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _tag('Pay'),
        const Gap(10),
        const Icon(Icons.chevron_right_outlined)
      ],
    );
  }

  Widget _tag(String text, {Color? color = kPrimaryColor}) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Text(
        text,
        style: context.textTheme.bodyMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
