import 'package:api_repo/api_repo.dart';
import 'package:bioplus/ui/pic/cubit/pic_cubit.dart';
import 'package:bioplus/ui/pic/widgets/pic_body.dart';
import 'package:bioplus/widgets/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// {@template pic_page}
/// A description for PicPage
/// {@endtemplate}
class PicPage extends StatelessWidget {
  /// {@macro pic_page}
  const PicPage({super.key});

  /// The static route for PicPage
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(builder: (_) => const PicPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PicCubit>(
      create: (context) => PicCubit(api: context.read<Api>()),
      child: const Scaffold(
        appBar: MyAppBar(
          // title: 'PIC',
          title: Text('PICS'),
        ),
        body: PicView(),
      ),
    );
  }
}

/// {@template pic_view}
/// Displays the Body of PicView
/// {@endtemplate}
class PicView extends StatelessWidget {
  /// {@macro pic_view}
  const PicView({super.key});

  @override
  Widget build(BuildContext context) {
    return const PicBody();
  }
}
