import 'package:flutter/material.dart';
import 'package:ddish/src/widgets/dialog.dart';
import 'package:ddish/src/widgets/dialog_action.dart';
import 'dart:ui';
import 'package:ddish/src/blocs/service/movie/library/library_bloc.dart';
import 'package:ddish/src/blocs/service/movie/library/library_event.dart';
import 'package:ddish/src/blocs/service/movie/library/library_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ddish/src/widgets/text_field.dart';
import 'package:ddish/src/widgets/submit_button.dart';
import 'package:ddish/src/widgets/movie/thumbnail.dart';
import 'package:ddish/src/models/movie.dart';

class Library extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LibraryState();
}

class LibraryState extends State<Library> {
  TextEditingController movieIdFieldController;
  MovieLibraryBloc _bloc;

  @override
  void initState() {
    _bloc = MovieLibraryBloc();
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
                  Flexible(
                    child: InputField(
                      align: TextAlign.center,
                      placeholder: 'Кино ID оруулна уу',
                      bottomMargin: 5.0,
                      textController: movieIdFieldController,
                    ),
                  ),
                  SubmitButton(
                    text: 'Түрээслэх',
                    padding: const EdgeInsets.all(5.0),
                    onPressed: () => onRentButtonTap(),
                  ),
                ],
              ),
            ],
          ),
        ),
        BlocBuilder<MovieLibraryEvent, MovieLibraryState>(
          bloc: _bloc,
          builder: (BuildContext context, MovieLibraryState state) {
            if (state is MovieListLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is MovieListLoaded) {
              List movies = state.movies;
              return GridView.count(
                crossAxisCount: 3,
                children: <Widget>[
                  ListView.builder(
                    itemCount: movies.length,
                    itemBuilder: (BuildContext context, int index) {
                      return MovieThumbnail(movie: movies[index], onTap: _onMovieThumbnailTap(movies[index]),);
                    },
                  ),
                ],
              );
            }
            if(state is MovieIdConfirmProcessing) {
              return CircularProgressIndicator();
            }
            if(state is MovieIdProcessingFinished) {
              onRentButtonTap();
            }
            if(state is MovieDetailsOpened) {
              // TODO pop movie details dialog
              return Container();
            }
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
              title: Text('Санамж',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: const Color(0xfffcfdfe),
                      fontWeight: FontWeight.w600,
                      fontFamily: "Montserrat",
                      fontStyle: FontStyle.normal,
                      fontSize: 15.0)),
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

  _onMovieThumbnailTap(Movie tappedMovie) {
    _bloc.dispatch(MovieSelected(selectedMovie: tappedMovie));
  }

  onRentAgreeTap() {
    // кино түрээслэх
  }
}
