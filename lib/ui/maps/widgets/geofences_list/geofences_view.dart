import 'package:background_location/ui/maps/location_service/maps_repo.dart';
import 'package:background_location/ui/maps/models/polygon_model.dart';
import 'package:background_location/ui/maps/widgets/geofences_list/geofence_card.dart';
import 'package:background_location/widgets/listview/my_listview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class GeofencesList extends StatefulWidget {
  // final List<PolygonModel> polygons;
  final ScrollController? controller;
  final ValueChanged<PolygonModel> onSelected;
  const GeofencesList({Key? key, this.controller, required this.onSelected}) : super(key: key);

  @override
  State<GeofencesList> createState() => _GeofencesListState();
}

class _GeofencesListState extends State<GeofencesList> {
  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    // appBar: MyAppBar(
    //   title: Text('Geofence List'),
    //   // elevation: 1,
    //   showDivider: true,
    // ),
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gap(10.h),
        Text(
          'Select A Geofence',
          style: context.textTheme.headline6?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Gap(30.h),
        Expanded(
          child: StreamBuilder<List<PolygonModel>>(
            stream: context.read<MapsRepo>().polygonStream,
            builder: (context, snapshot) {
              return MyListview(
                // shrinkWrap: true,
                controller: widget.controller,
                // padding: kPadding,
                isLoading: snapshot.connectionState == ConnectionState.waiting,
                data: snapshot.data ?? [],
                itemBuilder: (context, index) => GeofenceCard(
                  onTap: () => widget.onSelected.call(snapshot.data!.elementAt(index)),
                  item: snapshot.data![index],
                ),
              );
            },
            // ),
          ),
        ),
      ],
    );
  }
}
