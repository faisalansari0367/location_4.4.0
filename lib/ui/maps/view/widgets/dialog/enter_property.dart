import 'package:api_repo/api_repo.dart';
import 'package:bioplus/constants/index.dart';
import 'package:bioplus/ui/maps/location_service/map_toolkit_utils.dart';
import 'package:bioplus/widgets/auto_spacing.dart';
import 'package:bioplus/widgets/dialogs/dialog_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EnterProperty extends StatefulWidget {
  final Stream<Set<PolygonModel>> stream;
  final VoidCallback? onNO;
  final ValueChanged<PolygonModel> onTap;
  const EnterProperty({super.key, required this.stream, this.onNO, required this.onTap});

  @override
  State<EnterProperty> createState() => _EnterPropertyState();
}

class _EnterPropertyState extends State<EnterProperty> {
  @override
  Widget build(BuildContext context) {
    return DialogLayout(
      child: SingleChildScrollView(
        padding: kPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Are you entering any of these Locations?\nSelect from the list below',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),
            SizedBox(height: 20.h),
            StreamBuilder<Set<PolygonModel>>(
              stream: widget.stream,
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                return AnimatedSize(
                  duration: 300.milliseconds,
                  child: AutoSpacing(
                    spacing: Gap(10.h),
                    children: snapshot.data!.map(_tile).toList(),
                  ),
                );
              },
            ),
            // ListView.builder(
            //   itemCount: widget.stream,
            //   builder: (context, snapshot) {
            //     if (!snapshot.hasData || snapshot.data!.isEmpty)
            //       return const Center(child: CircularProgressIndicator());
            //     return AnimatedSize(
            //       duration: 300.milliseconds,
            //       child: AutoSpacing(
            //         spacing: Gap(10.h),
            //         children: snapshot.data!.map(_tile).toList(),
            //       ),
            //     );
            //   },
            // ),
            Gap(20.h),
            Row(
              children: [
                const Spacer(),
                // TextButton(
                //   child: Text(Strings.yes),
                //   onPressed: () {
                //     if(widget.onYES != null) widget.onYES!();
                //     Navigator.of(context).pop(true);
                //     BottomSheetService.showSheet(
                //       child: QuestionsSheet(),
                //     );
                //   },
                // ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.circular(10.r),
                    // ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                    if (widget.onNO != null) widget.onNO!();
                  },
                  child: Text(
                    Strings.no,
                    style: TextStyle(
                      fontSize: 20.h,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
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
      trailing: const Icon(Icons.chevron_right),
      title: Text(
        polygon.name,
        style: TextStyle(
          fontSize: 16.sp,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        '${MapsToolkitService.calculatePolygonArea(polygon.points).toStringAsFixed(0)} m²',
        style: TextStyle(
          fontSize: 15.sp,
          color: const Color.fromARGB(143, 0, 0, 0),
        ),
      ),
      onTap: () {
        Navigator.of(context).pop(polygon);
        widget.onTap(polygon);
        // BottomSheetService.showSheet(child: QuestionsSheet());
      },
    );
  }
}
