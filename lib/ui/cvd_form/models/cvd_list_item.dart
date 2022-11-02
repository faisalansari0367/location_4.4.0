import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../../../helpers/validator.dart';
import '../widgets/cvd_textfield.dart';
import 'cvd_field_data.dart';

abstract class CvdListItem {
  Widget buildPic(CvdFieldData data) {
    return CvdTextField(
      name: data.label!,
      // textCapitalization: TextCapitalization.characters,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      textInputType: TextInputType.number,
      validator: Validator.pic,
      maxLength: 8,
      // value: userData?.pic,
      value: data.value,
      onChanged: (s) => data.value,
    );
  }
}
