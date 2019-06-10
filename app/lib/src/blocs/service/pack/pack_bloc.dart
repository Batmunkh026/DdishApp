import 'package:bloc/bloc.dart';
import 'package:ddish/src/blocs/service/pack/pack_event.dart';
import 'package:ddish/src/blocs/service/pack/pack_state.dart';
import 'package:ddish/src/models/channel.dart';
import 'package:ddish/src/models/pack.dart';
import 'package:ddish/src/models/payment_state.dart';
import 'package:ddish/src/models/tab_models.dart';
import 'package:ddish/src/repositiories/pack_repository.dart';

class PackBloc extends Bloc<PackEvent, PackState> {
  var packRepository = PackRepository();

  PackEvent beforeEvent = null;
  PackState beforeState = null;
  PackState backState = null;

  List<Channel> channels;
  List<Pack> packs;

  Future<List<Pack>> packStream; //TODO API аас авдаг болсон үед ашиглана
  Future<List<Channel>> channelsStream;

  @override
  PackState get initialState {
    packStream = packRepository.getPacks();
    channelsStream = packRepository.getChannels();

    channels = packRepository.channels;
    packs = packRepository.packs;

//    default таб нь <Багц Сунгах> байна
    //TODO api бэлэн болохоор хасаад api аас авсан датаг ашиглана,

//    ServicePackTabState(PackTabType.EXTEND, userApiProvider.fetchActivePacks());
//    TODO хэрэглэгчийн идэвхитэй багцыг дамжуулах
    return PackTabState(PackTabType.EXTEND, packRepository.packs);
  }

  @override
  Stream<PackState> mapEventToState(PackEvent event) async* {
    if (event is PackServiceSelected) {
      ///сонгогдсон багцын үйлчилгээ нь __нэмэлт суваг__ бол channels үгүй бол packs ыг дамжуулах

      var dataForSelectedTab =
          event.selectedPackType == PackTabType.ADDITIONAL_CHANNEL
              ? channels
              : packs;
      yield updateServicePackTabState(
          event.selectedPackType, dataForSelectedTab);
    } else if (event is PackTypeSelectorClicked) {
      PackTypeSelectorClicked e = event;
//      Багц сунгах төлөв бол тухайн багцын төрөлд хамаарах багцуудыг шүүж харуулах
      //TODO нэмэлт сувгуудад багцын төрөл хамаатай эсэхийг тодруулах
      yield PackSelectionState(event.selectedTab, packs, event.selectedPack);
    } else if (event is ChannelSelected) {
      yield AdditionalChannelState(event.selectedTab, event.selectedChannel);
    } else if (event is PackItemSelected) {
      assert(event.selectedPack != null);
      //багц сонгогдсон
      if (event.selectedTab == PackTabType.ADDITIONAL_CHANNEL && event.selectedItemForPack == null)
        yield AdditionalChannelState(event.selectedTab, event.selectedPack);
      else
        yield SelectedPackPreview(event.selectedTab, event.selectedPack,
            event.selectedItemForPack.monthToExtend);
    } else if (event is CustomPackSelected) {
      if (event.selectedPack != null) {
        //багц сонгогдсон
        yield CustomPackSelector(event.selectedTab, event.selectedPack, packs);
      }
    } else if (event is PreviewSelectedPack) {
      yield SelectedPackPreview(
          event.selectedTab, event.selectedPack, event.monthToExtend);
    } else if (event is ExtendSelectedPack) {
//      //TODO төлбөр төлөлт хийх
      int monthToExtend = event.extendMonth; //сунгах сар
      Pack selectedPack = event.selectedPack;
//      TODO төлбөр төлөлтийн үр дүнг дамжуулах
      PaymentState paymentState;
      yield PackPaymentState(
          event.selectedTab, selectedPack, monthToExtend, paymentState);
    } else if (event is BackToPrevState) {
      yield currentState.prevStates.last;
    }

    //
    if (!(event is BackToPrevState)) {
      backState = beforeState;

      //ижил таб дотор шилжиж байвал өмнөх state ын түүхийг цуглуулах
      if (backState != null &&
          beforeState != null &&
          currentState.selectedTab == backState.selectedTab &&
          beforeState.selectedTab == currentState.selectedTab) {
        if (backState.prevStates.isNotEmpty)
          currentState.prevStates.addAll(backState.prevStates);
        currentState.prevStates.add(backState);
      } else //өөр таб руу шилжиж байгаа бол цэвэрлэх
        currentState.prevStates.clear();
    }

    beforeState = currentState;
    beforeEvent = event;
  }

  /// Багц эсвэл нэмэлт суваг сонголт
  ///
  /// **selectedPackType** - сонгогдсон багцын төрөл **[Үлэмж, Илүү, Энгийн, ...]**
  ///
  /// **dataForSelectedPackType** - сонгосон багцад харгалзах дата
  PackTabState updateServicePackTabState(
      PackTabType selectedPackType, List<dynamic> dataForSelectedPackType) {
    var items;
    if (selectedPackType == PackTabType.UPGRADE)
      items = packRepository.getPacks();
    else if (selectedPackType == PackTabType.ADDITIONAL_CHANNEL)
      items = packRepository.getChannels();
    else if (selectedPackType == PackTabType.EXTEND)
      items = packRepository.getPacks();
    else
      throw UnsupportedError("Дэмжигдэхгүй төлөв байна! $selectedPackType");

//      TODO api бэлэн болохоор comment ыг болиулах, demo data - г дамжуулж буй хэсгийг устгах
//      items.then((value) => ServicePackTabState(event.selectedPackType, value));

    return PackTabState(
        selectedPackType,
        selectedPackType == PackTabType.ADDITIONAL_CHANNEL
            ? channels
            : dataForSelectedPackType);
  }

  ///Багцын хугацааа&үнийн дүнгийн төрөл сонгох
  void selectPackItem(PackTabType selectedPackTabType, dynamic pack) {
    PackItemState(selectedPackTabType, pack);
  }

  /// Багц сунгах төлвийн дата дамжуулах
  ///
  /// Хэрэглэгч багц сунгах төлвийг сонгосон үед ашиглана
  ///
  /// parameters:
  ///
  /// **currentPackTabState** - одоогийн сонгогдсон багцын төлөв
  ///
  /// **selectedPack** - сонгосон багц , default value: **[PackTabType.EXTEND]**
  ///
  /// See also:
  ///
  /// * [PackTabType] багцын төлвийн төрөл
  ///
  /// * [Pack] Багц
  void updatePackExtendTabState(
      PackTabType currentPackTabState, Pack selectedPack) {
    PackTabState(currentPackTabState, selectedPack.packsForMonth);
  }
}
