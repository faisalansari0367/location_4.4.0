import 'package:api_repo/api_repo.dart';
import 'package:background_location/constants/index.dart';
import 'package:background_location/ui/maps/location_service/maps_repo.dart';
import 'package:background_location/ui/maps/models/polygon_model.dart';
import 'package:background_location/ui/maps/widgets/geofences_list/geofence_card.dart';
import 'package:background_location/widgets/animations/animations.dart';
import 'package:background_location/widgets/empty_screen.dart';
import 'package:background_location/widgets/listview/my_listview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

enum FilterType { created_by_me, all }

class GeofencesList extends StatefulWidget {
  // final List<PolygonModel> polygons;
  final ScrollController? controller;
  final ValueChanged<PolygonModel> onSelected;
  const GeofencesList({Key? key, this.controller, required this.onSelected}) : super(key: key);

  @override
  State<GeofencesList> createState() => _GeofencesListState();
}

class _GeofencesListState extends State<GeofencesList> {
  FilterType filterType = FilterType.created_by_me;
  UserData? userData;

  setFilter() {
    setState(() {
      filterType = filterType == FilterType.created_by_me ? FilterType.all : FilterType.created_by_me;
    });
  }

  Stream<List<PolygonModel>> filterPolygons() {
    return filterType == FilterType.created_by_me
        ? context
            .read<MapsRepo>()
            .polygonStream
            .map((event) => event.where((element) => element.createdBy?.id == userData?.id).toList())
        : context.read<MapsRepo>().polygonStream;
  }

  @override
  void initState() {
    userData = context.read<Api>().getUserData();
    super.initState();
  }

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
        Padding(
          padding: kPadding,
          child: Column(
            children: [
              _selectLocationHeader(context),
              // filter
              if (context.read<Api>().getUser()?.role == 'Admin') _filterBy(context),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<List<PolygonModel>>(
            stream: filterPolygons(),
            builder: (context, snapshot) {
              return Scrollbar(
                controller: widget.controller,
                child: MyListview(
                  data: snapshot.data ?? [],
                  emptyWidget: Center(
                    child: EmptyScreen(
                      message: 'You have not created any geofences',
                      messsageOnTop: true,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: kPadding.left),
                  controller: widget.controller,
                  // itemCount: sort(snapshot.data ?? []).length,
                  itemBuilder: (context, index) {
                    final fence = snapshot.data![index];
                    return GeofenceCard(
                      onTap: () => widget.onSelected.call(fence),
                      item: fence,
                    );
                  },
                ),
              );
            },
            // ),
          ),
        ),
      ],
    );
  }

  Row _filterBy(BuildContext context) {
    return Row(
      children: [
        Text(
          'Filter by',
          style: TextStyle(
            fontSize: 15.h,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        ...FilterType.values
            .map(
              (e) => Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: InputChip(
                  selected: filterType == e,
                  backgroundColor: Colors.grey.shade200,
                  selectedColor: context.theme.primaryColor.withOpacity(1),
                  // elevation: 5,
                  onPressed: setFilter,
                  checkmarkColor: filterType == e ? Colors.white : Colors.grey,

                  label: Text(
                    e.name.replaceAll('_', ' ').capitalize!,
                    style: TextStyle(
                      fontSize: 15.h,
                      color: filterType == e ? Colors.white : Colors.grey.shade700,
                    ),
                  ),
                ),
              ),
            )
            .toList()
      ],
    );
  }

  Row _selectLocationHeader(BuildContext context) {
    return Row(
      children: [
        Text(
          'Select A Location',
          style: context.textTheme.headline6?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        AnimatedButton(
          scale: 0.8,
          onTap: Get.back,
          child: Container(
            padding: EdgeInsets.all(5.r),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.clear),
          ),
        ),
      ],
    );
  }

  List<PolygonModel> sort(List<PolygonModel>? list) {
    if (list == null) return [];
    if (list.isEmpty) return [];
    return list..sort((a, b) => a.name.compareTo(b.name));
  }
}
