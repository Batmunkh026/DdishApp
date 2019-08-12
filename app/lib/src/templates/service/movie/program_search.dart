import 'package:ddish/src/utils/input_validations.dart';
import 'package:ddish/src/widgets/submit_button.dart';
import 'package:ddish/src/widgets/text_field.dart';
import 'package:flutter/cupertino.dart';

class ProgramSearchWidget extends StatelessWidget {
  final VoidCallback onSearchTap;
  final bool searchById;
  final TextEditingController controller;
  final VoidCallback onReturnTap;
  final GlobalKey<FormState> formKey;

  ProgramSearchWidget(
      {this.formKey, this.searchById, this.onSearchTap, this.controller, this.onReturnTap});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Flexible(
                child: InputField(
                  hasBorder: true,
                  align: TextAlign.center,
                  textInputType:
                      searchById ? TextInputType.number : TextInputType.text,
                  placeholder:
                      searchById ? 'Кино ID оруулна уу' : 'Кино нэр оруулна уу',
                  textController: controller,
                  fontSize: 12,
                  hasClearButton: true,
                  padding: EdgeInsets.all(3),
                  validateFunction: InputValidations.validateNotNullValue,
                ),
              ),
              SubmitButton(
                text: searchById ? 'Түрээслэх' : 'Хайх',
                padding: const EdgeInsets.all(5.0),
                onPressed: () {
                  if (formKey.currentState.validate()) Future(onSearchTap);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
