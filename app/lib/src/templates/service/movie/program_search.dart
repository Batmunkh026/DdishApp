import 'package:ddish/src/widgets/submit_button.dart';
import 'package:ddish/src/widgets/text_field.dart';
import 'package:flutter/cupertino.dart';

class ProgramSearchWidget extends StatelessWidget {
  final VoidCallback onSearchTap;
  final bool searchById;
  final TextEditingController controller;

  ProgramSearchWidget({this.searchById, this.onSearchTap, this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Flexible(
          child: InputField(
            hasBorder: true,
            align: TextAlign.center,
            textInputType: searchById ? TextInputType.number : TextInputType.text ,
            placeholder:
                searchById ? 'Кино ID оруулна уу' : 'Кино нэр оруулна уу',
            textController: controller,
            hasClearButton: true,
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
