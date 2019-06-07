import 'package:ddish/src/models/channel.dart';
import 'package:ddish/src/models/pack.dart';
import 'package:ddish/src/models/payment_state.dart';
import 'package:ddish/src/models/tab_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

///Багцын төлөв
abstract class PackState extends Equatable{
  List<dynamic> initialItems;
  var selectedPack;
  PackTabType selectedTab;

  PackState(this.selectedTab, this.initialItems, this.selectedPack, [List props = const []]) : super(props){
    if(selectedPack == null && initialItems.length > 0)
      selectedPack = initialItems.first;
  }

}

///#Багцын үйлчилгээний төрөл өөрчлөгдөх төлөв
///
///**жишээ** :
///
/// Хэрэглэгч үйлчилгээний __багц сунгах__ төлвөөс __нэмэлт сувгууд__ төлөврүү шилжих
///
/// эсвэл __нэмэлт сувгууд__ төлвөөс __багц ахиулах__ төлөврүү шилжих.
///
///__properties__:
///
/// **selectedTab** - Сонгосон багцын төлөв
///
///  **initialItems** - Сонгосон багц дахь дата;
class PackTabState extends PackState {
  PackTabType selectedTab;
  bool isReload;
  /// parameters:
  ///
  /// **selectedTab** - сонгосон багцын үйлчилгээний төлөв
  ///
  /// **initialItems** - тухайн сонгосон багцын үйлчилгээнд харгалзах дата
  PackTabState(@required this.selectedTab, @required List<dynamic> initialItems, this.isReload)
      : assert(selectedTab != null),
        assert(initialItems != null), super(selectedTab, initialItems, null, [isReload, selectedTab]);

  @override
  String toString() => "PackTab state $selectedTab - $selectedPack";
}


///нэмэлт суваг сонгогдсон төлөв
class AdditionalChannelState extends PackState {
  Channel selectedChannel;
  AdditionalChannelState(PackTabType selectedPackType,
      @required this.selectedChannel)
      : assert(selectedChannel != null), super(selectedPackType, null,  selectedChannel, [selectedPackType,selectedChannel]);
}

///Багц сонголтын төлөв
///
/// __selectedPac
class PackSelectionState extends PackState {
  PackTabType selectedTab;
  List<Pack> packs;
  final Pack selectedPack;

  PackSelectionState(this.selectedTab, this.packs, @required this.selectedPack):super(selectedTab, packs, selectedPack, [selectedTab, packs, selectedPack]);

  @override
  String toString() => "Pack selection state $selectedPack";
}

///нэмэлт суваг эсвэл аль нэг  багц ын хугацаа&үнийн дүнгийн төрлөөс сонгосон төлөв
///
///selectedPackItem - сонгогдсон багцын утга \null байж болно\
///
///хэрэв selectedPackItem == null бол <өөр сонголт хийх> хүсэлт гэж ойлгож сунгах сарын тоогоо оруулах цонхрүү шилжүүлэх
class PackItemState extends PackState {
  ///сонгогдсон tab (сунгах, нэмэлт суваг)
  PackTabType selectedTab;
  dynamic selectedPackItem; //TODO сонгогдсон багцын төрлийг тодорхойлох

  PackItemState(this.selectedTab, this.selectedPackItem):super(null, null, [selectedTab, selectedPackItem]);
}

///нэмэлт суваг эсвэл аль нэг  багц ын хугацаа&үнийн дүнгийн төрлөөс сонгосон төлөв
///
///selectedPackItem - сонгогдсон багцын утга \null байж болно\
///
///хэрэв selectedPackItem == null бол <өөр сонголт хийх> хүсэлт гэж ойлгож сунгах сарын тоогоо оруулах цонхрүү шилжүүлэх
class SelectedPackPreview extends PackState {
  ///сонгогдсон tab (сунгах, нэмэлт суваг)
  PackTabType selectedTab;
  var selectedPack;
  int monthToExtend;

  SelectedPackPreview(this.selectedTab, this.selectedPack, this.monthToExtend)
      : assert(selectedPack != null), super(selectedTab, null, selectedPack);
}
class CustomPackSelector extends PackState {
  ///сонгогдсон tab (сунгах, нэмэлт суваг)
  var selectedPack;

  CustomPackSelector(selectedTab, this.selectedPack, packs)
      : super(selectedTab, packs, selectedPack, [selectedTab, packs, selectedPack]);

  @override
  String toString() => "custom selector : $selectedTab: $selectedPack";
}

///Сонгогдсон багцын төлбөр төлөлтийн төлөв
class PackPaymentState extends PackState {
  PaymentState paymentState;
  int monthToExtend;
  

  PackPaymentState(PackTabType selectedPackType, selectedPack, this.monthToExtend, this.paymentState)
      : super(selectedPackType, null, selectedPack);
}
