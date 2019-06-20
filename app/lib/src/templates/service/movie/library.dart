import 'dart:ui';

import 'package:ddish/src/blocs/service/movie/library/library_bloc.dart';
import 'package:ddish/src/blocs/service/movie/library/library_event.dart';
import 'package:ddish/src/blocs/service/movie/library/library_state.dart';
import 'package:ddish/src/models/result.dart';
import 'package:ddish/src/repositiories/vod_repository.dart';
import 'package:ddish/src/widgets/dialog.dart';
import 'package:ddish/src/widgets/dialog_action.dart';
import 'package:ddish/src/widgets/message.dart' as message;
import 'package:ddish/src/widgets/movie/poster_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'program_search.dart';

class Library extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LibraryState();
}

class LibraryState extends State<Library> {
  final movieIdFieldController = TextEditingController();
  MovieLibraryBloc _bloc;
  VodRepository _repository;
  List<String> posters = List();

  @override
  void initState() {
    _repository = VodRepository();
    _bloc = MovieLibraryBloc(repository: _repository);
    super.initState();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
          child: Column(
            children: <Widget>[
              Container(
                child: ProgramSearchWidget(
                  searchById: true,
                  onSearchTap: onRentButtonTap,
                  controller: movieIdFieldController,
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  'Шинээр нэмэгдэх',
                  style: const TextStyle(
                      color: const Color(0xff071f49),
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal,
                      fontSize: 15.0),
                ),
              ),
            ],
          ),
        ),
        BlocBuilder<MovieLibraryEvent, MovieLibraryState>(
          bloc: _bloc,
          builder: (BuildContext context, MovieLibraryState state) {
            if (state is ContentOrderRequestFinished)
              WidgetsBinding.instance.addPostFrameCallback(
                  (_) => _showResultMessage(state.result));
            if (state is ContentListLoading) {
              _bloc.dispatch(ContentLibraryStarted());
              return Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            if (state is ContentListLoaded) posters = state.posterUrls;

            return posters != null
                ? Flexible(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                      child: GridView.count(
                        mainAxisSpacing: 30.0,
                        crossAxisCount: 3,
                        children: List.generate(
                          posters.length,
                          (index) {
                            return PosterImage(
                              url: posters[index],
                            );
                          },
                        ),
                      ),
                    ),
                  )
                : Container();
          },
        ),
      ],
    );
  }

  onRentButtonTap() {
    List<Widget> actions = new List();
    ActionButton rentMovie = ActionButton(
      title: 'Түрээслэх',
      onTap: () {
        Navigator.pop(context);
        _bloc.dispatch(ContentOrderClicked(
            contentId: int.parse(movieIdFieldController.text)));
      },
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
          return CustomDialog(
            important: true,
            title: Text('Санамж',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: const Color(0xfffcfdfe),
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal,
                    fontSize: 15.0)),
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
                      text: movieIdFieldController.text,
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  TextSpan(text: ' ID-тай киног түрээслэх гэж байна. '),
                ],
              ),
            ),
            actions: actions,
          );
        });
  }

  _showResultMessage(Result result) {
    message.show(
        context,
        result.resultMessage,
        result.isSuccess
            ? message.SnackBarType.SUCCESS
            : message.SnackBarType.ERROR);
  }
}
