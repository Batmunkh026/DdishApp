import 'dart:ui';

import 'package:ddish/src/blocs/service/movie/library/library_bloc.dart';
import 'package:ddish/src/blocs/service/movie/library/library_event.dart';
import 'package:ddish/src/blocs/service/movie/library/library_state.dart';
import 'package:ddish/src/repositiories/vod_repository.dart';
import 'package:ddish/src/widgets/dialog.dart';
import 'package:ddish/src/widgets/dialog_action.dart';
import 'package:ddish/src/widgets/movie/poster_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'program_search.dart';

class Library extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LibraryState();
}

class LibraryState extends State<Library> {
  TextEditingController movieIdFieldController;
  MovieLibraryBloc _bloc;
  VodRepository _repository;

  @override
  void initState() {
    _repository = VodRepository();
    _bloc = MovieLibraryBloc(repository: _repository);
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
          child: Column(
            children: <Widget>[
              Container(
                child: ProgramSearchWidget(
                  searchById: true,
                  onSearchTap: onRentAgreeTap,
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
            if (state is MovieListLoading) {
              _bloc.dispatch(MovieLibraryStarted());
              return Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            if (state is MovieListLoaded) {
              List posters = state.posterUrls;
              return Flexible(
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
                  TextSpan(text: ' киног түрээслэх гэж байна. '),
                ],
              ),
            ),
            actions: actions,
          );
        });
  }

  onRentAgreeTap() {
    // validart
  }
}
