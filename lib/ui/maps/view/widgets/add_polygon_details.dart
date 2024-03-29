import 'package:bioplus/constants/index.dart';
import 'package:bioplus/helpers/validator.dart';
import 'package:flutter/cupertino.dart';

class UpdatePolygonDetails extends StatefulWidget {
  // final MapsCubit cubit;
  final String? name;
  final String? companyOwner;

  final void Function(String name, String? companyOwnerName, String? pic)
      onDone;
  const UpdatePolygonDetails({
    super.key,
    required this.onDone,
    this.name,
    this.companyOwner,
  });

  @override
  State<UpdatePolygonDetails> createState() => _UpdatePolygonDetailsState();
}

class _UpdatePolygonDetailsState extends State<UpdatePolygonDetails> {
  final form = GlobalKey<FormState>();
  late TextEditingController controller;
  late TextEditingController _cw;
  late TextEditingController _pic;

  @override
  void initState() {
    controller = TextEditingController(text: widget.name);
    _cw = TextEditingController(text: widget.companyOwner);
    _pic = TextEditingController();

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
              style: context.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
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
            MyTextField(
              hintText: 'PIC',
              validator: _pic.text.isEmpty ? Validator.none : Validator.pic,
              controller: _pic,
            ),
            Gap(2.height),
            MyElevatedButton(
              onPressed: () async {
                if (form.currentState?.validate() ?? false) {
                  Get.back();
                  widget.onDone(
                    controller.text,
                    _cw.text.isEmpty ? null : _cw.text,
                    _pic.text.isEmpty ? null : _pic.text,
                  );
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
