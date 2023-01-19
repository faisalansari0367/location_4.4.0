import 'package:bioplus/ui/emergency_warning_page/provider/provider.dart';
import 'package:bioplus/ui/maps/cubit/maps_cubit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapTypeWidget extends StatelessWidget {
  final MapsCubit cubit;
  // final ValueChanged<MapType> onPressed;
  // final MapType selectedType;
  const MapTypeWidget({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return _child(context);
  }

  Widget _child(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: cubit,
      child: Consumer<MapsCubit>(
        builder: (context, provider, child) {
          final state = provider.state;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: MapType.values
                .where((element) => element != MapType.none)
                .map(
                  (e) => RadioListTile<MapType>(
                    groupValue: state.mapType,
                    value: e,
                    title: Text(e.name.capitalize!),
                    onChanged: (v) {
                      cubit.changeMapType(v!);
                      Navigator.pop(context);
                    },
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }
}
