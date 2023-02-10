import 'package:bioplus/constants/index.dart';
import 'package:bioplus/ui/add_pic/add_pic.dart';
import 'package:bioplus/ui/pic/cubit/pic_cubit.dart';
import 'package:bioplus/ui/pic/widgets/pic_card.dart';
import 'package:bioplus/ui/pic/widgets/pic_details_view.dart';
import 'package:bioplus/widgets/empty_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// {@template pic_body}
/// Body of the PicPage.
///
/// Add what it does
/// {@endtemplate}
class PicBody extends StatelessWidget {
  /// {@macro pic_body}
  const PicBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PicCubit, PicState>(
      builder: _builder,
    );
  }

  Widget _builder(BuildContext context, PicState state) {
    if (state is PicInitial) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state is PicLoaded) {
      if (state.pics.isEmpty) {
        return Column(
          children: [
            const EmptyScreen(
              message: 'No Records Found',
            ),
            const SizedBox(height: 10),
            MyElevatedButton(
              text: Strings.addPic,
              width: 70.width,
              height: 6.height,
              onPressed: () async => Get.to(() => const AddPicPage()),
            ),
          ],
        );
      }

      return Padding(
        padding: kPadding,
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemCount: state.pics.length,
                itemBuilder: (context, index) {
                  final pic = state.pics[index];
                  return GestureDetector(
                    onTap: () => Get.to(() => PicDetailsView(model: pic)),
                    child: PicCard(picModel: pic),
                  );
                },
              ),
            ),
            Gap(10.h),
            MyElevatedButton(
              text: Strings.addPic,
              onPressed: () async => Get.to(() => const AddPicPage()),
            ),
            Gap(10.h),
          ],
        ),
      );
    }

    if (state is PicError) {
      return EmptyScreen(
        message: state.error,
      );
    }

    return const Center(
      child: Text('Something went wrong'),
    );
  }
}
