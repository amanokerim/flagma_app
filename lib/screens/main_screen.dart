import 'dart:convert';

import 'package:flagma_app/const.dart';
import 'package:flagma_app/widgets/chat_list.dart';
import 'package:flagma_app/widgets/menu_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

import '../widgets/super_app_bar.dart';
import '../widgets/super_bottom_navigation_bar.dart';
import '../widgets/product_list_card.dart';
import 'search_screen.dart';
import '../widgets/filter_drawer.dart';

bool isLoading = false, isLoadFailed = false;

class MainScreen extends StatefulWidget {
  String ln, token;

  MainScreen({this.ln, this.token});

  @override
  _MainScreenState createState() => _MainScreenState();
}

List<dynamic> unitList = [];
List<dynamic> currencyList = [];
List<dynamic> categoryList = [];

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;
  String myText = "";
  List<dynamic> productList = [];

  void tabChanger(int i) {
    setState(() {
      selectedIndex = i;
    });
  }

  @override
  void initState() {
    loadProductList();
    super.initState();
  }

  void loadProductList() async {
    print("I am here!   in");
    setState(() {
      isLoadFailed = false;
      isLoading = true;
    });
    try {
      var res = await http.get(
          "https://api.flagma.biz/api/get_ads_by_category_id?cat_id=1&page=1&per_page=10");
      var resUnits =
          '{"items":[{"id":1,"title":"Kilogram","is_deleted":false},{"id":2,"title":"Piece","is_deleted":false},{"id":3,"title":"Liter","is_deleted":false},{"id":4,"title":"Box","is_deleted":false}]} '; //await http.get("https://api.flagma.biz/api/get_units");
      var resCurrencies =
          '{"items":[{"id":1,"title":"TMT","is_deleted":false},{"id":2,"title":"RUB","is_deleted":false},{"id":3,"title":"USD","is_deleted":false},{"id":4,"title":"EUR","is_deleted":false}]}'; //await http.get("https://api.flagma.biz/api/get_currencies");
      var resCategories;

      if (res.statusCode == 200) {
        setState(() {
          productList = jsonDecode(res.body)["items"];
          unitList = jsonDecode(resUnits)["items"];
          currencyList = jsonDecode(resCurrencies)["items"];
        });
        resCategories =
            await http.get("https://api.flagma.biz/api/get_categories");

        if (resCategories.statusCode == 200) {
          setState(() {
            categoryList = jsonDecode(resCategories.body)["items"];
            isLoading = false;
          });
        }
      }
    } catch (e) {
      print("Load failed");
      setState(() {
        isLoadFailed = true;
        isLoading = false;
      });
    }
  }

  void setLang(String lang) {
    setState(() {
      widget.ln = lang;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) => Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                SuperAppBar(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.menu, color: Colors.white),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                    SizedBox(width: 30),
                    Spacer(),
                    Text(
                      "Flagma",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.search, color: Colors.white),
                      onPressed: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (_) => SearchScreen(
                              unitList: unitList,
                              currencyList: currencyList,
                              ln: widget.ln,
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.filter_list, color: Colors.white),
                      onPressed: () {
                        Scaffold.of(context).openEndDrawer();
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: selectedIndex == 0
                      ? ProductsLists(productList: productList, ln: widget.ln)
                      : ChatsList(),
                )
              ],
            ),
            isLoadFailed
                ? refreshButton(loadProductList, widget.ln)
                : Container(),
            isLoading ? loading : Container(),
          ],
        ),
      ),
      // bottomNavigationBar: SuperBottomNavigationBar(
      //   tabChanger: tabChanger,
      //   selectedIndex: selectedIndex,
      //   ln: widget.ln,
      // ),
      drawer: MenuDrawer(
        setLang: setLang,
        currencyList: currencyList,
        unitList: unitList,
        categoryList: categoryList,
        ln: widget.ln,
        token: widget.token,
      ),
      endDrawer: FilterDrawer(
        currencyList: currencyList,
        unitList: unitList,
        categoryList: categoryList,
        ln: widget.ln,
      ),
    );
  }
}

class ProductsLists extends StatefulWidget {
  final productList;
  final String ln;

  const ProductsLists({
    Key key,
    this.productList,
    this.ln,
  }) : super(key: key);

  @override
  _ProductsListsState createState() => _ProductsListsState();
}

class _ProductsListsState extends State<ProductsLists> {
  int page = 1;

  Future _loadMore() async {
    List<dynamic> nextPage;
    page++;
    setState(() {
      isLoading = true;
    });

    var res = await http.get(
        "https://api.flagma.biz/api/get_ads_by_category_id?cat_id=1&page=$page&per_page=10");

    if (res.statusCode == 200) {
      int len = widget.productList.length;
      nextPage = jsonDecode(res.body)["items"];
      for (int i = 0; i < nextPage.length; i++)
        widget.productList.insert(len + i, nextPage[i]);
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LazyLoadScrollView(
      isLoading: isLoading,
      onEndOfPage: () => _loadMore(),
      child: GridView.builder(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        itemCount: widget.productList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: .7,
        ),
        itemBuilder: (context, index) => ProductListCard(
          ln: widget.ln,
          product: widget.productList[index],
          image: widget.productList[index]["images"][0]["img_url_small"],
          currencyList: currencyList,
          unitList: unitList,
        ),
      ),
    );
  }
}
