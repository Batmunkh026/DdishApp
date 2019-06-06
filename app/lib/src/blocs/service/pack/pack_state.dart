import 'package:ddish/src/models/channel.dart';
import 'package:ddish/src/models/pack.dart';
import 'package:ddish/src/models/payment_state.dart';
import 'package:ddish/src/models/tab_models.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

///Багцын төлөв
abstract class PackState extends Equatable{
  List<dynamic> initialItems;
  var selectedPack;
  PackState(this.initialItems, this.selectedPack, [List props = const []]) : super(props){
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

  /// parameters:
  ///
  /// **selectedTab** - сонгосон багцын үйлчилгээний төлөв
  ///
  /// **initialItems** - тухайн сонгосон багцын үйлчилгээнд харгалзах дата
  PackTabState(@required this.selectedTab, @required List<dynamic> initialItems)
      : assert(selectedTab != null),
        assert(initialItems != null), super(initialItems, null, [selectedTab]);

  @override
  String toString() => "PackTab state $selectedTab - $selectedPack";
}


///нэмэлт суваг сонгогдсон төлөв
class AdditionalChannelState extends PackState {
  Channel selectedChannel;
  List<dynamic> packsForChannel;
  AdditionalChannelState(
      @required this.selectedChannel, @required this.packsForChannel)
      : assert(selectedChannel != null),
        assert(packsForChannel != null), super(packsForChannel, selectedChannel, [selectedChannel]);
}

///Багц сонголтын төлөв
///
/// __selectedPac
class PackSelectionState extends PackState {
  PackTabType selectedTab;
  List<Pack> packs;

  PackSelectionState(this.packs, @required selectedPack):super(packs, selectedPack, [selectedPack]);

  @override
  String toString() => "Pack selection state $selectedPack";
}

///нэмэлт суваг эсвэл аль нэг  багц ын хугацаа&үнийн дүнгийн төрлөөс сонгосон төлөв
///
///selectedPackItem - сонгогдсон багцын утга \null байж болно\
///
///хэрэв selectedPackItem null <өөр сонголт хийх> хүсэлт гэж ойлгож сунгах сарын тоогоо оруулах цонхрүү шилжүүлэх
class PackItemState extends PackState {
  ///сонгогдсон tab (сунгах, нэмэлт суваг)
  PackTabType selectedTab;
  dynamic selectedPackItem; //TODO сонгогдсон багцын төрлийг тодорхойлох

  PackItemState(this.selectedTab, this.selectedPackItem):super(null, null, [selectedTab, selectedPackItem]);
}

///Сонгогдсон багцын төлбөр, хугацааны төлөв
class SelectedPackPreview extends PackState {
  var selectedPack;
  SelectedPackPreview(@required this.selectedPack)
      : assert(selectedPack != null), super(null, null);
}

///Сонгогдсон багцын төлбөр төлөлтийн төлөв
class PackPaymentState extends PackState {
  PaymentState _paymentState;
  PackPaymentState(@required this._paymentState)
      : assert(_paymentState != null), super(null, null);
}
