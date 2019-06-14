import 'dart:ui';

import 'package:ddish/src/blocs/service/movie/theatre/theatre_bloc.dart';
import 'package:ddish/src/blocs/service/movie/theatre/theatre_event.dart';
import 'package:ddish/src/blocs/service/movie/theatre/theatre_state.dart';
import 'package:ddish/src/models/movie.dart';
import 'package:ddish/src/models/program.dart';
import 'package:ddish/src/models/vod_channel.dart';
import 'package:ddish/src/repositiories/vod_repository.dart';
import 'package:ddish/src/utils/date_util.dart';
import 'package:ddish/src/widgets/dialog.dart';
import 'package:ddish/src/widgets/dialog_action.dart';
import 'package:ddish/src/widgets/line.dart';
import 'package:ddish/src/widgets/movie/channel_thumbnail.dart';
import 'package:ddish/src/widgets/movie/detail_button.dart';
import 'package:ddish/src/widgets/submit_button.dart';
import 'package:ddish/src/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'style.dart' as style;

class TheatreWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TheatreWidgetState();
}

class TheatreWidgetState extends State<TheatreWidget> {
  TextEditingController movieIdFieldController;
  VodRepository vodRepository;
  MovieTheatreBloc _bloc;
  DateTime date = DateTime.now();
  VodChannel selectedChannel;
  Program selectedProgram;

