import 'package:cached_network_image/cached_network_image.dart';
import 'package:ddish/src/blocs/menu/promo/antenn_bloc.dart';
import 'package:ddish/src/blocs/menu/promo/antenn_event.dart';
import 'package:ddish/src/blocs/menu/promo/antenn_state.dart';
import 'package:ddish/src/models/promo.dart';
import 'package:ddish/src/repositiories/promo_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AntennaWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AntennaWidgetState();
}

class AntennaWidgetState extends State<AntennaWidget> {
  AntennaBloc _bloc;
  AntennRepository _repository;
  List<AntennMdl> manuals;
  //List<String> manuals;

  @override
  void initState() {
    manuals = List<AntennMdl>();
    //manuals = List<String>();
    _repository = AntennRepository();
    _bloc = AntennaBloc(repository: _repository);
    super.initState();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AntennaEvent, AntennaState>(
      bloc: _bloc,
      builder: (BuildContext context, AntennaState state) {
        if (state is AntennaWidgetLoading) {
          return Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (state is AntennaWidgetStarted) {
          _bloc.dispatch(AntennaEventStarted());
        }
        if (state is AntennaWidgetLoaded) {
          manuals = state.manualList;
          return manuals != null
              ? Flexible(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                    child: ListView.builder(
                      itemCount: manuals.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: GestureDetector(
                            child: Container(
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                                child: CachedNetworkImage(
                                  imageUrl: manuals[index].imageUrl,
                                  placeholder: (context, url) => Container(
                                    color: Colors.black12,
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    height: 100,
                                    child: Center(
                                      child: new CircularProgressIndicator(),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      new Icon(Icons.error),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              : Container();
        }
        return Container();
      },
    );
  }
}
