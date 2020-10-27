import 'dart:convert';

import 'package:flagma_app/widgets/super_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

import '../const.dart';
import '../lang.dart';
import 'detail_screen.dart';

class MyAds extends StatefulWidget {
  final currencyList, unitList;
  final String ln;
  final int contactId;

  MyAds({
    this.currencyList,
    this.unitList,
    this.ln,
    this.contactId,
  });

  @override
  _MyAdsState createState() => _MyAdsState();
}

class _MyAdsState extends State<MyAds> {
  var filterResult = [];
  int page = 0;
  bool isLoading = false, loadFailed = false;
  String userId, myUserId;

  @override
  void initState() {
    getSPString("contact_id").then((value) {
      myUserId = value;
      if (widget.contactId == null)
        userId = value;
      else
        userId = widget.contactId.toString();

      _loadFilterResuts();
    });
    super.initState();
  }

  String uri;

  void _loadFilterResuts() async {
    setState(() {
      isLoading = true;
      loadFailed = false;
    });
    page++;

    uri =
        "https://api.flagma.biz/api/get_ads_by_user_id?page=$page&per_page=10&user_id=$userId";

    getSPString("token").then((value) async {
      try {
        var res =
            await http.get(uri, headers: {"Authorization": "Bearer $value"});
        if (res.statusCode == 200) {
          if (page == 1)
            setState(() {
              filterResult = jsonDecode(res.body)["items"];
            });
          else {
            List<dynamic> nextPage;
            nextPage = jsonDecode(res.body)["items"];
            int len = filterResult.length;
            for (int i = 0; i < nextPage.length; i++)
              filterResult.insert(len + i, nextPage[i]);
          }
        } else
          print(
              "Not 200 err => " + res.statusCode.toString() + "\n" + res.body);
      } catch (e) {
        setState(() {
          isLoading = false;
          loadFailed = true;
          page--;
        });
      }

      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              SuperAppBar(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  Text(lang["ads"][widget.ln],
                      style: myH3.copyWith(color: Colors.white)),
                ],
              ),
              Expanded(
                child: LazyLoadScrollView(
                  isLoading: isLoading,
                  onEndOfPage: _loadFilterResuts,
                  child: ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemCount: filterResult.length,
                    itemBuilder: (_, i) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (_) => DetailScreen(
                                product: filterResult[i],
                                currencyList: widget.currencyList,
                                unitList: widget.unitList,
                                ln: widget.ln,
                              ),
                            ),
                          );
                        },
                        child: ListTile(
                          title: Text(
                            firstUpper(filterResult[i]["name"].toString()),
                            style: myH4,
                          ),
                          subtitle: Text(
                            firstUpper(filterResult[i]["status"]),
                            style: TextStyle(
                              color: filterResult[i]["status"] == "active"
                                  ? Colors.green
                                  : Colors.orange,
                            ),
                          ),
                          trailing: widget.contactId == null ||
                                  widget.contactId.toString() == myUserId
                              ? IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () =>
                                      deleteAd(filterResult[i]["id"]),
                                )
                              : null,
                          leading: filterResult[i]["images"][0]
                                      ["img_url_small"] ==
                                  "undefined"
                              ? Image.asset(
                                  "assets/images/1.jpg",
                                  fit: BoxFit.contain,
                                  width: 70,
                                )
                              : Image.network(
                                  filterResult[i]["images"][0]["img_url_small"],
                                  fit: BoxFit.contain,
                                  width: 70,
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (loadFailed)
            refreshButton(_loadFilterResuts, widget.ln)
          else if (isLoading)
            loading
          else if (filterResult == null || filterResult.length == 0)
            Center(
              child: Text(
                lang["no_data"][widget.ln],
                style: myH5,
              ),
            ),
        ],
      ),
    );
  }

  void deleteAd(int adId) async {
    setState(() {
      isLoading = true;
    });
    String url = "https://api.flagma.biz/api/change_adv_status";
    getSPString("token").then((value) async {
      var res = await http.post(
        url,
        headers: {"Authorization": "Bearer " + value},
        body: {"adv_id": adId.toString(), "status": "closed"},
      );
      if (res.statusCode == 200) {
        if (jsonDecode(res.body)["type"] == "success")
          setState(() {
            filterResult.removeWhere((element) => element["id"] == adId);
          });
      }
    });
    setState(() {
      isLoading = false;
    });
  }

  Column buildPriceTrailing(int i) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text(
          filterResult[i]["wholesale_price_min"] !=
                  filterResult[i]["wholesale_price_max"]
              ? filterResult[i]["wholesale_price_min"].toString() +
                  " - " +
                  filterResult[i]["wholesale_price_max"].toString() +
                  " " +
                  widget.currencyList[filterResult[i]["currency_id"] - 1]
                      ["title"]
              : filterResult[i]["wholesale_price_max"].toString() +
                  " " +
                  widget.currencyList[filterResult[i]["currency_id"] - 1]
                      ["title"],
          style: myH5,
        ),
        Text(
          widget.unitList[filterResult[i]["unit_id"] - 1]["title"]
              .toUpperCase(),
          style: mySub,
        ),
      ],
    );
  }
}
