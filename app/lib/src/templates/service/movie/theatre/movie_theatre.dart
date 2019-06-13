import 'package:ddish/src/models/program.dart';
import 'package:ddish/src/models/vod_channel.dart';
import 'package:ddish/src/repositiories/vod_repository.dart';
import 'package:flutter/material.dart';
import 'package:ddish/src/widgets/dialog.dart';
import 'package:ddish/src/widgets/dialog_action.dart';
import 'dart:ui';
import 'package:ddish/src/blocs/service/movie/theatre/theatre_bloc.dart';
import 'package:ddish/src/blocs/service/movie/theatre/theatre_event.dart';
import 'package:ddish/src/blocs/service/movie/theatre/theatre_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ddish/src/widgets/text_field.dart';
import 'package:ddish/src/widgets/submit_button.dart';
import 'package:ddish/src/utils/date_util.dart';
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
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      debugPrint(date.difference(DateTime.now()).inDays.toString());
                      if (date.difference(DateTime.now()).inDays != 0)
                          onDateChange(false);
                    },
                  ),
                  Text(DateUtil.formatTheatreDate(date)),
                  IconButton(
                      icon: Icon(
                        Icons.arrow_forward_ios,
                      ),
                      onPressed: date.difference(DateTime.now().add(Duration(days: 7))).inDays == 0
                          ? null
                          : () => onDateChange(true)),
//                  Flexible(
//                    child: InputField(
//                      hasBorder: true,
//                      placeholder: 'Кино нэр оруулна уу',
//                      bottomMargin: 5.0,
//                      textController: movieIdFieldController,
//                    ),
//                  ),
//                  SubmitButton(
//                    text: 'Хайх',
//                    padding: const EdgeInsets.all(5.0),
//                    onPressed: () => onSearchTap(),
//                  ),
                ],
              ),
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
                  return DecoratedBox(
                      decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        channels[index].channelLogo,
                      ),
                      fit: BoxFit.contain,
                    ),
                  ));
                }),
              );
            }
            if (state is ProgramListLoading) {
              return Column(
                children: <Widget>[
                  SizedBox(
                    height: 50.0,
                    width: 100.0,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.red,
                      ),
                      child: Text(state.channel.productName),
                    ),
                  ),
                  CircularProgressIndicator(),
                ],
              );
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
                      height: 100.0,
                      child: ListTile(
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
                              Text(DateUtil.formatStringTime(program.beginDate),
                                  style: style.programGenresStyle),
                            ],
                          )),
                    );
                  },
                ),
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
  }

  onSearchTap() {
    // кино хайх
  }

  onRentAgreeTap() {
    // кино хайх
  }

  onVodChannelTap(VodChannel channel) {
    _bloc.dispatch(ChannelSelected(channel: channel));
  }
}
