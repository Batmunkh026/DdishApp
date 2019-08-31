import 'package:cached_network_image/cached_network_image.dart';
import 'package:ddish/presentation/ddish_flutter_app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProductBackBtn extends StatelessWidget {
  String productImage;
  String productName;
  String title;
  final Function onTap;

  ProductBackBtn(this.title,
      {this.productName = "", this.productImage = "", this.onTap});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);
    bool hasImageAndText = title.isNotEmpty && productImage.isNotEmpty;
    var deviceHeight = media.size.height;
    var deviceWidth = media.size.width;
    var titleContainerWidth =
        deviceWidth * (productImage.isNotEmpty ? 0.7 : 0.57);
    var deviceWidthPercent = deviceWidth / 100;
    var scalar = (deviceWidthPercent / 3).floor();
    var titlePadding = 3.0;



    print(
        "height: $deviceHeight , width: $deviceWidth , devicePercent: $deviceWidthPercent , titlePadding: $titlePadding");
    print(
        "textFactor: ${media.textScaleFactor} , pxlRatio: ${media.devicePixelRatio} , scalar: $scalar");

    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(top: 10, left: 10, right: 15),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Icon(
                DdishAppIcons.before,
                size: 24.0,
                color: Color.fromRGBO(57, 110, 170, 1),
              ),
            ),
            Visibility(
              child: Center(
                child: Container(
                  width: deviceWidth * 0.28,
                  height: deviceWidth * 0.12,
                  child: CachedNetworkImage(
                    imageUrl: productImage,
                    placeholder: (context, text) => Text(productName),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              visible: productImage.isNotEmpty,
            ),
            Visibility(
              visible: title.isNotEmpty,
              child: Align(
                alignment: hasImageAndText
                    ? AlignmentDirectional(0, titlePadding)
                    : Alignment.center,
                child: Container(
                  width: titleContainerWidth,
                  child: FittedBox(
                    child: Text(
                      "Сунгах сарын тоогоо оруулна уу",
                      textAlign: TextAlign.center,
                    ),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () => onTap(),
    );
  }
}