  @override
  void initState() {
    vodRepository = VodRepository();
    _bloc = MovieTheatreBloc(vodRepository: vodRepository);
    movieIdFieldController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  // resizeToAvoidBottomPadding: false,
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: selectedChannel == null
              ? Row(
                  children: <Widget>[
                    Flexible(
                      child: InputField(
                        hasBorder: true,
                        placeholder: 'Кино нэр оруулна уу',
                        bottomMargin: 5.0,
                        textController: movieIdFieldController,
                      ),
                    ),
                    SubmitButton(
                      text: 'Хайх',
                      padding: const EdgeInsets.all(5.0),
                      onPressed: () => onSearchTap(),
                    ),
                  ],
                )
              : Column(
                  children: <Widget>[
                    Container(
                      height: 70.0,
                      child: Stack(
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 50.0),
                            child: Center(
                              child: ChannelThumbnail(
                                channel: selectedChannel,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              iconSize: 40.0,
                              color: Color(0xff3069b2),
                              disabledColor: Color(0xffe8e8e8),
                              icon: Icon(Icons.arrow_back_ios),
                              onPressed: () => onReturnTap(),
                            ),
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          color: Color(0xff3069b2),
                          disabledColor: Color(0xffe8e8e8),
                          icon: Icon(Icons.arrow_back_ios),
                          onPressed: DateUtil.today(date)
                              ? null
                              : () => onDateChange(false),
                        ),
                        Text(
                          DateUtil.formatTheatreDate(date) +
                              (DateUtil.today(date) ? '  Өнөөдөр' : ''),
                          style: style.dateStyle,
                        ),
                        IconButton(
                            color: Color(0xff3069b2),
                            disabledColor: Color(0xffe8e8e8),
                            icon: Icon(
                              Icons.arrow_forward_ios,
                            ),
                            onPressed: date
                                        .difference(DateTime.now()
                                            .add(Duration(days: 7)))
                                        .inDays ==
                                    0
                                ? null
                                : () => onDateChange(true)),
                      ],
                    ),
                    Line(
                      color: Color(0xff3069b2),
                      thickness: 1.0,
                      margin: const EdgeInsets.only(bottom: 10.0),
                    )
                  ],
                ),
        ),
        BlocBuilder<MovieTheatreEvent, MovieTheatreState>(
          bloc: _bloc,
          builder: (BuildContext context, MovieTheatreState state) {
            if (state is TheatreStateInitial) {
              _bloc.dispatch(MovieTheatreStarted());
              return CircularProgressIndicator();
            }
            if (state is ChannelListLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is ChannelListLoaded) {
              List<VodChannel> channels = state.channelList;
              return GridView.count(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                crossAxisSpacing: 100.0,
                padding: const EdgeInsets.all(20.0),
                crossAxisCount: 2,
                children: List.generate(channels.length, (index) {
                  return ChannelThumbnail(
                    onPressed: () => onVodChannelTap(channels[index]),
                    channel: channels[index],
                  );
                }),
              );
            }
            if (state is ProgramListLoading) {
              return CircularProgressIndicator();
            }
            if (state is ProgramListLoaded) {
              List<Program> programList = state.programList;
              return Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: programList.length,
                  itemBuilder: (BuildContext context, int index) {
                    Program program = programList[index];
                    return Container(
                      height: 90.0,
                      child: GestureDetector(
                        onTap: () => onProgramTap(programList[index]),
                        child: ListTile(
                            // TODO poster placeholder
                            leading: Image.network(
                              program.posterUrl,
                              fit: BoxFit.contain,
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(program.contentNameMon,
                                    style: style.programTitleStyle),
                                Visibility(
                                  visible: program.contentGenres != null &&
                                      program.contentGenres.isNotEmpty,
                                  child: Text(program.contentGenres,
                                      style: style.programGenresStyle),
                                ),
                                Text(
                                    DateUtil.formatStringTime(
                                        program.beginDate),
                                    style: style.programStartTimeStyle),
                              ],
                            )),
                      ),
                    );
                  },
                ),
              );
            }
            if (state is ProgramDetailsLoading) {
              return CircularProgressIndicator();
            }
            if (state is ProgramDetailsLoaded) {
              Movie content = state.content;
              return Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: SizedBox(
                          height: 150.0,
                          child: Image.network(
                            state.content.posterUrl,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              child: Text(content.contentNameMon,
                                  style: style.programTitleStyle),
                            ),
                            Visibility(
                              visible: content.contentGenres != null &&
                                  content.contentGenres.isNotEmpty,
                              child: Text(content.contentGenres,
                                  style: style.programGenresStyle),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text(
                                  DateUtil.formatStringTime(
                                      selectedProgram.beginDate),
                                  style: style.programStartTimeStyle),
                            ),
                            Padding(
                                padding:
                                const EdgeInsets.symmetric(vertical: 5.0),
                            child: Text('${content.contentPrice} ₮',
                                style: style.priceStyle),),
                          ],
                        ),
                      )
                    ],
                  ),
                  Padding(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        DetailButton(text: 'Тайлбар', onTap: () => print('aa'),),
                        DetailButton(text: 'Видео', onTap: () => print('aa'),),
                        DetailButton(text: 'Зураг', onTap: () => print('aa'),),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                  ),
                  SubmitButton(
                    text: 'Түрээслэх',
                    onPressed: DateUtil.toDateTime(selectedProgram.beginDate)
                            .isBefore(DateTime.now())
                        ? null
                        : () => onRentAgreeTap(),
                    horizontalMargin: 50.0,
                  )
                ],
              );
            }
            return Container();
          },
        ),
      ],
    );
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
              title: 'Санамж',
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
                        text: movieIdFieldController.text,
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

  onDateChange(bool increment) {
    setState(() => date = increment
        ? date.add(Duration(days: 1))
        : date.subtract(Duration(days: 1)));
    if (selectedChannel != null)
      _bloc.dispatch(DateChanged(date: date, channel: selectedChannel));
  }

  onSearchTap() {
    // кино хайх
  }

  onRentAgreeTap() {
    // кино хайх
  }

  onProgramTap(Program program) {
    selectedProgram = program;
    _bloc.dispatch(ProgramTapped(selectedProgram: program));
  }

  onReturnTap() {
    if (selectedProgram != null) {
      setState(() => selectedProgram = null);
      _bloc.dispatch(ChannelSelected(channel: selectedChannel));
    } else if (selectedChannel != null) {
      date = DateTime.now();
      setState(() => selectedChannel = null);
      _bloc.dispatch(MovieTheatreStarted());
    }
  }

  onVodChannelTap(VodChannel channel) {
    setState(() => selectedChannel = channel);

    _bloc.dispatch(ChannelSelected(channel: channel));
  }
}
