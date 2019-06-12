part of 'user.dart';

User _$UserFromJson(Map<String, dynamic> userJson) {
  return User(
      cardNo: userJson['cardNo'] as String,
      userFirstName: userJson['userFirstName'] as String,
      isSuccess: userJson['isSuccess'] as bool,
      resultCode: userJson['resultCode'] as String,
      resultMessage: userJson['resultMessage'] as String,
      userLastName: userJson['userLastName'] as String,
      adminNumber: userJson['adminNumber'] as String,
      userRegNo: userJson['userRegNo'] as String,
      activeProducts: ProductList.fromJson(userJson['activeProducts']),
      activeCounters: CounterList.fromJson(userJson['activeCounters']));
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'cardNo': instance.cardNo,
      'userFirstName': instance.userFirstName,
      'isSuccess': instance.isSuccess,
      'resultCode': instance.resultCode,
      'resultMessage': instance.resultMessage,
      'userLastName': instance.userLastName,
      'adminNumber': instance.adminNumber,
      'activeCounters': instance.activeCounters,
      'activeProducts': instance.activeProducts,
    };
