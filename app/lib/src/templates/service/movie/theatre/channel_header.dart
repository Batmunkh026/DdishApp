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
    final headerContainerHeight = (height / 300) * 3.3 + 58;
    final date = widget.date;

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          FittedBox(
            fit: BoxFit.contain,
            child: GestureDetector(
              onHorizontalDragEnd: (details) {
                double _delta = details.velocity.pixelsPerSecond.dx;
                if (_delta > 0) widget.onReturnTap();
              },
              child: Container(
                height: headerContainerHeight,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    IconButton(
                      iconSize: 24.0,
                      color: Color(0xff3069b2),
                      disabledColor: Color(0xffe8e8e8),
                      icon: Icon(DdishAppIcons.before),
                      onPressed: widget.onReturnTap,
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 5, right: 50),
                      child: ChannelThumbnail(
                        height: headerContainerHeight,
                        channel: selectedChannel,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: headerContainerHeight * 0.65,
            child: FittedBox(
              child: Row(
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
            ),
          ),
          Line(
            color: Color(0xff3069b2),
            thickness: 1.0,
            margin: EdgeInsets.only(bottom: 10),
          )
        ],
      ),
    );
  }
}
