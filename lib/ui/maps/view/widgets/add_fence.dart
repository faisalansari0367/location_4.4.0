import 'package:bioplus/ui/maps/cubit/maps_cubit.dart';
import 'package:bioplus/ui/maps/location_service/polygons_service.dart';
import 'package:bioplus/ui/maps/view/widgets/add_polygon_details.dart';
import 'package:bioplus/ui/maps/view/widgets/select_color.dart';
import 'package:bioplus/widgets/bottom_navbar/bottom_navbar_item.dart';
import 'package:bioplus/widgets/bottom_sheet/bottom_sheet_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../gen/assets.gen.dart';

class AddFence extends StatelessWidget {
  final MapsCubit cubit;
  const AddFence({Key? key, required this.cubit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: getItems(context).map((e) => Expanded(child: e)).toList(),
    );
  }

  List<Widget> getItems(BuildContext context) {
    return [
      Selector<MapsCubit, Color>(
        selector: (_, cubit) => cubit.state.selectedColor,
        builder: (context, color, child) => BottomNavbarItem(
          title: 'Select Color',
          color: color,
          onTap: () => BottomSheetService.showSheet(
            child: SelectColor(onColorSelected: cubit.setPolygonColor),
          ),
          icon: Assets.icons.bottomNavbar.colorPicker.path,
        ),
      ),
      Selector<MapsCubit, bool>(
        selector: (context, cubit) => cubit.state.isEditingFence,
        builder: (context, isEditingFence, child) {
          return isEditingFence
              ? const SizedBox.shrink()
              : BottomNavbarItem(
                  title: 'Undo',
                  onTap: () => context.read<PolygonsService>().removeLastLatLng(),
                  iconData: Icons.undo,
                );
        },
      ),
      BottomNavbarItem(
        title: 'Done',
        onTap: () {
          if (context.read<PolygonsService>().latLngs.length < 3) {
            cubit.setIsAddingGeofence();
            return;
          }

          BottomSheetService.showSheet(
            child: UpdatePolygonDetails(
              onDone: (name, companyOwnerName) {
                cubit.setIsAddingGeofence();
                cubit.addPolygon(name, companyOwner: companyOwnerName);
              },
            ),
          );

          // final form = GlobalKey<FormState>();
          // final controller = TextEditingController();
          // DialogService.showDialog(
          //   child: DialogLayout(
          //     child: Padding(
          //       padding: kPadding,
          //       child: Form(
          //         key: form,
          //         child: Column(
          //           mainAxisSize: MainAxisSize.min,
          //           children: [
          //             MyTextField(
          //               hintText: Strings.fieldNameMsg,
          //               validator: Validator.text,
          //               controller: controller,
          //             ),
          //             Gap(2.height),
          //             MyElevatedButton(
          //               onPressed: () async {
          //                 if (form.currentState?.validate() ?? false) {
          //                   Get.back();
          //                   cubit.setIsAddingGeofence();
          //                   cubit.addPolygon(controller.text);
          //                 }
          //               },
          //               text: 'Done',
          //             )
          //           ],
          //         ),
          //       ),
          //     ),
          //   ),
          // );
        },
        iconData: Icons.done,
      ),
    ];
  }
}

// class _AddPolygonDetails extends StatefulWidget {
//   final MapsCubit cubit;
//   const _AddPolygonDetails({required this.cubit});

//   @override
//   State<_AddPolygonDetails> createState() => _AddPolygonDetailsState();
// }

// class _AddPolygonDetailsState extends State<_AddPolygonDetails> {
//   final form = GlobalKey<FormState>();
//   final controller = TextEditingController();
//   final _cw = TextEditingController();

//   @override
//   void dispose() {
//     controller.dispose();
//     _cw.dispose();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.zero,
//       child: Form(
//         key: form,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               'Enter zone details',
//               style: context.textTheme.headline6?.copyWith(fontWeight: FontWeight.bold),
//             ),
//             Gap(3.height),
//             MyTextField(
//               hintText: 'Please enter the zone name',
//               validator: Validator.text,
//               controller: controller,
//             ),
//             Gap(2.height),
//             MyTextField(
//               hintText: 'Company Owner Name',
//               validator: Validator.none,

//               controller: _cw,
//             ),
//             Gap(2.height),
//             MyElevatedButton(
//               onPressed: () async {
//                 if (form.currentState?.validate() ?? false) {
//                   Get.back();
//                   widget.cubit.setIsAddingGeofence();
//                   widget.cubit.addPolygon(
//                     controller.text,
//                     companyOwner: _cw.text.isEmpty ? null : _cw.text,
//                   );
//                 }
//               },
//               text: 'Done',
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
