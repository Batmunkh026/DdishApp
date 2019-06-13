import 'dart:collection';

import 'package:ddish/src/models/channel.dart';
import 'package:ddish/src/models/month_price.dart';
import 'package:ddish/src/models/pack.dart';
import 'package:ddish/src/models/payment_state.dart';
import 'package:ddish/src/models/tab_models.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import 'pack_state.dart';

abstract class PackEvent extends Equatable {
  PackTabType selectedTab;
  PackEvent(this.selectedTab, [List props = const []]) : super(props);
}
///Сунгах багцуудыг төрлөөр нь сонгох үед дуудагдах эвент
///
/// parameter:
///
/// __selectedPack__ - сонгогдсон багцын төрөл
class PackTypeSelectorClicked extends PackEvent {
  Pack
      selectedPack; //TODO багцын төрлийг баазаас авах шаардлагагүй бол enum төрлөөр шийдэх, үгүй бол багцын төрлийг өөрчлөх
  PackTypeSelectorClicked(PackTabType selectedPackType, this.selectedPack)
      : assert(selectedPack != null),
        super(selectedPackType, [selectedPackType, selectedPack]);
}

///#Багцын дэд үйлчилгээ сонгогдсон эвент
///
/// **жишээ:**
/// Хэрэв __багц сунгах__ эсвэл __нэмэлт суваг__ табуудаас аль нэгийг сонгосон тохиолдолд энэ эвент дуудах
class PackServiceSelected extends PackEvent {
  PackTabType selectedPackType;
  PackServiceSelected(this.selectedPackType)
      : super(selectedPackType, [selectedPackType]);
}

//нэмэлт суваг сонгох
class ChannelSelected extends PackEvent {
  Channel selectedChannel;
  ChannelSelected(PackTabType selectedPackType, this.selectedChannel)
      : assert(selectedChannel != null),
        super(selectedPackType, [selectedPackType, selectedChannel]);
}

// тухайн багцын хугацаа&төлбөр сонгох
//  сонгогдсон элемент нь null байвал <өөр сонголт хийх> оролдлого гэж ойлгох
class PackItemSelected extends PackEvent {
  var selectedPack;
  MonthAndPriceToExtend selectedItemForPack;

  PackItemSelected(
      PackTabType selectedPackType, this.selectedPack, this.selectedItemForPack)
      : super(selectedPackType,
            [selectedPackType, selectedItemForPack, selectedPack]);
}

///Өөр дүн оруулах
class CustomPackSelected extends PackEvent {
  static final key = Key("custom-pack-selected-event");
  var selectedPack;
  int monthToExtend;

  CustomPackSelected(selectedPackType, this.selectedPack, this.monthToExtend)
      : super(selectedPackType,
            [selectedPackType, selectedPack, key, monthToExtend]);
}

//
//Сонгогдсон багцын сунгалтын өмнөх төлвийг харах
class PreviewSelectedPack extends PackEvent {
  dynamic selectedPack;
  int monthToExtend;

  PreviewSelectedPack(
      PackTabType selectedPackType, this.selectedPack, this.monthToExtend)
      : super(selectedPackType, [selectedPackType, monthToExtend]);
}

//Сонгогдсон багцын сунгах
class ExtendSelectedPack extends PackEvent {
  dynamic selectedPack;
  int extendMonth;
  ExtendSelectedPack(
      PackTabType selectedPackType, this.selectedPack, this.extendMonth)
      : super(selectedPackType, [selectedPackType]);
}

class BackToPrevState extends PackEvent {
  ListQueue<PackState>
      states; //TODO state үүдийн stack үүсгээд буцах дарах үед сүүлийн state үүдийг устгаад явах
  BackToPrevState(PackTabType selectedTab) : super(selectedTab, [selectedTab]);
}
