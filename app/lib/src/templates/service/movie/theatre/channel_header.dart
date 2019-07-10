import 'package:ddish/presentation/ddish_flutter_app_icons.dart';
import 'package:ddish/src/models/vod_channel.dart';
import 'package:ddish/src/utils/date_util.dart';
import 'package:ddish/src/widgets/line.dart';
import 'package:ddish/src/widgets/movie/channel_thumbnail.dart';
import 'package:flutter/material.dart';

class ChannelHeaderWidget extends StatefulWidget {
  final DateTime date;
  final VodChannel selectedChannel;
  final VoidCallback onReturnTap;
  final ValueChanged<DateTime> onDateValueChanged;

  ChannelHeaderWidget(
      {this.date,
      this.selectedChannel,
      this.onReturnTap,
      this.onDateValueChanged});

  @override
  State<StatefulWidget> createState() => ChannelHeaderState();
}

class ChannelHeaderState extends State<ChannelHeaderWidget> {
  DateTime date = DateTime.now();
  VodChannel selectedChannel;

  @override
  void initState() {
    date = widget.date;
    selectedChannel = widget.selectedChannel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: <Widget>[
        Container(
          height: height * 0.1,
          child: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.15),
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
                  onPressed: widget.onReturnTap,
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Visibility(
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              visible: widget.onDateValueChanged != null,
              child: IconButton(
                color: Color(0xff3069b2),
                disabledColor: Color(0xffe8e8e8),
                icon: Icon(DdishAppIcons.before),
                onPressed:
                    DateUtil.today(date) ? null : () => onDateChange(false),
              ),
            ),
            Text(
              DateUtil.formatTheatreDate(date) +
                  (DateUtil.today(date) ? '  Өнөөдөр' : ''),
              style: const TextStyle(
                color: const Color(0xff071f49),
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                fontSize: 15.0,
              ),
            ),
            Visibility(
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              visible: widget.onDateValueChanged != null,
              child: IconButton(
                  color: Color(0xff3069b2),
                  disabledColor: Color(0xffe8e8e8),
                  icon: Icon(DdishAppIcons.next),
                  onPressed: date
                              .difference(DateTime.now().add(Duration(days: 7)))
                              .inDays ==
                          0
                      ? null
                      : () => onDateChange(true)),
            ),
          ],
        ),
        Line(
          color: Color(0xff3069b2),
          thickness: 1.0,
          margin: const EdgeInsets.only(bottom: 10.0),
        )
      ],
    );
  }

  onDateChange(bool increment) {
    setState(() {
      date = increment
          ? date.add(Duration(days: 1))
          : date.subtract(Duration(days: 1));
    });
    widget.onDateValueChanged(date);
  }
}
