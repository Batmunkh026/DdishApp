import 'package:ddish/src/models/channel.dart';
import 'package:ddish/src/models/month_price.dart';
import 'package:ddish/src/models/pack.dart';
import 'package:ddish/src/models/tab_models.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class PackEvent extends Equatable {
  PackEvent([List props = const []]) : super(props);
}

///Сунгах багцуудыг төрлөөр нь сонгох үед дуудагдах эвент
///
/// parameter:
///
/// __selectedPack__ - сонгогдсон багцын төрөл
class PackTypeSelectorClicked extends PackEvent {
//  PackTabType selectedPackType;
  Pack selectedPack; //TODO багцын төрлийг баазаас авах шаардлагагүй бол enum төрлөөр шийдэх, үгүй бол багцын төрлийг өөрчлөх
  PackTypeSelectorClicked(this.selectedPack) : assert(selectedPack != null),super([selectedPack]);
}

///#Багцын дэд үйлчилгээ сонгогдсон эвент
///
/// **жишээ:**
/// Хэрэв __багц сунгах__ эсвэл __нэмэлт суваг__ табуудаас аль нэгийг сонгосон тохиолдолд энэ эвент дуудах
class PackServiceSelected extends PackEvent {
  PackTabType selectedPackType;
  PackServiceSelected(this.selectedPackType):super([selectedPackType]);
}

//нэмэлт суваг сонгох
class ChannelSelected extends PackEvent {
  Channel selectedChannel;
  ChannelSelected(this.selectedChannel) : assert(selectedChannel != null);
}

// тухайн багцын хугацаа&төлбөр сонгох
//  сонгогдсон элемент нь null байвал <өөр сонголт хийх> оролдлого гэж ойлгох
class PackItemSelected extends PackEvent {
  Pack selectedPack;
  MonthAndPriceToExtend selectedItemForPack;

  PackItemSelected(this.selectedPack, this.selectedItemForPack):super([selectedPack]);
}

//
//Сонгогдсон багцын сунгалтын өмнөх төлвийг харах
class PreviewSelectedPack extends PackEvent {
  dynamic selectedPack;

  PreviewSelectedPack(this.selectedPack);
}

//Сонгогдсон багцын сунгах
class ExtendSelectedPack extends PackEvent {}
