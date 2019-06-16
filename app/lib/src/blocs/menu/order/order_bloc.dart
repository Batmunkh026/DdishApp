import 'package:bloc/bloc.dart';
import 'package:ddish/src/models/result.dart';
import 'package:ddish/src/repositiories/menu_repository.dart';

import 'order_event.dart';
import 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final MenuRepository repository;

  OrderBloc({this.repository});

  @override
  OrderState get initialState => OrderWidgetStarted();

  @override
  Stream<OrderState> mapEventToState(OrderEvent event) async* {
    if (event is OrderTapped) {
      yield OrderRequestProcessing();
      Result result = await repository.postOrder(event.order);
      yield OrderRequestFinished(result: result);
    }
  }
}
