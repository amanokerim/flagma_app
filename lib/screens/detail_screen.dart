import 'package:flagma_app/screens/company_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../const.dart';
import '../widgets/call_chat_button.dart';
import '../widgets/logo_bar.dart';
import '../widgets/super_lite_button.dart';
import '../lang.dart';

class DetailScreen extends StatelessWidget {
  final product, currencyList, unitList;
  final String ln;

  DetailScreen({
    @required this.product,
    @required this.currencyList,
    @required this.unitList,
    this.ln,
  });

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarIconBrightness: Brightness.dark,
    // ));

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Stack(
            children: <Widget>[
              LogoBar(
                image: product["images"][0]["img_url_large"],
                images: product["images"],
              ),
              Positioned(
                top: 30,
                left: 20,
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (product["main_cat_title_" + ln] != null &&
                    product["sub_cat_title_" + ln] != null)
                  Text(
                    product["main_cat_title_" + ln] +
                            " > " +
                            product["sub_cat_title_" + ln] ??
                        "",
                    style: mySub,
                  ),
                SizedBox(height: 5),
                Text(firstUpper(product["name"].toString()) ?? "", style: myH3),
                SizedBox(height: 10),
                Text(
                  product["description"].toString() ?? "",
                  maxLines: 10,
                  strutStyle: StrutStyle(height: 1.5),
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(lang["wholesale"][ln] ?? "", style: mySub),
                        Row(
                          children: <Widget>[
                            Text(
                              product["wholesale_price_min"] !=
                                      product["wholesale_price_max"]
                                  ? product["wholesale_price_min"].toString() +
                                      " - " +
                                      product["wholesale_price_max"]
                                          .toString() +
                                      " " +
                                      currencyList[product["currency_id"] - 1]
                                          ["title"]
                                  : product["wholesale_price_max"].toString() +
                                      " " +
                                      currencyList[product["currency_id"] - 1]
                                          ["title"],
                              style: myH5,
                            ),
                            SizedBox(width: 5.0),
                            Text(
                                "/ " +
                                    unitList[product["unit_id"] - 1]["title"]
                                        .toUpperCase(),
                                style: mySub2),
                          ],
                        ),
                      ],
                    ),
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(lang["retail"][ln], style: mySub),
                        Row(
                          children: <Widget>[
                            Text(
                              product["retail_price"].toString() +
                                  " " +
                                  currencyList[product["currency_id"] - 1]
                                      ["title"],
                              style: myH5,
                            ),
                            SizedBox(width: 5.0),
                            Text(
                              " / " +
                                  unitList[product["unit_id"] - 1]["title"]
                                      .toUpperCase(),
                              style: mySub2,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    Icon(Icons.location_on),
                    Text(
                        product["country"][0].toUpperCase() +
                            product["country"].toString().substring(1),
                        style: myH5),
                  ],
                ),
                SizedBox(height: 0),
                Row(
                  children: <Widget>[
                    Icon(Icons.person),
                    Text(product["company_name"] ?? lang["unknown"][ln],
                        style: myH5),
                    Spacer(),
                    product["company_name"] == null
                        ? Container()
                        : SuperLiteButton(
                            title: lang["all_ads"][ln],
                            onTap: () {
                              Navigator.of(context).push(
                                CupertinoPageRoute(
                                  builder: (_) => CompanyProfile(
                                    contactId: product["business_id"],
                                    currencyList: currencyList,
                                    unitList: unitList,
                                    ln: ln,
                                    companyName: product["company_name"],
                                    email: product["email"],
                                    phone: product["phone"],
                                    address: product["business_info"][0]
                                        ["address"],
                                    city: product["business_info"][0]["city"] +
                                        ", " +
                                        product["business_info"][0]["region"] +
                                        ", " +
                                        product["business_info"][0]["country"],
                                  ),
                                ),
                              );
                            },
                          ),
                  ],
                ),
                SizedBox(height: 120),
              ],
            ),
          ),
        ],
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.only(bottom: 30.0),
        child: CallChatButton(
          ln: ln,
          callUrl: "tel:" + product["phone"].toString(),
          mailUrl:
              "mailto:${product["email"]}?subject=Flagma - ${product["name"]}",
        ),
      ),
    );
  }
}
