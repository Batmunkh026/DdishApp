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
  Widget build(BuildContext context) {
    return BlocBuilder<MovieLibraryEvent, MovieLibraryState>(
      bloc: _bloc,
      builder: (BuildContext context, MovieLibraryState state) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Flexible(child: InputField(
                    hasBorder: true, placeholder: 'Кино ID оруулна уу', bottomMargin: 5.0, textController: movieIdFieldController,),),
                  SubmitButton(text: 'Түрээслэх', padding: const EdgeInsets.all(5.0), onPressed: () => onRentButtonTap(),),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  onRentButtonTap() {
    List<Widget> actions = new List();
    ActionButton rentMovie = ActionButton(title: 'Түрээслэх', onTap: () => onRentAgreeTap(),);
    ActionButton closeDialog = ActionButton(title: 'Болих', onTap: () => Navigator.pop(context),);
    actions.add(rentMovie);
    actions.add(closeDialog);
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: CustomDialog(
              important: true,
              title: 'Санамж',
              content: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                      color:  const Color(0xffe4f0ff),
                      fontFamily: "Montserrat",
                      fontStyle:  FontStyle.normal,
                      fontSize: 14.0
                  ),
                  children: <TextSpan>[
                    TextSpan(text: 'Та Кино сангаас '),
                    TextSpan(text: movieIdFieldController.text, style: TextStyle(fontWeight: FontWeight.w600)),
                    TextSpan(text: ' киног түрээслэх гэж байна. '),
                  ],
                ),
              ),
              actions: actions,
            ),
          );
        });
  }

  onRentAgreeTap() {
    // кино түрээслэх
  }
}