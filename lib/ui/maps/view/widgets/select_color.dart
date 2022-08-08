import 'package:background_location/constants/constans.dart';
import 'package:background_location/extensions/size_config.dart';
import 'package:background_location/ui/maps/cubit/maps_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../models/enums/filed_assets.dart';

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
            padding: kPadding,
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
                ..._options(context),
              ],
            ),
          );
        },
      ),
    );
  }

  List<ListTile> _options(BuildContext context) {
    return FieldAssets.values
        .map(
          (e) => ListTile(
            contentPadding: EdgeInsets.zero,
            onTap: () {
              cubit.setAssetColor(e);
              Navigator.pop(context);
            },
            title: Text(e.name.capitalize!),
            trailing: Container(
              height: 5.width,
              width: 5.width,
              decoration: BoxDecoration(
                color: e.color,
                shape: BoxShape.circle,
              ),
            ),
          ),
        )
        .toList();
  }
}
