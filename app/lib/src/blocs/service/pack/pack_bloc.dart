import 'package:bloc/bloc.dart';
import 'package:ddish/src/blocs/service/pack/pack_event.dart';
import 'package:ddish/src/blocs/service/pack/pack_state.dart';
import 'package:ddish/src/models/payment_state.dart';
import 'package:ddish/src/models/tab_models.dart';
import 'package:meta/meta.dart';

class PackBloc extends Bloc<PackEvent, PackState> {
  Stream<dynamic> packTypes = Stream.empty(); //багцын төрлүүд
  Stream<dynamic> initialItems = Stream.empty(); //TODO сунгах саруудын дата

  @override
  PackState get initialState {
//    packTypes = //TODO API аас дата авах
//    ServicePackTabState(PackTabType.EXTEND, initialItems, packTypes);
    ServicePackTabState(PackTabType.EXTEND, initialItems, List.of([]));
  }

  @override
  Stream<PackState> mapEventToState(PackEvent event) async* {
    if (event is PackServiceSelected) {
      //TODO API аас тухайн таб д хамаарах анхны дата stream авч дамжуулах
      Stream<dynamic> initialItemsForPackType = Stream.empty();
      //    ServicePackTabState(PackTabType.EXTEND, initialItems, packTypes);
      yield ServicePackTabState(
          event.selectedPackType, initialItemsForPackType, List.of([]));
    } else if (event is PackTypeSelectorClicked) {
      //TODO api аас тухайн сонгосон багцын төрлийн контентуудыг шүүж авах
      Stream<dynamic> itemsForPackType;
      PackTypeChanged(event.packType, itemsForPackType);
    } else if (event is ChannelSelected) {
      //TODO  тухайн сонгосон сувгийн багцуудыг API аас авах
      Stream<dynamic> packsForChannel; //TODO channel ын төрлөөр шүүж авах
      AdditionalChannelState(event.selectedChannel, packsForChannel);
    } else if (event is PackItemSelected) {
      if (event.selectedPack != null) {
        //
        SelectedPackPreview(event.selectedPack);
      }
    } else if (event is PreviewSelectedPack) {
      SelectedPackPreview(event.selectedPack);
    } else if (event is ExtendSelectedPack) {
      //TODO төлбөр төлөлт хийх
      PaymentState paymentState;
      PackPaymentState(paymentState);
    }
  }
}
