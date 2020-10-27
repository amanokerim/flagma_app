import 'dart:convert';

import 'package:flagma_app/widgets/super_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

import '../const.dart';
import '../lang.dart';
import 'detail_screen.dart';

class FilterScreen extends StatefulWidget {
  final int catId, unitId, currencyId;
  final String type, country;
  final double priceMin, priceMax;
  final currencyList, unitList;
  final String ln;

  FilterScreen({
    this.catId,
    this.priceMin,
    this.priceMax,
    this.unitId,
    this.currencyId,
    this.type,
    this.country,
    this.currencyList,
    this.unitList,
    this.ln,
  });

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  var filterResult = [];
  int page = 0;
  bool isLoading = false, loadFailed = false;

  @override
  void initState() {
    _loadFilterResuts();
    super.initState();
  }

  String uri;
  String errorText = "";

  void _loadFilterResuts() async {
    setState(() {
      isLoading = true;
      loadFailed = false;
    });
    try {
      String countryStr =
          widget.country.isNotEmpty ? "&country=${widget.country}" : "";
      String typeStr = widget.type.isNotEmpty ? "&type=${widget.type}" : "";
      String priceMinStr = "&price_min=${widget.priceMin}";
      String priceMaxStr =
          widget.priceMax > 0 ? "&price_max=${widget.priceMax}" : "";
      String categoryStr = "&cat_id=${widget.catId}";
      page++;
      uri =
          "https://api.flagma.biz/api/get_ads_by_filter?page=$page&per_page=10$categoryStr$countryStr$typeStr$priceMinStr$priceMaxStr";
      print("================" + uri);
      var res = await http.get(uri);

      print("Status code=" + res.statusCode.toString());
      if (res.statusCode == 200) {
        if (page == 1)
          setState(() {
            filterResult = jsonDecode(res.body)["items"];

            if (filterResult.length == 0)
              errorText = lang["no_result"][widget.ln];
          });
        else {
          List<dynamic> nextPage;
          nextPage = jsonDecode(res.body)["items"];
          int len = filterResult.length;
          for (int i = 0; i < nextPage.length; i++)
            filterResult.insert(len + i, nextPage[i]);
        }
      } else {
        print("not 200 err => " + res.body);
        setState(() {
          errorText = jsonDecode(res.body)["code_" + widget.ln];
          loadFailed = true;
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
        loadFailed = true;
        page--;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
                  Text(lang["filter"][widget.ln],
                      style: myH3.copyWith(color: Colors.white)),
                ],
              ),
              errorText != null && errorText.isNotEmpty
                  ? Text(errorText, style: myH5.copyWith(color: Colors.red))
                  : Expanded(
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
                                    firstUpper(
                                        filterResult[i]["name"].toString()),
                                    style: myH4),
                                subtitle: Text(
                                  filterResult[i]
                                          ["main_cat_title_" + widget.ln] +
                                      " > " +
                                      filterResult[i]
                                          ["sub_cat_title_" + widget.ln],
                                ),
                                trailing: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      filterResult[i]["wholesale_price_min"] !=
                                              filterResult[i]
                                                  ["wholesale_price_max"]
                                          ? filterResult[i]["wholesale_price_min"].toString() +
                                              " - " +
                                              filterResult[i]
                                                      ["wholesale_price_max"]
                                                  .toString() +
                                              " " +
                                              widget.currencyList[filterResult[i]
                                                      ["currency_id"] -
                                                  1]["title"]
                                          : filterResult[i]["wholesale_price_max"]
                                                  .toString() +
                                              " " +
                                              widget.currencyList[filterResult[i]
                                                      ["currency_id"] -
                                                  1]["title"],
                                      style: myH5,
                                    ),
                                    Text(
                                      widget.unitList[
                                              filterResult[i]["unit_id"] - 1]
                                              ["title"]
                                          .toUpperCase(),
                                      style: mySub,
                                    ),
                                  ],
                                ),
                                leading: filterResult[i]["images"][0]
                                            ["img_url_small"] ==
                                        "undefined"
                                    ? Image.asset(
                                        "assets/images/1.jpg",
                                        fit: BoxFit.contain,
                                        width: 70,
                                      )
                                    : Image.network(
                                        filterResult[i]["images"][0]
                                            ["img_url_small"],
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
          isLoading ? loading : Container(),
          loadFailed
              ? refreshButton(_loadFilterResuts, widget.ln)
              : Container(),
        ],
      ),
    );
  }
}
