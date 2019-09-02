import 'dart:async';
import 'dart:ui';
import 'dart:ui' as prefix0;

import 'package:ddish/src/blocs/service/movie/description_bloc.dart';
import 'package:ddish/src/blocs/service/movie/description_event.dart';
import 'package:ddish/src/blocs/service/movie/description_state.dart';
import 'package:ddish/src/models/movie.dart';
import 'package:ddish/src/models/program.dart';
import 'package:ddish/src/models/result.dart';
import 'package:ddish/src/models/vod_channel.dart';
import 'package:ddish/src/utils/date_util.dart';
import 'package:ddish/src/widgets/dialog.dart';
import 'package:ddish/src/widgets/movie/poster_image.dart';
import 'package:ddish/src/widgets/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'detail_button.dart';
import 'dialog_close.dart';
import 'style.dart' as style;

class ProgramDescription extends StatefulWidget {
  final Movie content;
  final VodChannel channel;
  final Program selectedProgram;

  ProgramDescription({this.content, this.channel, this.selectedProgram});

  @override
  State<StatefulWidget> createState() => ProgramDescriptionStatus();
}

class ProgramDescriptionStatus extends State<ProgramDescription> {
  Movie _content;
  DateTime _beginDate;
  ProgramDescriptionBloc _bloc;

