import 'dart:convert';

import 'package:flagma_app/screens/filter_screen.dart';
import 'package:flagma_app/screens/main_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../const.dart';
import '../countries.dart';
import '../lang.dart';

class FilterDrawer extends StatefulWidget {
  final currencyList, unitList, categoryList;
  final String ln;

  FilterDrawer({
    Key key,
    this.currencyList,
    this.unitList,
    this.categoryList,
    this.ln,
  }) : super(key: key);

  @override
  _FilterDrawerState createState() => _FilterDrawerState();
}

class _FilterDrawerState extends State<FilterDrawer> {
  TextEditingController _minController, _maxController;
  String selectedCountry = "",
      selectedType = "",
      selectedCategory = "",
      selectedSubCategory = "";
  int selectedCategoryId = 1, selectedSubCategoryId = 0;
  List<Map<String, dynamic>> subCategoryList;

  @override
  void initState() {
    _minController = TextEditingController();
    _maxController = TextEditingController();
    if (countries[0] != lang["all_countries"][widget.ln])
      countries.insert(0, lang["all_countries"][widget.ln]);
    super.initState();
  }

  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        width: MediaQuery.of(context).size.width * .9,
        padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 20.0),
        color: myPrimaryColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                Text(lang["filter"][widget.ln],
                    style: myH3.copyWith(color: Colors.white)),
                Spacer(),
                FlatButton(
                  onPressed: () {
                    setState(() {
                      _minController.text = "";
                      _maxController.text = "";
                      selectedCountry = "";
                      selectedType = "";
                      selectedCategory = "";
                      selectedSubCategory = "";
                      selectedCategoryId = 1;
                      selectedSubCategoryId = 0;
                      if (subCategoryList != null) subCategoryList.clear();
                    });
                  },
                  child: Text(
                    lang["clear"][widget.ln],
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
            SizedBox(height: 20.0),
            Text(lang["category"][widget.ln], style: myH5White),
            SizedBox(height: 10.0),
            DropdownButton(
              isExpanded: true,
              dropdownColor: myPrimaryColor.withOpacity(.9),
              value: selectedCategory.isNotEmpty
                  ? selectedCategory
                  : lang["all"][widget.ln],
              icon: Icon(Icons.arrow_drop_down, color: Colors.white),
              underline: Container(),
              isDense: true,
              items: categoryList
                  .where((element) => element["parent_id"] <= 1)
                  .map<DropdownMenuItem<String>>(
                (value) {
                  return DropdownMenuItem<String>(
                    value: value["title_" + widget.ln],
                    child: Text(
                      value["title_" + widget.ln],
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                },
              ).toList(),
              onChanged: (value) {
                int selectedCategoryIndex = categoryList.indexWhere(
                    (element) => element["title_" + widget.ln] == value);
                setState(() {
                  selectedCategory = value;
                  selectedCategoryId =
                      categoryList[selectedCategoryIndex]["id"];
                  subCategoryList = List.from(
                    categoryList.where((element) =>
                        element["parent_id"] == selectedCategoryId),
                  );
                  subCategoryList.insert(
                      0, {"title_" + widget.ln: lang["all"][widget.ln]});
                  selectedSubCategory = "";
                });
              },
            ),
            SizedBox(height: 20.0),
            subCategoryList == null || subCategoryList.length == 0
                ? Container()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(lang["subcategory"][widget.ln], style: myH5White),
                      SizedBox(height: 10.0),
                      DropdownButton(
                        isExpanded: true,
                        dropdownColor: myPrimaryColor.withOpacity(.9),
                        value: selectedSubCategory == ""
                            ? subCategoryList[0]["title_" + widget.ln]
                            : selectedSubCategory,
                        icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                        underline: Container(),
                        isDense: true,
                        items: subCategoryList.map<DropdownMenuItem<String>>(
                          (value) {
                            return DropdownMenuItem<String>(
                              value: value["title_" + widget.ln],
                              child: Text(
                                value["title_" + widget.ln],
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          },
                        ).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedSubCategory = value;
                            if (value == lang["all"][widget.ln])
                              selectedSubCategoryId = 0;
                            else {
                              selectedSubCategoryId =
                                  subCategoryList.indexWhere((element) =>
                                      element["title_" + widget.ln] ==
                                      selectedSubCategory);
                              selectedSubCategoryId =
                                  subCategoryList[selectedSubCategoryId]["id"];
                            }
                          });
                        },
                      ),
                      SizedBox(height: 20.0),
                    ],
                  ),
            Text(lang["country"][widget.ln], style: myH5White),
            SizedBox(height: 10.0),
            DropdownButton(
              isExpanded: true,
              dropdownColor: myPrimaryColor.withOpacity(.9),
              value:
                  selectedCountry.isNotEmpty ? selectedCountry : countries[0],
              icon: Icon(Icons.arrow_drop_down, color: Colors.white),
              underline: Container(),
              isDense: true,
              items: countries.map<DropdownMenuItem<String>>(
                (String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(color: Colors.white)),
                  );
                },
              ).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCountry = value;
                });
              },
            ),
            SizedBox(height: 20.0),
            Text(lang["type"][widget.ln], style: myH5White),
            SizedBox(height: 10.0),
            DropdownButton(
              isExpanded: true,
              dropdownColor: myPrimaryColor.withOpacity(.9),
              value: selectedType.isNotEmpty ? selectedType : "Product",
              icon: Icon(Icons.arrow_drop_down, color: Colors.white),
              underline: Container(),
              isDense: true,
              items: types.map<DropdownMenuItem<String>>(
                (String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(color: Colors.white)),
                  );
                },
              ).toList(),
              onChanged: (value) {
                setState(() {
                  selectedType = value;
                });
              },
            ),
            SizedBox(height: 20),
            Text(lang["price"][widget.ln], style: myH5White),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: 100,
                  child: TextField(
                    controller: _minController,
                    decoration: myFilterInputDecoration.copyWith(
                        labelText: lang["min"][widget.ln]),
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                  ),
                ),
                Container(
                  width: 100,
                  child: TextField(
                    controller: _maxController,
                    decoration: myFilterInputDecoration.copyWith(
                        labelText: lang["max"][widget.ln]),
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            Spacer(),
            Center(
              child: FlatButton(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                child: Text(lang["show_results"][widget.ln]),
                onPressed: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (_) => FilterScreen(
                        ln: widget.ln,
                        currencyList: currencyList,
                        unitList: unitList,
                        priceMin: _minController.text.isNotEmpty
                            ? double.parse(_minController.text)
                            : 0,
                        priceMax: _maxController.text.isNotEmpty
                            ? double.parse(_maxController.text)
                            : 0,
                        country:
                            selectedCountry == lang["all_countries"][widget.ln]
                                ? ""
                                : selectedCountry,
                        type: selectedType,
                        // If subcategory not selected send categoryId
                        catId: selectedSubCategoryId > 0
                            ? selectedSubCategoryId
                            : selectedCategoryId,
                      ),
                    ),
                  );
                },
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
