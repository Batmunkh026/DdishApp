import 'package:bloc/bloc.dart';
import 'package:ddish/src/blocs/service/pack/pack_event.dart';
import 'package:ddish/src/blocs/service/pack/pack_state.dart';
import 'package:ddish/src/models/channel.dart';
import 'package:ddish/src/models/pack.dart';
import 'package:ddish/src/models/payment_state.dart';
import 'package:ddish/src/models/tab_models.dart';
import 'package:ddish/src/models/user.dart';
import 'package:ddish/src/repositiories/pack_repository.dart';
import 'package:ddish/src/repositiories/user_repository.dart';

class PackBloc extends Bloc<PackEvent, PackState> {
  var packRepository = PackRepository();
  var _userRepository = UserRepository();

  PackEvent beforeEvent = null;
  PackState beforeState = null;
  PackState backState = null;

  List<Channel> channels;
  List<Pack> packs;
  Pack selectedProduct;
  User user;
  Future<List<Pack>> packStream; //TODO API аас авдаг болсон үед ашиглана
  Future<List<Channel>> channelsStream;

  @override
  PackState get initialState {
    packStream = packRepository.getPacks();

    ///fetch хийж дууссан бол
    loadInitialData().listen((f) => print("initial data loaded."));

    return Loading(PackTabType.EXTEND);
  }

  loadInitialData() async* {
    await _userRepository
        .getUserInformation()
        .then((user) => this.user = user);

    await packStream.then((packs) => this.packs = packs);

    //      TODO хэрэглэгчийн сонгосон бүтээгдэхүүн байх эсэх?
    // TODO pack нэрийг бүтээгдэхүүн болгож сольсоны дараа устгах
    selectedProduct = packs.firstWhere(
        (pack) =>
            pack.productId == user.activeProducts.products.last.productId,
        orElse: () => packs.first);

    dispatch(PackServiceSelected(PackTabType.EXTEND));
  }

  @override
  Stream<PackState> mapEventToState(PackEvent event) async* {
    if (event is PackServiceSelected) {
      yield Loading(event.selectedPackType);

      ///сонгогдсон багцын үйлчилгээ нь __нэмэлт суваг__ бол channels үгүй бол packs ыг дамжуулах
      if (event.selectedPackType == PackTabType.ADDITIONAL_CHANNEL) {
        //хэрэв бүтээгдэхүүн сонгосон бол тэр бүтээгдэхүүн үгүй бол жагсаалтын эхний бүтээгдэхүүний ID аар авах
        this.channels =
            await packRepository.getChannels(selectedProduct.productId);

        yield PackTabState(event.selectedPackType, channels);
      } else
        this.packs = await packRepository.getPacks();
      yield PackTabState(event.selectedPackType, packs);
    } else if (event is PackTypeSelectorClicked) {
//      Багц сунгах төлөв бол тухайн багцын төрөлд хамаарах багцуудыг шүүж харуулах
      //TODO нэмэлт сувгуудад багцын төрөл хамаатай эсэхийг тодруулах
      yield PackSelectionState(event.selectedTab, packs, event.selectedPack);
    } else if (event is ChannelSelected) {
      yield AdditionalChannelState(event.selectedTab, event.selectedChannel);
    } else if (event is PackItemSelected) {
      assert(event.selectedPack != null);
      //багц сонгогдсон
      if (event.selectedTab == PackTabType.ADDITIONAL_CHANNEL &&
          event.monthToExtend == null)
        yield AdditionalChannelState(event.selectedTab, event.selectedPack);
      else
        yield SelectedPackPreview(
            event.selectedTab, event.selectedPack, event.monthToExtend);
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
    if (!(event is Loading)) {
      beforeState = currentState;
      beforeEvent = event;
    }
  }

  /// Багц эсвэл нэмэлт суваг сонголт
  ///
  /// **selectedPackType** - сонгогдсон багцын төрөл **[Үлэмж, Илүү, Энгийн, ...]**
  ///
  /// **dataForSelectedPackType** - сонгосон багцад харгалзах дата
  PackTabState updateServicePackTabState(
      PackTabType selectedPackType, List<dynamic> itemsForSelectedTab) {
    return PackTabState(selectedPackType, itemsForSelectedTab);
  }

  ///Багцын хугацааа&үнийн дүнгийн төрөл сонгох
  void selectPackItem(PackTabType selectedPackTabType, dynamic pack) {
    PackItemState(selectedPackTabType, pack);
  }
}
