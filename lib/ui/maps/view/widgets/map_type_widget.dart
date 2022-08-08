import 'package:background_location/ui/maps/cubit/maps_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapTypeWidget extends StatelessWidget {
  final MapsCubit cubit;
  // final ValueChanged<MapType> onPressed;
  // final MapType selectedType;
  const MapTypeWidget({Key? key, required this.cubit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _child(context);
  }

  Widget _child(BuildContext context) {
    return BlocProvider.value(
      value: cubit,
      child: BlocBuilder<MapsCubit, MapsState>(
        builder: (context, state) {
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
