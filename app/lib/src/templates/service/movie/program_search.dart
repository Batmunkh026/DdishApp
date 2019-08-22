import 'package:ddish/src/widgets/submit_button.dart';
import 'package:ddish/src/widgets/text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ddish/src/widgets/message.dart' as message;

class ProgramSearchWidget extends StatelessWidget {
  final VoidCallback onSearchTap;
  final bool searchById;
  final TextEditingController controller;
  final VoidCallback onReturnTap;
  final GlobalKey<FormState> formKey;

  ProgramSearchWidget(
      {this.formKey,
      this.searchById,
      this.onSearchTap,
      this.controller,
      this.onReturnTap});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.43,
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
                ),
              ),
              Container(
                child: SubmitButton(
                  text: searchById ? 'Түрээслэх' : 'Хайх',
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  onPressed: () => _validateNotEmpty(context),
                ),
                width: MediaQuery.of(context).size.width * 0.3,
              ),
            ],
          ),
        ],
      ),
    );
  }

  _validateNotEmpty(context) {
    var input = controller.text;
    if (input.isEmpty) {
      FocusScope.of(context).unfocus();
      message.show(context, "Утга оруулна уу", message.SnackBarType.ERROR);
    } else
      Future(onSearchTap);
  }
}
