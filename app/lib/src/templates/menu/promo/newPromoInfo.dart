import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ddish/src/blocs/menu/promo/promo_bloc.dart';
import 'package:ddish/src/blocs/menu/promo/promo_event.dart';
import 'package:ddish/src/blocs/menu/promo/promo_state.dart';
import 'package:ddish/src/models/promo.dart';
import 'package:ddish/src/repositiories/promo_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class PromoWidget extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => PromoWidgetState();
}

class PromoWidgetState extends State<PromoWidget>{
  PromoBloc _bloc;
  PromoRepository _repository;
  List<NewPromoMdl> promotions;
  NewPromoMdl selectedPromo;
  bool loading = false;

  @override
  void initState(){
    promotions = List<NewPromoMdl>();
    _repository = PromoRepository();
    _bloc = PromoBloc(repository: _repository);
    super.initState();
  }
  @override
  void dispose(){
    _bloc.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context){
    //final height = MediaQuery.of(context).size.height;
    //final ImageProvider _imageProvider;
    return BlocBuilder<PromoEvent, PromoState>(
      bloc: _bloc,
      builder: (BuildContext context, PromoState state){
        if(state is PromoWidgetLoading){
          return Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if(state is PromoWidgetStarted){
          _bloc.dispatch(PromoStarted());
        }
        if(state is PromoWidgetLoaded){
          promotions = state.promoList;
          return promotions != null ?
          Flexible(
            child: Container(
              padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
              child: ListView.builder(
                itemCount: promotions.length,
                itemBuilder: (BuildContext context, int index){
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: GestureDetector(
                      child: Container(
                        padding: EdgeInsets.all(80.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: CachedNetworkImageProvider(promotions[index].PromoPosterUrl),
                          ),
                        ),
                      ),
                      onTap: ()=> onPromotionTap(promotions[index]),
                    ),
                  );
                },
              )
            ),
          ):Container();
        }
        if(state is PromoWidgetTapped){
          return Flexible(
            child: Container(
              padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
              child: ListView.builder(
                itemCount: selectedPromo.detials.length,
                itemBuilder: (BuildContext context, int index){
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: GestureDetector(
                      child: Container(
                        padding: const EdgeInsets.all(300.0),//(150.0, 480.0, 0.0, 0.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: CachedNetworkImageProvider(selectedPromo.detials[index].PromoDetialPosterUrl),
                          ),
                        ),
                      ),
                      onTap: ()=> onPromotionDetialTap(selectedPromo),
                    ),
                  );
                },
              ),
            ),
          );
        }
        if(state is PromoWidgetDetialTapped){
          return Container(
            height: (MediaQuery.of(context).size.height*0.75),
            width: (MediaQuery.of(context).size.width*0.9),
            alignment: Alignment.topCenter,
            child: new ListView(
              reverse: false,
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    text: selectedPromo.PromoDescText,
                    style: const TextStyle(
                        color: const Color(0xffFFFFF0),
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.normal,
                        //fontSize: 16.0,
                        fontFamily: 'Montserrat',
                    )
                  ),
                )
              ].reversed.toList(),
            ),
          );
        }
        return Container();
      },
    );
 }
  onPromotionTap(NewPromoMdl promo){
    selectedPromo = promo;
    _bloc.dispatch(PromoTapped());
  }
  onPromotionDetialTap(NewPromoMdl promo){
    selectedPromo = promo;
    _bloc.dispatch(PromoDetialTapped());
  }
}