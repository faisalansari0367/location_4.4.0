import 'package:background_location/constants/index.dart';
import 'package:background_location/ui/maps/location_service/map_toolkit_utils.dart';
import 'package:background_location/ui/maps/models/polygon_model.dart';
import 'package:background_location/widgets/bottom_sheet/bottom_sheet_service.dart';
import 'package:background_location/widgets/dialogs/dialog_layout.dart';
import 'package:background_location/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class EnterProperty extends StatefulWidget {
  final Stream<Set<PolygonModel>> stream;
  final VoidCallback? onYES, onNO;
  const EnterProperty({Key? key, required this.stream, this.onYES, this.onNO}) : super(key: key);

  @override
  State<EnterProperty> createState() => _EnterPropertyState();
}

class _EnterPropertyState extends State<EnterProperty> {
  @override
  Widget build(BuildContext context) {
    return DialogLayout(
      child: Padding(
        padding: kPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Are you visiting below PIC?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.h),
            // StreamBuilder(builder: builder)
            StreamBuilder<Set<PolygonModel>>(
                stream: widget.stream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.isEmpty) return CircularProgressIndicator();

                  return AnimatedSize(
                    duration: 300.milliseconds,
                    child: Column(
                      children: snapshot.data!.map((polygon) {
                        return _tile(polygon);
                      }).toList(),
                    ),
                  );
                }),

            Gap(20.h),
            Row(
              children: [
                Spacer(),
                TextButton(
                  child: Text(Strings.yes),
                  onPressed: () {
                    if(widget.onYES != null) widget.onYES!();
                    Navigator.of(context).pop(true);
                    BottomSheetService.showSheet(
                      child: QuestionsSheet(),
                    );
                  },
                ),
                TextButton(
                  child: Text(Strings.no),
                  onPressed: () {
                    if(widget.onNO != null) widget.onNO!();
                    Navigator.of(context).pop(false);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _tile(PolygonModel polygon) {
    return ListTile(
      selected: true,
      selectedTileColor: polygon.color.withOpacity(0.2),
      title: Text(polygon.name),
      subtitle: Text(MapsToolkitService.calculatePolygonArea(polygon.points).toStringAsFixed(0) + ' m²'),
      onTap: () {
        Navigator.of(context).pop(polygon);
      },
    );
  }
}

class QuestionsSheet extends StatelessWidget {
  const QuestionsSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.5,
      maxChildSize: 0.8,
      // builder
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.w),
              topRight: Radius.circular(20.w),
            ),
          ),
          child: ListView(
            padding: kPadding,
            controller: scrollController,
            children: [
              // Padding(
              //   padding: kPadding,
              //   child: Text(
              //     'Are you visiting below PIC?',
              //     style: TextStyle(
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              // ),
              Text('Reason for visit'),
              TextField(
                minLines: 5,
                maxLines: 10,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: kBorderRadius),
                  // labelText: 'Reason for visit',
                ),
              ),
              Gap(20.h),
              MyElevatedButton(
                text: Strings.submit,
              ),
            ],
          ),
        );
      },
    );
  }
}
