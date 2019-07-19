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
  final Function(DateTime, bool) onDateValueChanged;

  ChannelHeaderWidget(
      {this.date,
      this.selectedChannel,
      this.onReturnTap,
      this.onDateValueChanged});

  @override
  State<StatefulWidget> createState() => ChannelHeaderState();
}

class ChannelHeaderState extends State<ChannelHeaderWidget> {
  VodChannel selectedChannel;

  @override
  void initState() {
    selectedChannel = widget.selectedChannel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final date = widget.date;

    return Column(
      children: <Widget>[
        Container(
          height: height * 0.1,
          child: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Center(
                  child: ChannelThumbnail(
                    channel: selectedChannel,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  iconSize: 25.0,
                  color: Color(0xff3069b2),
                  disabledColor: Color(0xffe8e8e8),
                  icon: Icon(DdishAppIcons.before),
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
                onPressed: DateUtil.today(date)
                    ? null
                    : () => widget.onDateValueChanged(date, false),
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
                onPressed: DateUtil.isValidProgramDate(date)
                    ? () => widget.onDateValueChanged(date, true)
                    : null,
              ),
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
}
