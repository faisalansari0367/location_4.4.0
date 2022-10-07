import 'package:background_location/constants/index.dart';
import 'package:background_location/ui/maps/cubit/maps_cubit.dart';
import 'package:background_location/widgets/animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

Color fromHex(String hexString) {
  final buffer = StringBuffer();
  if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
  buffer.write(hexString.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}

final colors = [
  fromHex('#DB3325'),
  fromHex('#3F8C26'),
  fromHex('#453EE4'),
  fromHex('#60438F'),
  fromHex('#EC5C29'),
  fromHex('#6BD945'),
  fromHex('#7299EF'),
  fromHex('#DE4AEA'),
  fromHex('#AF753D'),
  fromHex('#E2C742'),
  fromHex('#5DBAA6'),
  fromHex('#F1918E'),
  fromHex('#E8B37B'),
  fromHex('#FEF674'),
  fromHex('#81FAD9'),
  fromHex('#EBB3FA'),
  fromHex('#010000'),
  fromHex('#635E5F'),
  fromHex('#C4C2C0'),
  fromHex('#FFFFFF'),
];

class SelectColor extends StatelessWidget {
  final MapsCubit cubit;
  const SelectColor({Key? key, required this.cubit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: cubit,
      child: BlocBuilder<MapsCubit, MapsState>(
        builder: (context, state) {
          return SingleChildScrollView(
            // padding: kPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Gap(2.height),
                Text(
                  'Please select a field asset',
                  style: context.textTheme.headline6,
                ),
                Gap(5.height),
                // ..._options(context),
                SizedBox(
                  width: 100.width,
                  child: Wrap(
                    spacing: 10.width,
                    runSpacing: 7.width,
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    runAlignment: WrapAlignment.center,
                    children: colors
                        .map(
                          (e) => AnimatedButton(
                            onTap: () {
                              cubit.setAssetColor(e);
                              Get.back();
                            },
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: MyDecoration.decoration(isCircle: true, color: e),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                Gap(context.mediaQueryViewPadding.bottom),
              ],
            ),
          );
        },
      ),
    );
  }
}
