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
      updateServicePackTabState(
          event.selectedPackType,
          event.selectedPackType == PackTabType.ADDITIONAL_CHANNEL
              ? channels
              : packs);
    } else if (event is PackTypeSelectorClicked) {
      PackTypeSelectorClicked e = event;
//      Багц сунгах төлөв бол тухайн багцын төрөлд хамаарах багцуудыг шүүж харуулах
      //TODO нэмэлт сувгуудад багцын төрөл хамаатай эсэхийг тодруулах
      yield PackSelectionState(packs, event.selectedPack);
    } else if (event is ChannelSelected) {
      //TODO  тухайн сонгосон сувгийн багцуудыг API аас авах
      List<dynamic> packsForChannel; //TODO channel ын төрлөөр шүүж авах
      yield AdditionalChannelState(event.selectedChannel, packsForChannel);
    } else if (event is PackItemSelected) {
      if (event.selectedPack != null) {
        //багц сонгогдсон
        yield SelectedPackPreview(event.selectedPack);
      }
    } else if (event is PreviewSelectedPack) {
      yield SelectedPackPreview(event.selectedPack);
    } else if (event is ExtendSelectedPack) {
      //TODO төлбөр төлөлт хийх
      PaymentState paymentState;
      yield PackPaymentState(paymentState);
    }
  }

  /// Багц эсвэл нэмэлт суваг сонголт
  ///
  /// **selectedPackType** - сонгогдсон багцын төрөл **[Үлэмж, Илүү, Энгийн, ...]**
  ///
  /// **dataForSelectedPackType** - сонгосон багцад харгалзах дата
  dynamic updateServicePackTabState(
      PackTabType selectedPackType, dynamic dataForSelectedPackType) async*{
    var items;
    if (selectedPackType == PackTabType.UPGRADE)
      items = packRepository.getPacks();
    else if (selectedPackType == PackTabType.ADDITIONAL_CHANNEL)
      items = packRepository.getChannels();
    else
      throw UnsupportedError("Дэмжигдэхгүй төлөв байна! $selectedPackType");

//      TODO api бэлэн болохоор comment ыг болиулах, demo data - г дамжуулж буй хэсгийг устгах
//      items.then((value) => ServicePackTabState(event.selectedPackType, value));

    yield PackTabState(
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
