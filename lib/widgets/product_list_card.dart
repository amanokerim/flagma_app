import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../const.dart';
import '../screens/detail_screen.dart';

class ProductListCard extends StatelessWidget {
  final product, unitList, currencyList;

  final String image, ln;

  const ProductListCard({
    Key key,
    @required this.product,
    @required this.image,
    @required this.unitList,
    @required this.currencyList,
    this.ln,
  }) : super(key: key);

  // String image = product["images"][0]["img_url_small"];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (_) => DetailScreen(
              ln: ln,
              product: product,
              currencyList: currencyList,
              unitList: unitList,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20.0, left: 10.0, right: 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color: Colors.grey[300],
              offset: Offset(0, 5),
              spreadRadius: -2,
            ),
          ],
        ),
        child: Column(
          children: <Widget>[
            Container(
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                ),
                image: DecorationImage(
                    image:
                        image == null || image == "undefined" || image.isEmpty
                            ? AssetImage("assets/images/1.jpg")
                            : NetworkImage(image),
                    fit: BoxFit.cover),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(firstUpper(product["name"].toString()), style: myH4),
                  Text(
                    product["wholesale_price_min"] !=
                            product["wholesale_price_max"]
                        ? product["wholesale_price_min"].toString() +
                            " - " +
                            product["wholesale_price_max"].toString() +
                            " " +
                            currencyList[product["currency_id"] - 1]["title"]
                        : product["wholesale_price_max"].toString() +
                            " " +
                            currencyList[product["currency_id"] - 1]["title"],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
