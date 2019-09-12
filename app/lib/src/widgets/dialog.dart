import 'dart:ui';

import 'package:flutter/material.dart';
import 'dialog_action.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final bool important;
  final String submitButtonText;
  final VoidCallback onSubmit;
  final VoidCallback onClose;
  final String closeButtonText;
  final EdgeInsets padding;
  ImageFilter backgroundBlurFilter = ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0);

  CustomDialog({
    this.title,
    this.content,
    this.important = false,
    this.submitButtonText,
    this.onSubmit,
    this.onClose,
    this.closeButtonText,
    this.padding = const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
    backgroundBlurFilter,
  }) {
    if (backgroundBlurFilter != null)
      this.backgroundBlurFilter = backgroundBlurFilter;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    bool hasCloseText = closeButtonText != null;

    return SimpleDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      contentPadding: const EdgeInsets.all(0.0),
      backgroundColor: Color.fromRGBO(103, 170, 255, 0.5),
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: BackdropFilter(
            filter: backgroundBlurFilter,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: title != null
                      ? FittedBox(
                          child: Text(
                            title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xfffcfdfe),
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                          fit: BoxFit.scaleDown,
                        )
                      : SizedBox.shrink(),
                ),
                Container(
                  child: content,
                  padding: padding,
                ),
                Visibility(
                  visible: hasCloseText,
                  child: Divider(
                    height: 1.0,
                  ),
                ),
                FittedBox(
                  child: Container(
                      height: 45 + MediaQuery.of(context).devicePixelRatio,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Visibility(
                            maintainState: false,
                            maintainAnimation: false,
                            maintainSize: false,
                            visible: submitButtonText != null,
                            child: ActionButton(
                              title: submitButtonText,
                              onTap: onSubmit,
                            ),
                          ),
                          Visibility(
                            maintainState: false,
                            maintainAnimation: false,
                            maintainSize: false,
                            visible: submitButtonText != null,
                            child: Align(
                              alignment: Alignment.center,
                              child: SizedBox(
                                child: VerticalDivider(
                                  width: 1.0,
                                ),
                              ),
                            ),
                          ),
                          ActionButton(
                            title: closeButtonText,
                            onTap: onClose != null
                                ? onClose
                                : () => Navigator.pop(context),
                          ),
                        ],
                      )),
                  fit: BoxFit.contain,
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
