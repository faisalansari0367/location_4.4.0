import 'package:background_location/constants/index.dart';
import 'package:background_location/features/webview/flutter_webview.dart';
import 'package:background_location/widgets/my_appbar.dart';
import 'package:background_location/widgets/my_listTile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LinksView extends StatelessWidget {
  const LinksView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: Text('Links'),
      ),
      body: Padding(
        padding: kPadding,
        child: Column(
          children: [
            MyListTile(
              text: 'Animal Health Safety',
              onTap: () async => Get.to(
                () => Webview(
                  url: 'https://animalhealthaustralia.com.au/better-on-farm-biosecurity/',
                  title: 'Animal Health Safety',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}