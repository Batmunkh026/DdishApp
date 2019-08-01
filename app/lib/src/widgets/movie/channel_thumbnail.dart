import 'package:cached_network_image/cached_network_image.dart';
import 'package:ddish/src/models/vod_channel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChannelThumbnail extends StatelessWidget {
  var onPressed;
  final VodChannel channel;

  ChannelThumbnail({this.onPressed, this.channel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Flexible(
            child: CachedNetworkImage(
              imageUrl: channel.channelLogo,
              placeholder: (context, url) => Text(channel.productName),
              fit: BoxFit.contain,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              '/${channel.channelNo}/',
              style: TextStyle(
                color: const Color(0xff071f49),
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
              ),
            ),
          )
        ],
      ),
      onTap: onPressed,
    );
  }
}
