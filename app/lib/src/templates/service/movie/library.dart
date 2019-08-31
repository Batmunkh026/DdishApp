import 'dart:ui';

import 'package:ddish/src/blocs/service/movie/library/library_bloc.dart';
import 'package:ddish/src/blocs/service/movie/library/library_event.dart';
import 'package:ddish/src/blocs/service/movie/library/library_state.dart';
import 'package:ddish/src/models/result.dart';
import 'package:ddish/src/widgets/dialog.dart';
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
  List<String> posters = List();

  @override
  void initState() {
    _bloc = MovieLibraryBloc(this);
    super.initState();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 15, bottom: 15),
              child: ProgramSearchWidget(
                formKey: formKey,
                searchById: true,
                onSearchTap: onRentButtonTap,
                controller: movieIdFieldController,
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(bottom: 15),
              width: MediaQuery.of(context).size.width * 0.7,
              child: Text(
                'Шинээр нэмэгдэх',
                style: const TextStyle(
                    color: const Color(0xff071f49),
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                    fontSize: 13.0),
              ),
            ),
          ],
        ),
        BlocBuilder<MovieLibraryEvent, MovieLibraryState>(
          bloc: _bloc,
          builder: (BuildContext context, MovieLibraryState state) {
            if (state is ContentOrderRequestFinished && !state.isPresented) {
              state.isPresented = true;
              WidgetsBinding.instance.addPostFrameCallback(
                  (_) => _showResultMessage(state.result));
            }
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
    _bloc.isValidMovieId(movieIdFieldController.text).then((isValid) {
      var resultDialog;

      if (isValid)
        resultDialog = CustomDialog(
          important: true,
          title: 'Санамж',
          submitButtonText: 'Түрээслэх',
          closeButtonText: 'Болих',
          onSubmit: _onRentAgreeTap,
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
        );
      else
        resultDialog = CustomDialog(
          important: true,
          title: 'Анхааруулга',
          closeButtonText: 'Хаах',
          onSubmit: _onRentAgreeTap,
          content: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                  color: const Color(0xffe4f0ff),
                  fontStyle: FontStyle.normal,
                  fontSize: 14.0),
              children: <TextSpan>[
                TextSpan(
                    text: movieIdFieldController.text,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: " ID-тай кино олдсонгүй! "),
                TextSpan(text: ' Та шалгаад дахин оролдож үзнэ үү. '),
              ],
            ),
          ),
        );

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return resultDialog;
          });
    });
  }

  _onRentAgreeTap() {
    Navigator.pop(context);
    _bloc.dispatch(
        ContentOrderClicked(contentId: int.parse(movieIdFieldController.text)));
  }

  _showResultMessage(Result result) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(
            important: true,
            title: result.isSuccess ? 'Санамж' : 'Анхааруулга',
            closeButtonText: 'Болих',
            onSubmit: _onRentAgreeTap,
            content: Text(
              result.resultMessage,
              textAlign: TextAlign.center,
            ),
          );
        });
  }
}
