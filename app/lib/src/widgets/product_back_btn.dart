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
    bool hasImageAndText = title.isNotEmpty && productImage.isNotEmpty;

    return GestureDetector(
      child: Container(
        margin: EdgeInsets.all(15),
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
                  width: MediaQuery.of(context).size.width * 0.3,
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
                    ? AlignmentDirectional(0, 3)
                    : Alignment.center,
                child: Container(
                  width: MediaQuery.of(context).size.width *
                      (productImage.isNotEmpty ? 0.7 : 0.55),
                  child: FittedBox(
                    child: Text(
                      "Сунгах сарын тоогоо оруулна уу",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12),
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
