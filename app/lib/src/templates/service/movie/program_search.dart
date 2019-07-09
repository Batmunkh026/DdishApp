import 'package:ddish/src/utils/input_validations.dart';
import 'package:ddish/src/widgets/submit_button.dart';
import 'package:ddish/src/widgets/text_field.dart';
import 'package:flutter/cupertino.dart';

class ProgramSearchWidget extends StatelessWidget {
  final VoidCallback onSearchTap;
  final bool searchById;
  final TextEditingController controller;
  double fontSize;

  ProgramSearchWidget(
      {this.searchById, this.onSearchTap, this.controller, this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Flexible(
          child: InputField(
            hasBorder: true,
            align: TextAlign.center,
            textInputType: TextInputType.text,
            inputFormatters: [
              InputValidations.acceptedFormatters[InputType.NumberInt]
            ],
            placeholder:
                searchById ? 'Кино ID оруулна уу' : 'Кино нэр оруулна уу',
            fontSize: fontSize,
            textController: controller,
          ),
        ),
        SubmitButton(
          text: searchById ? 'Түрээслэх' : 'Хайх',
          padding: const EdgeInsets.all(5.0),
          onPressed: onSearchTap,
        ),
      ],
    );
  }
}
