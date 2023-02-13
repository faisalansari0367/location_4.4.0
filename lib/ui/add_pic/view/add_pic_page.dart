import 'package:api_repo/api_repo.dart';
import 'package:bioplus/ui/add_pic/provider/provider.dart';
import 'package:bioplus/ui/add_pic/widgets/add_pic_body.dart';
import 'package:bioplus/widgets/my_appbar.dart';
import 'package:flutter/material.dart';

/// {@template add_pic_page}
/// A description for AddPicPage
/// {@endtemplate}
class AddPicPage extends StatelessWidget {
  /// {@macro add_pic_page}
  const AddPicPage({super.key, this.pic, this.updatePic = false});

  final PicModel? pic;
  final bool updatePic;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          AddPicNotifier(context, model: pic, updatePic: updatePic),
      child: Scaffold(
        appBar: MyAppBar(
          elevation: 2,
          title: Text(updatePic ? 'Update PIC' : 'Add PIC'),
        ),
        body: const AddPicView(),
      ),
    );
  }
}

/// {@template add_pic_view}
/// Displays the Body of AddPicView
/// {@endtemplate}
class AddPicView extends StatelessWidget {
  /// {@macro add_pic_view}
  const AddPicView({super.key});

  @override
  Widget build(BuildContext context) {
    return const AddPicBody();
  }
}
