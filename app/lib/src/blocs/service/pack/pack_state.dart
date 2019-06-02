import 'package:ddish/src/models/channel.dart';
import 'package:ddish/src/models/payment_state.dart';
import 'package:ddish/src/models/tab_models.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class PackState extends Equatable {
  PackState([List props = const []]) : super(props);
}

class ServicePackTabState extends PackState {
  PackTabType selectedTab;
  Stream<dynamic> initialItems; //Тухайн таб д хамаарах initial data
  ServicePackTabState(@required this.selectedTab, @required this.initialItems)
      : assert(selectedTab != null),
        assert(initialItems != null),
        super([selectedTab]);
}

//Багцын төрөл өөрчлөгдсөн төлөв
class PackTypeChanged extends PackState {
  Stream<dynamic>
      itemsForPack; //TODO сонгогдсон багцад хамаарах контентуудыг авах
  dynamic selectedPack;
//TODO selectedPack ын төрөл ямар байхыг тодруулах
  PackTypeChanged(this.selectedPack, this.itemsForPack)
      : assert(selectedPack != null),
        assert(itemsForPack != null);
}

//нэмэлт суваг сонгогдсон төлөв
class AdditionalChannelState extends PackState {
  Channel selectedChannel;
  Stream<dynamic> packsForChannel;
  AdditionalChannelState(
      @required this.selectedChannel, @required this.packsForChannel)
      : assert(selectedChannel != null),
        assert(packsForChannel != null);
}

//нэмэлт суваг эсвэл аль нэг  багц ын хугацаа&үнийн дүнг сонгох сонгосон төлөв
//selectedPack - сонгогдсон багц \null байж болно\
//хэрэв selectedPack null <өөр сонголт хийх> хүсэлт гэж ойлгож сунгах сарын тоогоо оруулах цонхрүү шилжүүлэх
class PackItemState extends PackState {
  PackTabType selectedTab; //сонгогдсон tab (сунгах, нэмэлт суваг)
  dynamic selectedPack; //TODO сонгогдсон багцын төрлийг тодорхойлох

  PackItemState(this.selectedTab, this.selectedPack);
}

//Сонгогдсон багцын төлбөр, хугацааны төлөв
class SelectedPackPreview extends PackState {
  var selectedPack;
  SelectedPackPreview(@required this.selectedPack)
      : assert(selectedPack != null);
}

//Сонгогдсон багцын төлбөр төлөлтийн төлөв
class PackPaymentState extends PackState {
  PaymentState _paymentState;
  PackPaymentState(@required this._paymentState)
      : assert(_paymentState != null);
}
