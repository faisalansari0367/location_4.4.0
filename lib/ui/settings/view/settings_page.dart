import 'package:background_location/constants/index.dart';
import 'package:background_location/widgets/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        showBackButton: false,
      ),
      body: SingleChildScrollView(
        padding: kPadding,
        child: Column(
          children: [
            Text(
              'Settings',
              style: context.textTheme.headline6,
            ),
          ],
        ),
      ),
    );
  }
}
