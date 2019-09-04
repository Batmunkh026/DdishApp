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
import 'package:ddish/src/widgets/preview.dart';
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

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Stack(
            children: <Widget>[
              BackdropFilter(
                child: Container(
                  height: height,
                  width: width,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(7, 28, 67, 0.6),
                  ),
                  child: BackdropFilter(
                    child: Align(
                      child: BackdropFilter(
                        child: Container(
                          width: width * 0.95,
                          height: width * 0.5,
                          child: Center(
                            child: YoutubePlayer(
                              context: context,
                              videoId: content.trailerUrl,
                              showVideoProgressIndicator: true,
                              videoProgressIndicatorColor: Colors.red,
                            ),
                          ),
                        ),
                        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      ),
                      alignment: Alignment.center,
                    ),
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  ),
                ),
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
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
          );
        }).then((_) => _bloc.cancelSessionUpdateTask(sessionUpdateTask));
  }

  buildButtons() {
    var width = MediaQuery.of(context).size.width * .98;
    List<Widget> buttons = [
      Preview(
        label: 'Тайлбар',
        isClickAble:
            _content.contentDescr != null || _content.contentDescr.isNotEmpty,
        previewWidget: createContentOverview(_content),
        size: Size(
          width,
          width * 1.2,
        ),
      ),
      DetailButton(
        text: 'Видео',
        onTap: _content.trailerUrl.length == 11
            ? () => showTrailer(_content)
            : null,
      ),
      Preview(
        label: 'Зураг',
        isClickAble:
            _content.posterUrl != null && _content.posterUrl.isNotEmpty,
        previewWidget: PosterImage(url: _content.posterUrl),
      )
    ];
    return List<Widget>.from(buttons.map((btn) => Container(
          child: btn,
          width: MediaQuery.of(context).size.width * 0.25,
        )));
  }

  createContentOverview(content) {
    final width = MediaQuery.of(context).size.width;
    return Column(children: [
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
                    padding: const EdgeInsets.only(top: 5.0, bottom: 10),
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
      )
    ]);
  }
}
