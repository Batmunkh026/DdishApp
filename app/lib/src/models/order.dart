class Order {
  final String orderType;
  final String userName;
  final String phoneNo;
  final int districtCode;

  Order({this.orderType, this.userName, this.phoneNo, this.districtCode});

  @override
  String toString() =>
      'orderType=$orderType&userName=$userName&phoneNo=$phoneNo&districtCode=$districtCode';
}
