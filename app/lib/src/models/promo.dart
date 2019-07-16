class NewPromoMdl{
  String PromoName;
  String PromoDescText;
  String PromoPosterUrl;
  List<NewPromoDetial> detials;

  NewPromoMdl.fromJson(Map<String, dynamic> json):
        PromoName = json['promotionName'],
        PromoDescText =json['promotionText'],
        PromoPosterUrl = json['promotionImg'],
        detials = List<NewPromoDetial>.from(json['promoDetials'].map((prmDetial)=> NewPromoDetial.fromJson(prmDetial)));
}
class NewPromoDetial{
  String PromoId;
  String PromoDetialPosterUrl;

  NewPromoDetial.fromJson(Map<String, dynamic> json):
        PromoId = json["promoId"],
        PromoDetialPosterUrl = json["detialPoster"];
}

class AntennMdl{
  String imageUrl;

  AntennMdl.fromJson(Map<String, dynamic> json):
        imageUrl = json["imgUrl"];
}