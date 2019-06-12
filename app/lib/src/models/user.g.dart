part of 'user.dart';

User _$UserFromJson(Map<String, dynamic> userJson) {
  return User(
        result: Result.fromJson(userJson),
      cardNo: userJson['cardNo'] as String,
      userFirstName: userJson['userFirstName'] as String,
      userLastName: userJson['userLastName'] as String,
      adminNumber: userJson['adminNumber'] as String,
      userRegNo: userJson['userRegNo'] as String,
      activeProducts: ProductList.fromJson(userJson['activeProducts']),
      activeCounters: CounterList.fromJson(userJson['activeCounters']));
}

