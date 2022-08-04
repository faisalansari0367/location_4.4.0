import 'package:background_location/ui/maps/cubit/maps_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsView extends StatelessWidget {
  const MapsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MapsCubit>();
    return Scaffold(
      appBar: AppBar(title: const Text('Maps')),
      body: Stack(
      children: [
          // Stack(
          //   children: [
          GoogleMap(
            initialCameraPosition: cubit.kLake,
            onMapCreated: cubit.onMapCreated,
          ),
          //   ],
          // )
        ],
      ),
    );
  }
}
