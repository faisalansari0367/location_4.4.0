import 'package:background_location/constants/my_decoration.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapTypeWidget extends StatelessWidget {
  final ValueChanged<MapType> onPressed;
  const MapTypeWidget({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.white,
      decoration: MyDecoration.decoration(isCircle: true),
      child: IconButton(
        // color: Colors.white,
        onPressed: () => showSheet(context),
        icon: Icon(Icons.map_sharp),
      ),
    );
  }

  void showSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: MapType.values
              .where((element) => element != MapType.none)
              .map(
                (e) => ListTile(
                  title: Text(e.name),
                  onTap: () {
                    onPressed(e);
                    Navigator.pop(context);
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
