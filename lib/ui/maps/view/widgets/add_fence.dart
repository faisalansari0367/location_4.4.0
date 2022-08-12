import 'package:background_location/extensions/size_config.dart';
import 'package:background_location/ui/maps/cubit/maps_cubit.dart';
import 'package:background_location/ui/maps/view/widgets/select_color.dart';
import 'package:background_location/widgets/bottom_navbar/bottom_navbar_item.dart';
import 'package:background_location/widgets/dialogs/dialog_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../constants/constans.dart';
import '../../../../constants/strings.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../helpers/validator.dart';
import '../../../../widgets/dialogs/dialog_service.dart';
import '../../../../widgets/my_elevated_button.dart';
import '../../../../widgets/text_fields/my_text_field.dart';

class AddFence extends StatelessWidget {
  final MapsCubit cubit;
  const AddFence({Key? key, required this.cubit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: getItems(context).map((e) => Expanded(child: e)).toList(),
    );
  }

  List<Widget> getItems(context) {
    return [
      BlocBuilder<MapsCubit, MapsState>(
        builder: (context, state) => BottomNavbarItem(
          title: 'Select Color',
          color: state.selectedColor,
          // onTap: () => DialogService.showDialog(
          //   child: DialogLayout(child: SelectColor(cubit: cubit)),
          // ),
          onTap: () {
            showModalBottomSheet(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                context: context,
                builder: (context) {
                  // generate a color picker for me
                  return SelectColor(cubit: cubit);
                });
          },
          icon: Assets.icons.bottomNavbar.colorPicker.path,
        ),
      ),
      BottomNavbarItem(
        title: 'Undo',
        onTap: cubit.clearLastMarker,
        iconData: Icons.undo,
      ),
      BottomNavbarItem(
        title: 'Done',
        onTap: () {
          if (cubit.state.latLngs.length < 3) {
            cubit.setIsAddingGeofence();
            // Get.snackbar(
            //   'Invalid Area Selection',
            //   'Please select the area correctly',
            //   // colorText: Colors.white,
            //   // backgroundColor: Color.fromARGB(31, 255, 255, 255),
            //   // overlayColor: Color.fromARGB(255, 164, 160, 160),
            //   barBlur: 10,
            //   overlayBlur: 10,
            // );
            // Future.wait
            // Get.back();
            return;
          }
          final form = GlobalKey<FormState>();
          final controller = TextEditingController();
          // showModalBottomSheet(
          //     context: context,
          //     builder: (context) {
          //       return Padding(
          //         padding: kPadding.copyWith(
          //           bottom: context.mediaQueryPadding.bottom,
          //         ),
          //         child: Form(
          //           key: form,
          //           child: Column(
          //             mainAxisSize: MainAxisSize.min,
          //             children: [
          //               // Name
          //               MyTextField(
          //                 hintText: 'Please enter the field asset',
          //                 validator: Validator.text,
          //                 controller: controller,
          //               ),
          //               Gap(2.height),
          //               MyElevatedButton(
          //                 onPressed: () async {
          //                   if (form.currentState?.validate() ?? false) {
          //                     Get.back();
          //                     cubit.setIsAddingGeofence();
          //                     cubit.addPolygon(controller.text);
          //                   }
          //                 },
          //                 text: ('Done'),
          //               )
          //             ],
          //           ),
          //         ),
          //       );
          //     });

          DialogService.showDialog(
            child: DialogLayout(
              child: Padding(
                padding: kPadding,
                child: Form(
                  key: form,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Name
                      MyTextField(
                        hintText: Strings.fieldName,
                        validator: Validator.text,
                        controller: controller,
                      ),
                      Gap(2.height),
                      MyElevatedButton(
                        onPressed: () async {
                          if (form.currentState?.validate() ?? false) {
                            Get.back();
                            cubit.setIsAddingGeofence();
                            cubit.addPolygon(controller.text);
                          }
                        },
                        text: ('Done'),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        iconData: Icons.done,
      ),
    ];
  }

  // return Padding(
  //   padding: const EdgeInsets.all(8.0),
  //   child: Row(
  //     // mainAxisAlignment: MainAxisAlignment.spaceAround,
  //     children: [
  //       // Expanded(
  //       //   flex: 3,
  //       //   child: Center(
  //       //     child: Text(
  //       //       'Tap on the screen to draw fence',
  //       //       style: context.textTheme.subtitle2,
  //       //     ),
  //       //   ),
  //       // ),
  //       Expanded(child: _selectColorWidget()),
  //       // clear icon button
  //       Expanded(
  //         child: Material(
  //           child: InkWell(
  //             onTap: widget.cubit.clearLastMarker,
  //             child: Column(
  //               children: [
  //                 Icon(Icons.clear),
  //                 // clear text
  //                 Text(
  //                   'Clear',
  //                   style: context.textTheme.subtitle2,
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //       // Divider(),
  //       // Container(
  //       //   width: 0.5.width,
  //       //   height: 7.height,
  //       //   color: Color.fromARGB(58, 0, 0, 0),
  //       // ),
  //       Expanded(
  //         child: Material(
  //           child: InkWell(
  //             onTap: widget.cubit.setIsAddingGeofence,
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 Icon(Icons.check),
  //                 Text(
  //                   'done',
  //                   style: context.textTheme.subtitle2,
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     ],
  //   ),
  //   // );x
}
