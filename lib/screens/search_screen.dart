import 'dart:convert';

import 'package:flagma_app/const.dart';
import 'package:flagma_app/screens/detail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

import '../lang.dart';
import '../widgets/super_app_bar.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
  final currencyList, unitList;
  final String ln;

  SearchScreen({
    this.currencyList,
    this.unitList,
    this.ln,
  });
}

class _SearchScreenState extends State<SearchScreen> {
  bool isLoading = false; // used for lazy load
  int page = 1;
  TextEditingController _searchFieldController;

  List<dynamic> searchResult = [];
  bool showLoader = false, loadFailed = false;
  String errorText = "";

  @override
  void initState() {
    _searchFieldController = new TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _searchFieldController.dispose();
    super.dispose();
  }

  Future _loadMore() async {
    List<dynamic> nextPage;
    page++;
    setState(() {
      isLoading = true;
    });
    var res = await http.get(
        "https://api.flagma.biz/api/get_ads_by_search?word=${_searchFieldController.text}&page=$page&per_page=10");

    if (res.statusCode == 200) {
      int len = searchResult.length;
      nextPage = jsonDecode(res.body)["items"];
      for (int i = 0; i < nextPage.length; i++)
        searchResult.insert(len + i, nextPage[i]);
    } else
      print(res.body + " =======>>>>>> " + res.statusCode.toString());

    setState(() {
      isLoading = false;
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
                  Expanded(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(3.0),
                      ),
                      margin: EdgeInsets.only(right: 20.0),
                      child: TextField(
                        controller: _searchFieldController,
                        autofocus: true,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          hintText: lang["search_here"][widget.ln],
                          border: InputBorder.none,
                          icon: Icon(Icons.search),
                        ),
                        onSubmitted: (value) =>
                            loadSearchResultList(value: value),
                      ),
                    ),
                  ),
                ],
              ),
              errorText.isNotEmpty
                  ? Text(errorText, style: myH5.copyWith(color: Colors.red))
                  : buildListView(context),
            ],
          ),
          loadFailed
              ? refreshButton(loadSearchResultList, widget.ln)
              : Container(),
          showLoader ? loading : Container(),
        ],
      ),
    );
  }

  void loadSearchResultList({value}) async {
    if (value == null || value.isEmpty) {
      if (_searchFieldController.text.isNotEmpty)
        value = _searchFieldController.text;
      else
        return;
    }
    value = value.trim();
    print(value);
    setState(() {
      showLoader = true;
      loadFailed = false;
      searchResult.clear();
      errorText = "";
    });

    try {
      var res = await http.get(
          "https://api.flagma.biz/api/get_ads_by_search?word=$value&page=1&per_page=10");

      if (res.statusCode == 200) {
        setState(() {
          showLoader = false;
          searchResult = jsonDecode(res.body)["items"];
          if (searchResult.length == 0) {
            errorText = lang["no_result"][widget.ln];
          }
        });
      } else
        print(res.statusCode.toString() + res.body);
    } catch (e) {
      setState(() {
        showLoader = false;
        loadFailed = true;
      });
    }
  }

  Widget buildListView(BuildContext context) {
    return 2 == 1
        ? Text(searchResult.toString())
        : Expanded(
            child: LazyLoadScrollView(
              isLoading: isLoading,
              onEndOfPage: () => _loadMore(),
              child: ListView.builder(
                padding: EdgeInsets.all(10.0),
                itemCount: searchResult.length,
                itemBuilder: (_, i) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (_) => DetailScreen(
                            product: searchResult[i],
                            currencyList: widget.currencyList,
                            unitList: widget.unitList,
                            ln: widget.ln,
                          ),
                        ),
                      );
                    },
                    child: ListTile(
                      title:
                          Text(searchResult[i]["name"].toString(), style: myH4),
                      subtitle: Text(
                        searchResult[i]["main_cat_title_" + widget.ln] +
                            " > " +
                            searchResult[i]["sub_cat_title_" + widget.ln],
                      ),
                      trailing: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            searchResult[i]["wholesale_price_min"] !=
                                    searchResult[i]["wholesale_price_max"]
                                ? searchResult[i]["wholesale_price_min"]
                                        .toString() +
                                    " - " +
                                    searchResult[i]["wholesale_price_max"]
                                        .toString() +
                                    " " +
                                    widget.currencyList[
                                            searchResult[i]["currency_id"] - 1]
                                        ["title"]
                                : searchResult[i]["wholesale_price_max"]
                                        .toString() +
                                    " " +
                                    widget.currencyList[
                                            searchResult[i]["currency_id"] - 1]
                                        ["title"],
                            style: myH5,
                          ),
                          Text(
                            widget.unitList[searchResult[i]["unit_id"] - 1]
                                    ["title"]
                                .toUpperCase(),
                            style: mySub,
                          ),
                        ],
                      ),
                      leading: searchResult[i]["images"][0]["img_url_small"] ==
                              "undefined"
                          ? Image.asset(
                              "assets/images/1.jpg",
                              fit: BoxFit.contain,
                              width: 70,
                            )
                          : Image.network(
                              searchResult[i]["images"][0]["img_url_small"],
                              fit: BoxFit.contain,
                              width: 70,
                            ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
