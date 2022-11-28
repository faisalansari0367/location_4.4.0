import 'package:background_location/constants/index.dart';
import 'package:flutter/cupertino.dart';

import '../../../../helpers/validator.dart';

class UpdatePolygonDetails extends StatefulWidget {
  // final MapsCubit cubit;
  final String? name;
  final String? companyOwner;

  final void Function(String name, String? companyOwnerName) onDone;
  const UpdatePolygonDetails({
    Key? key,
    required this.onDone,
    this.name,
    this.companyOwner,
  }) : super(key: key);

  @override
  State<UpdatePolygonDetails> createState() => _UpdatePolygonDetailsState();
}

class _UpdatePolygonDetailsState extends State<UpdatePolygonDetails> {
  final form = GlobalKey<FormState>();
  late TextEditingController controller;
  late TextEditingController _cw;

  @override
  void initState() {
    controller = TextEditingController(text: widget.name);
    _cw = TextEditingController(text: widget.companyOwner);

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    _cw.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: Form(
        key: form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Enter zone details',
              style: context.textTheme.headline6?.copyWith(fontWeight: FontWeight.bold),
            ),
            Gap(3.height),
            MyTextField(
              hintText: 'Please enter the zone name',
              validator: Validator.text,
              controller: controller,
            ),
            Gap(2.height),
            MyTextField(
              hintText: 'Company Owner Name',
              validator: Validator.none,
              controller: _cw,
            ),
            Gap(2.height),
            MyElevatedButton(
              onPressed: () async {
                if (form.currentState?.validate() ?? false) {
                  Get.back();
                  widget.onDone(controller.text, _cw.text.isEmpty ? null: _cw.text);
                }
              },
              text: 'Done',
            )
          ],
        ),
      ),
    );
  }
}
