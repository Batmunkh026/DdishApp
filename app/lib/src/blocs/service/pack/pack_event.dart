import 'package:ddish/src/models/channel.dart';
import 'package:ddish/src/models/tab_models.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class PackEvent extends Equatable {
  PackEvent([List props = const []]) : super(props);
}

///Сунгах багцуудыг төрлөөр нь харах
///жишээ: Үлэмж багцыг сонгосон бол тухайн багцын сунгах үнэ болон хугацааны сонголтууд харуулах
class PackTypeSelectorClicked extends PackEvent {
  dynamic
      packType; //TODO багцын төрлийг баазаас авах шаардлагагүй бол enum төрлөөр шийдэх, үгүй бол багцын төрлийг өөрчлөх
  PackTypeSelectorClicked(this.packType) : assert(packType != null);
}

///Сунгах, Нэмэлт суваг, Ахиулах таб ууд сонгосон үед ажиллах
///жишээ:
///<Сунгах> tab сонгогдсон бол сунгах саруудын дата,
///<Нэмэлт сувгууд> сонгогдсон бол нэмэлт сувгуудын дата
class PackServiceSelected extends PackEvent {
  PackTabType selectedPackType;
  List<dynamic> itemsForSelectedPackType;
  PackServiceSelected(this.selectedPackType, this.itemsForSelectedPackType)
      : assert(selectedPackType != null);
}

//нэмэлт суваг сонгох
class ChannelSelected extends PackEvent {
  Channel selectedChannel;
  ChannelSelected(this.selectedChannel) : assert(selectedChannel != null);
}

// тухайн багцын хугацаа&төлбөр сонгох
//  сонгогдсон элемент нь null байвал <өөр сонголт хийх> оролдлого гэж ойлгох
class PackItemSelected extends PackEvent{
  dynamic selectedPack;

  PackItemSelected(this.selectedPack);
}
//
//Сонгогдсон багцын сунгалтын өмнөх төлвийг харах
class PreviewSelectedPack extends PackEvent{
  dynamic selectedPack;

  PreviewSelectedPack(this.selectedPack);
}
//Сонгогдсон багцын сунгах
class ExtendSelectedPack extends PackEvent{

}