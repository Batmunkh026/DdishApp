import 'package:cached_network_image/cached_network_image.dart';
import 'package:ddish/src/models/vod_channel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChannelThumbnail extends StatelessWidget {
  var onPressed;
  final VodChannel channel;
  final double height;

  ChannelThumbnail({this.height, this.onPressed, this.channel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          height != null
              ? CachedNetworkImage(
                  height: height * 0.7,
                  fit: BoxFit.fitHeight,
                  imageUrl: channel.channelLogo,
                  alignment: Alignment.centerRight,
                  placeholder: (context, url) => Text(channel.productName),
                )
              : CachedNetworkImage(
                  fit: BoxFit.fitHeight,
                  imageUrl: channel.channelLogo,
                  alignment: Alignment.centerRight,
                  placeholder: (context, url) => Text(channel.productName),
                ),
          Expanded(
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
