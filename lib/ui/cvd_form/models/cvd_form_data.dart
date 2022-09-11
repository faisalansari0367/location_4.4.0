import 'package:background_location/ui/cvd_form/widgets/cvd_textfield.dart';
import 'package:background_location/ui/role_details/models/field_data.dart';
import 'package:flutter/material.dart';

class CvdFormData extends FieldData {
  CvdFormData({required String name, required TextEditingController controller})
      : super(name: name, controller: controller);

  @override
  Widget get fieldWidget {
    switch (name) {
      default:
        return CvdTextField(
          name: name,
          // controller: controller,
        );
    }
    // return super.fieldWidget;
    
  }
}