  @override
  initState() {
    _content = widget.content;
    _beginDate = widget.selectedProgram.beginDate;
    _bloc = ProgramDescriptionBloc(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return BlocBuilder<DescriptionEvent, DescriptionState>(
      bloc: _bloc,
      builder: (BuildContext context, DescriptionState state) {
        bool alreadyRented =
            state is RentRequestFinished && state.result.isSuccess == true ||
                _content.isOrdered;
        if (state is RentRequestFinished && state.isNotOpened) {
          WidgetsBinding.instance
              .addPostFrameCallback((_) => showResultMessage(state.result));
          state.isNotOpened = false;
        }

        return ListView(
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SizedBox(
                    height: height / 4.5,
                    child: PosterImage(
                      url: _content.posterUrl,
                    ),
                  ),
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        child: Text(_content.contentNameMon,
                            style: style.programTitleStyle),
                      ),
                      Visibility(
                        visible: _content.contentGenres != null &&
                            _content.contentGenres.isNotEmpty,
                        child: Text(_content.contentGenres,
                            style: style.programGenresStyle),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text(DateUtil.formatTime(_beginDate),
                            style: style.programStartTimeStyle),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Text('${widget.selectedProgram.contentPrice} ₮',
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
                children: buildButtons(),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10.0),
            ),
            Center(
              child: state is RentRequestProcessing
                  ? CircularProgressIndicator()
                  : SubmitButton(
                      text: alreadyRented ? 'Түрээслэсэн' : 'Түрээслэх',
                      onPressed:
                          alreadyRented || _beginDate.isBefore(DateTime.now())
                              ? null
                              : () => onRentButtonTap(),
                      horizontalMargin: 50.0,
                    ),
            )
          ],
        );
      },
    );
  }

  Future showResultMessage(Result result) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(
            title: 'Санамж',
            closeButtonText: 'Хаах',
            content: result.isSuccess
                ? RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(style: style.dialogTextStyle, children: [
                      TextSpan(text: 'Та '),
                      TextSpan(
                        text: widget.channel.productName,
                        style: style.dialogHighlightedTextStyle,
                      ),
                      TextSpan(text: ' кино сувгаас '),
                      TextSpan(
                        text: _content.contentNameMon,
                        style: style.dialogHighlightedTextStyle,
                      ),
                      TextSpan(
                          text:
                              ' киног амжилттай түрээслэлээ. Давталтыг үнэгүй үзэх боломжтой.'),
                    ]),
                  )
                : Text(
                    'Таны дансны үлдэгдэгдэл хүрэлцэхгүй байна. Та дансаа цэнэглээд дахин оролдоно уу.',
                    style: style.dialogTextStyle,
                  ),
          );
        });
  }

  showOverview(Movie content) {
    final width = MediaQuery.of(context).size.width;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(
            content: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(left: 10.0, bottom: 10.0),
                      width: width * 0.26,
                      child: PosterImage(
                        url: content.posterUrl,
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
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
                              padding:
                                  const EdgeInsets.only(top: 5.0, bottom: 10),
                              child: Text(DateUtil.formatTime(_beginDate),
                                  style: style.programStartTimeStyleDialog),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    content.contentDescr,
                    textAlign: TextAlign.justify,
                    style: style.contentDescriptionStyle,
                  ),
                ),
              ],
            ),
            backgroundBlurFilter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
          );
        });
  }

  onRentButtonTap() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(
            important: true,
            title: 'Санамж',
            submitButtonText: 'Түрээслэх',
            closeButtonText: 'Болих',
            onSubmit: _onRentAgreeTap,
            content: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                    color: const Color(0xffe4f0ff),
                    fontStyle: FontStyle.normal,
                    fontSize: 14.0),
                children: <TextSpan>[
                  TextSpan(text: 'Та Кино сангаас '),
                  TextSpan(
                      text: _content.contentNameMon,
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  TextSpan(text: ' киног түрээслэх гэж байна. '),
                ],
              ),
            ),
          );
        });
  }

  _onRentAgreeTap() {
    Navigator.pop(context);
    _bloc.dispatch(RentTapped(rentProgram: widget.selectedProgram));
  }

  showTrailer(Movie content) {
    Timer sessionUpdateTask = _bloc.updateSession();

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Stack(
                children: <Widget>[
                  SimpleDialog(
                    contentPadding: const EdgeInsets.all(0.0),
                    children: <Widget>[
                      Align(
                        child: YoutubePlayer(
                          context: context,
                          videoId: content.trailerUrl,
                          showVideoProgressIndicator: true,
                          videoProgressIndicatorColor: Colors.red,
                        ),
                        alignment: Alignment.center,
                      ),
                    ],
                  ),
                  Align(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 50.0),
                      child: DialogCloseButton(onTap: () {
                        Navigator.pop(context);
                        _bloc.cancelSessionUpdateTask(sessionUpdateTask);
                      }),
                    ),
                    alignment: Alignment.bottomCenter,
                  )
                ],
              ));
        }).then((_) => _bloc.cancelSessionUpdateTask(sessionUpdateTask));
  }

  showPoster(Movie content) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          final width = MediaQuery.of(context).size.width;
          final double dialogWidth = width * 0.96;
          final double dialogHeight = dialogWidth * 1.5;

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(50, 88, 150, 1),
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                ),
                height: dialogHeight,
                width: dialogWidth,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 30, left: 30, right: 30),
                        height: dialogHeight - 60,
                        child: PosterImage(
                          url: content.posterUrl,
                        ),
                      ),
                      DialogCloseButton(onTap: () => Navigator.pop(context))
                    ],
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      stops: [0.01, 0.2, 0.8, 0.99],
                      colors: [
                        Color.fromRGBO(34, 72, 133, 0.1),
                        Colors.white24.withOpacity(0.1),
                        Colors.white24.withOpacity(0.1),
                        Color.fromRGBO(34, 72, 133, 0.1),
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }

  buildButtons() {
    List<Widget> buttons = [
      DetailButton(
        text: 'Тайлбар',
        onTap: _content.contentDescr != null || _content.contentDescr.isNotEmpty
            ? () => showOverview(_content)
            : null,
      ),
      DetailButton(
        text: 'Видео',
        onTap: _content.trailerUrl.length == 11
            ? () => showTrailer(_content)
            : null,
      ),
      DetailButton(
        text: 'Зураг',
        onTap: _content.posterUrl != null && _content.posterUrl.isNotEmpty
            ? () => showPoster(_content)
            : null,
      )
    ];
    return List<Widget>.from(buttons.map((btn) => Container(
          child: btn,
          width: MediaQuery.of(context).size.width * 0.25,
        )));
  }
}
