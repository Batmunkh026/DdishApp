import 'package:ddish/src/models/program.dart';
import 'package:ddish/src/utils/date_util.dart';
import 'package:ddish/src/widgets/movie/poster_image.dart';
import 'package:flutter/material.dart';

import 'style.dart' as style;

class ProgramTile extends StatelessWidget {
  final Program program;
  final VoidCallback onTap;

  ProgramTile({this.program, this.onTap});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Container(
      height: height * 0.15,
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: GestureDetector(
        onTap: onTap,
        child: ListTile(
          title: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: PosterImage(
                  url: program.posterUrl,
                ),
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(program.contentNameMon,
                        overflow: TextOverflow.ellipsis,
                        style: style.programTitleStyle),
                    Visibility(
                      visible: program.contentGenres != null &&
                          program.contentGenres.isNotEmpty,
                      child: Text(program.contentGenres,
                          overflow: TextOverflow.ellipsis,
                          style: style.programGenresStyle),
                    ),
                    Text(DateUtil.formatDateAndTime(program.beginDate),
                        style: style.programStartTimeStyle),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
