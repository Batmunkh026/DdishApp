import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ddish/src/blocs/menu/promo/promo_bloc.dart';
import 'package:ddish/src/blocs/menu/promo/promo_event.dart';
import 'package:ddish/src/blocs/menu/promo/promo_state.dart';
import 'package:ddish/src/models/promo.dart';
import 'package:ddish/src/repositiories/promo_repository.dart';
import 'package:ddish/src/templates/menu/menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PromoWidget extends StatefulWidget implements MenuAccessible {
  @override
  State<StatefulWidget> createState() => PromoWidgetState();

  @override
  var onBack;

  @override
  bool hasBackState = false;
}

class PromoWidgetState extends State<PromoWidget> {
  PromoBloc _bloc;
  PromoRepository _repository;
  List<NewPromoMdl> promotions;
  bool loading = false;

  @override
  void initState() {
    promotions = List<NewPromoMdl>();
    _repository = PromoRepository();
    _bloc = PromoBloc(this, repository: _repository);
    super.initState();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PromoEvent, PromoState>(
      bloc: _bloc,
      builder: (BuildContext context, PromoState state) {
        widget.hasBackState = _bloc.hasBackState;

        if (state is PromoWidgetLoading) {
          return Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (state is PromoWidgetStarted) {
          _bloc.dispatch(PromoStarted());
        }

        if (state is PromoWidgetLoaded) {
          promotions = state.promoList;
          return promotions != null
              ? Flexible(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                    child: ListView.builder(
                      itemCount: promotions.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(10),
                          child: GestureDetector(
                            child: Container(
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                child: CachedNetworkImage(
                                  imageUrl: promotions[index].PromoPosterUrl,
                                  placeholder: (context, url) => Container(
                                    color: Colors.black12,
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    height: 100,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      new Icon(Icons.error),
                                ),
                              ),
                            ),
                            onTap: () => onPromotionTap(promotions[index]),
                          ),
                        );
                      },
                    ),
                  ),
                )
              : Container();
        }
        if (state is PromoWidgetTapped) {
          return Flexible(
            child: Container(
              padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 36.0),
              child: ListView.builder(
                itemCount: state.selectedPromo.detials.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: buildChild(index, state.selectedPromo));
                },
              ),
            ),
          );
        }
//        if (state is PromoWidgetDetialTapped) {
//          return Expanded(
//            child: Container(
//              child: ListView(
//                scrollDirection: Axis.vertical,
//                reverse: false,
//                children: <Widget>[
//                  RichText(
//                    text: TextSpan(
//                        text: state.selectedPromo.PromoDescText,
//                        style: const TextStyle(
//                          color: const Color(0xffFFFFF0),
//                          fontWeight: FontWeight.bold,
//                          fontStyle: FontStyle.normal,
//                          //fontSize: 16.0,
//                          fontFamily: 'Montserrat',
//                        )),
//                  )
//                ].reversed.toList(),
//              ),
//              padding: EdgeInsets.only(right: 15, left: 15),
//            ),
//          );
//        }
        return Container();
      },
    );
  }

  onPromotionTap(NewPromoMdl promo) {
    _bloc.dispatch(PromoTapped(promo));
    widget.onBack = () => _bloc.dispatch(BackToState());
  }
//
//  onPromotionDetialTap(NewPromoMdl promo) {
//    _bloc.dispatch(PromoDetialTapped(promo));
//    widget.onBack = () => _bloc.dispatch(BackToState());
//  }

  Widget buildChild(int index, selectedPromo) {
    var poster = Container(
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        child: CachedNetworkImage(
          imageUrl: selectedPromo.detials[index].PromoDetialPosterUrl,
          placeholder: (context, url) => Container(
            color: Colors.black12,
            width: MediaQuery.of(context).size.width * 0.9,
            height: 100,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
          errorWidget: (context, url, error) => new Icon(Icons.error),
          fit: BoxFit.contain,
        ),
      ),
    );
    if (index != 0) return poster;

    return Column(
      children: <Widget>[
        poster,
        Padding(
          padding: EdgeInsets.all(8),
          child: RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
                text: selectedPromo.PromoDescText,
                style: const TextStyle(
                  color: const Color(0xffFFFFF0),
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                  //fontSize: 16.0,
                  fontFamily: 'Montserrat',
                )),
          ),
        )
      ],
    );
  }
}
