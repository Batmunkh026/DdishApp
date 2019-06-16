import 'dart:ui';

import 'package:ddish/src/models/movie.dart';
import 'package:ddish/src/utils/date_util.dart';
import 'package:ddish/src/widgets/dialog.dart';
import 'package:ddish/src/widgets/dialog_action.dart';
import 'package:ddish/src/widgets/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'detail_button.dart';
import 'dialog_close.dart';
import 'style.dart' as style;

class ProgramDescription extends StatelessWidget {
  final Movie program;
  final String beginDate;
  BuildContext context;

  ProgramDescription({this.program, this.beginDate});

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SizedBox(
                height: 150.0,
                child: Image.network(
                  program.posterUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    child: Text(program.contentNameMon,
                        style: style.programTitleStyle),
                  ),
                  Visibility(
                    visible: program.contentGenres != null &&
                        program.contentGenres.isNotEmpty,
                    child: Text(program.contentGenres,
                        style: style.programGenresStyle),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(DateUtil.formatStringTime(beginDate),
                        style: style.programStartTimeStyle),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Text('${program.contentPrice} ₮',
                        style: style.priceStyle),
                  ),
                ],
              ),
            )
          ],
        ),
        Padding(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              DetailButton(
                text: 'Тайлбар',
                onTap: program.contentDescr != null ||
                        program.contentDescr.isNotEmpty
                    ? () => showOverview(program)
                    : null,
              ),
              DetailButton(
                text: 'Видео',
                onTap: program.trailerUrl.length == 11
                    ? () => showTrailer(program)
                    : null,
              ),
              DetailButton(
                text: 'Зураг',
                onTap: program.posterUrl != null && program.posterUrl.isNotEmpty
                    ? () => showPoster(program)
                    : null,
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 10.0),
        ),
        SubmitButton(
          text: 'Түрээслэх',
          onPressed: DateUtil.toDateTime(beginDate).isBefore(DateTime.now())
              ? null
              : () => onRentButtonTap(),
          horizontalMargin: 50.0,
        )
      ],
    );
  }

  showOverview(Movie content) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: CustomDialog(
                hasDivider: false,
                title: Row(
                  children: <Widget>[
                    SizedBox(
                      height: 150.0,
                      child: Image.network(
                        content.posterUrl,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              child: Text(content.contentNameMon,
                                  style: style.programTitleStyleDialog),
                            ),
                            Visibility(
                              visible: content.contentGenres != null &&
                                  content.contentGenres.isNotEmpty,
                              child: Text(content.contentGenres,
                                  style: style.programGenresStyleDialog),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text(DateUtil.formatStringTime(beginDate),
                                  style: style.programStartTimeStyleDialog),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                content: Column(
                  children: <Widget>[
                    Text(
                      content.contentDescr,
                      style: style.contentDescriptionStyle,
                    ),
                    DialogCloseButton(onTap: () => Navigator.pop(context)),
                  ],
                )),
          );
        });
  }

  onRentButtonTap() {
    List<Widget> actions = new List();
    ActionButton rentMovie = ActionButton(
      title: 'Түрээслэх',
      onTap: () => onRentAgreeTap(),
    );
    ActionButton closeDialog = ActionButton(
      title: 'Болих',
      onTap: () => Navigator.pop(context),
    );
    actions.add(rentMovie);
    actions.add(closeDialog);
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: CustomDialog(
              important: true,
              title: Text('Санамж',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: const Color(0xfffcfdfe),
                      fontWeight: FontWeight.w600,
                      fontFamily: "Montserrat",
                      fontStyle: FontStyle.normal,
                      fontSize: 15.0)),
              content: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                      color: const Color(0xffe4f0ff),
                      fontFamily: "Montserrat",
                      fontStyle: FontStyle.normal,
                      fontSize: 14.0),
                  children: <TextSpan>[
                    TextSpan(text: 'Та Кино сангаас '),
                    TextSpan(
                        text: program.contentNameMon,
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    TextSpan(text: ' киног түрээслэх гэж байна. '),
                  ],
                ),
              ),
              actions: actions,
            ),
          );
        });
  }

  onRentAgreeTap() {
    // кино хайх
  }

  showTrailer(Movie content) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Stack(
              children: <Widget>[
                CustomDialog(
                  padding: const EdgeInsets.all(0.0),
                  hasDivider: false,
                  content: YoutubePlayer(
                    context: context,
                    videoId: content.trailerUrl,
                    autoPlay: false,
                    showVideoProgressIndicator: true,
                    videoProgressIndicatorColor: Colors.red,
                  ),
                ),
                Align(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 50.0),
                    child:
                        DialogCloseButton(onTap: () => Navigator.pop(context)),
                  ),
                  alignment: Alignment.bottomCenter,
                )
              ],
            ),
          );
        });
  }

  showPoster(Movie content) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: CustomDialog(
              hasDivider: false,
              content: SizedBox(
                  height: 500.0,
                  child: Stack(
                    children: <Widget>[
                      Image.network(
                        content.posterUrl,
                        fit: BoxFit.contain,
                      ),
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: DialogCloseButton(
                            onTap: () => Navigator.pop(context),
                          ))
                    ],
                  )),
            ),
          );
        });
  }
}