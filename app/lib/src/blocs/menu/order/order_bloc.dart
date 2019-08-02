import 'package:bloc/bloc.dart';
import 'package:ddish/src/abstract/abstract.dart';
import 'package:ddish/src/models/result.dart';
import 'package:ddish/src/repositiories/menu_repository.dart';

import 'order_event.dart';
import 'order_state.dart';

class OrderBloc extends AbstractBloc<OrderEvent, OrderState> {
  final MenuRepository repository;

  OrderBloc(pageState, {this.repository}) : super(pageState);

  @override
  OrderState get initialState => OrderWidgetStarted();

  @override
  Stream<OrderState> mapEventToState(OrderEvent event) async* {
    if(event is OrderEdit){
      //TODO edit
      yield OrderWidgetStarted();
    }else if (event is OrderTapped) {
      yield OrderRequestProcessing();
      Result result = await repository.postOrder(event.order);
      yield OrderRequestFinished(result: result, order: event.order);
    }
  }
}
