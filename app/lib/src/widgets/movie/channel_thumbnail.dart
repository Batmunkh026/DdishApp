import 'package:cached_network_image/cached_network_image.dart';
import 'package:ddish/src/models/vod_channel.dart';
import 'package:flutter/cupertino.dart';

class ChannelThumbnail extends StatelessWidget {
  var onPressed;
  final VodChannel channel;

  ChannelThumbnail({this.onPressed, this.channel});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      child: Stack(
        children: <Widget>[
          Center(
            child: CachedNetworkImage(
              imageUrl: channel.channelLogo,
              placeholder: (context, url) => Text(channel.productName),
              fit: BoxFit.contain,
            ),
          ),
          Align(
            child: Text('/${channel.channelNo}/', style: TextStyle(
                color:  const Color(0xff071f49),
                fontWeight: FontWeight.w400,
                fontStyle:  FontStyle.normal,
            ),),
            alignment: Alignment.bottomRight,
          )
        ],
      ),
      onTap: onPressed,
    );
  }
}
