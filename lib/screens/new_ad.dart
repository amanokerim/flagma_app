import 'dart:convert';

import 'package:flagma_app/const.dart';
import 'package:flagma_app/screens/main_screen.dart';
import 'package:flagma_app/screens/my_ads.dart';
import 'package:flagma_app/widgets/super_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;

import '../countries.dart';
import '../lang.dart';
import 'dart:io';

class NewAd extends StatefulWidget {
  final String ln;
  final unitList, categoryList, currencyList;
  NewAd({
    this.unitList,
    this.categoryList,
    this.currencyList,
    this.ln,
  });

  @override
  _NewAdState createState() => _NewAdState();
}

class _NewAdState extends State<NewAd> {
  bool isLoading = false;
  String errorText = "";

  String _selectedType = "Product",
      _selectedCategory = "",
      _selectedCountry = "Turkmenistan",
      _selectedSubCategory = "",
      _selectedCurrency = "",
      _selectedUnit = "";

  String token, contactId;

  int _selectedCategoryId = 1,
      _selectedSubCategoryId = 0,
      _selectedUnitId = 1,
      _selectedCurrencyId = 1;

  List<Map<String, dynamic>> subCategoryList;
  TextEditingController _retailPriceController,
      _wholesalePriceMinController,
      _wholesalePriceMaxController,
      _nameController,
      _descriptionController;

  List<File> img = [];

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _nameController = TextEditingController();
    _retailPriceController = TextEditingController();
    _wholesalePriceMaxController = TextEditingController();
    _wholesalePriceMinController = TextEditingController();
    _descriptionController = TextEditingController();
    _getTokenAndContactId();

    super.initState();
  }

  void _getTokenAndContactId() async {
    token = await getSPString("token");
    contactId = await getSPString("contact_id");
  }

  @override
  void dispose() {
    _nameController.dispose();
    _retailPriceController.dispose();
    _wholesalePriceMaxController.dispose();
    _wholesalePriceMinController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          buildSuperAppBar(context),
          Expanded(
            child: isLoading
                ? loading
                : ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              buildNameTextField(),
                              buildTypeSelector(),
                              buildCategorySelector(),
                              buildSubCategorySelector(),
                              buildDescriptionTextField(),
                              buildRetailPrice(),
                              buildWholeSalePrice(),
                              buildCurrencySelector(),
                              buildUnitSelector(),
                              buildCountrySelector(),
                              SizedBox(height: 10),
                              builImagePicker(),
                              buildPickedImages(),
                              Center(child: showErrorText()),
                              SizedBox(height: 20),
                              buildFlatButton(),
                              SizedBox(height: 30),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget showErrorText() {
    return //Show error text
        errorText.isNotEmpty
            ? Text(
                errorText,
                style: myH5.copyWith(color: Colors.red),
              )
            : Container();
  }

  Wrap buildPickedImages() {
    return Wrap(
      spacing: 5.0,
      children: [
        for (var i = 0; i < img.length; i++)
          Stack(
            children: [
              Container(
                height: 70,
                child: Image.file(img[i]),
              ),
              Positioned(
                top: 5,
                right: 5,
                child: GestureDetector(
                  child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                      child: Icon(
                        Icons.close,
                        size: 18.0,
                        color: Colors.white,
                      )),
                  onTap: () {
                    setState(() {
                      img.removeAt(i);
                    });
                    // print("Delete image pressed");
                  },
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget builImagePicker() {
    // If choosen images is less than 5 let pick image
    return img.length < 5
        ? IconButton(
            icon: Icon(Icons.add_a_photo, size: 30),
            onPressed: () async {
              File tempFile = await ImagePicker.pickImage(
                source: ImageSource.gallery,
                maxHeight: 500,
              );
              setState(() {
                img.add(tempFile);
              });
            },
          )
        : Container();
  }

  FlatButton buildFlatButton() {
    return FlatButton(
      onPressed: () async {
        if (img.length == 0) {
          setState(() {
            errorText = lang["choose_image"][widget.ln];
          });
          return;
        }
        if (_selectedCategoryId == 1 || _selectedSubCategoryId == 0) {
          setState(() {
            errorText = lang["choose_cat"][widget.ln];
          });
          return;
        }

        if (_formKey.currentState.validate()) {
          setState(() {
            isLoading = true;
            errorText = "";
          });
          print("Starting to upload");

          var request = http.MultipartRequest(
            "POST",
            Uri.parse("https://api.flagma.biz/api/upload_images"),
          );

          print("Declares request");

          request.headers.addAll({"Authorization": "Bearer " + token});

          for (var i = 0; i < img.length; i++) {
            var multipartFile = await http.MultipartFile.fromPath(
              "img_" + i.toString(),
              img[i].path,
              contentType: MediaType('image', 'jpeg'),
            );
            request.files.add(multipartFile);
          }

          print("Added images to request");

          try {
            http.StreamedResponse response = await request.send();

            response.stream.transform(utf8.decoder).listen((images) async {
              var res = await http.post(
                "https://api.flagma.biz/api/add_adv",
                headers: {"Authorization": " Bearer " + token},
                body: {
                  "name": _nameController.text,
                  "category_main_id": _selectedCategoryId.toString(),
                  "category_sub_id": _selectedSubCategoryId.toString(),
                  "type": _selectedType,
                  "retail_price": _retailPriceController.text,
                  "currency_id": _selectedCurrencyId.toString(),
                  "unit_id": _selectedUnitId.toString(),
                  "wholesale_price_min": _wholesalePriceMinController.text,
                  "wholesale_price_max": _wholesalePriceMaxController.text,
                  "description": _descriptionController.text,
                  "contact_id": contactId,
                  "country": _selectedCountry,
                  "images": images
                },
              );
              var resMap = jsonDecode(res.body);
              if (res.statusCode == 200) {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (_) => MyAds(
                    currencyList: widget.currencyList,
                    unitList: widget.unitList,
                    ln: widget.ln,
                  ),
                ));
              } else
                setState(() {
                  errorText = resMap["code_" + widget.ln];
                });
            });
          } catch (e) {
            setState(() {
              errorText = lang["check_connection"][widget.ln];
              isLoading = false;
              print("load failed");
            });
          }
        }
      },
      color: myPrimaryColor,
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Center(
        child: Text(
          lang["add_new_ad"][widget.ln],
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Column buildCountrySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 20.0),
        Text(lang["country"][widget.ln], style: mySub0),
        SizedBox(height: 10.0),
        DropdownButton(
          isExpanded: true,
          value:
              _selectedCountry.isNotEmpty ? _selectedCountry : "Turkmenistan",
          icon: Icon(
            Icons.arrow_drop_down,
            color: myDarkColor,
          ),
          underline: Container(),
          isDense: true,
          items: countries.map<DropdownMenuItem<String>>(
            (String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: TextStyle(color: myDarkColor)),
              );
            },
          ).toList(),
          onChanged: (value) {
            setState(() {
              _selectedCountry = value;
            });
          },
        ),
      ],
    );
  }

  TextFormField buildDescriptionTextField() {
    return TextFormField(
      controller: _descriptionController,
      decoration: InputDecoration(
        labelText: lang["description"][widget.ln],
      ),
      validator: (value) =>
          value.isEmpty ? lang["should_not_be_empty"][widget.ln] : null,
      maxLines: 3,
      maxLength: 300,
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Column buildUnitSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 20),
        Text(
          lang["unit"][widget.ln],
          style: mySub0,
        ),
        DropdownButton(
          isExpanded: true,
          value:
              _selectedUnit.isNotEmpty ? _selectedUnit : unitList[0]["title"],
          icon: Icon(Icons.arrow_drop_down, color: myDarkColor),
          underline: myUnderline,
          items: unitList.map<DropdownMenuItem<String>>(
            (value) {
              return DropdownMenuItem<String>(
                value: value["title"],
                child: Text(
                  value["title"],
                  style: TextStyle(color: myDarkColor),
                ),
              );
            },
          ).toList(),
          onChanged: (value) {
            int _selectedUnitIndex =
                unitList.indexWhere((element) => element["title"] == value);
            setState(() {
              _selectedUnit = value;
              _selectedUnitId = currencyList[_selectedUnitIndex]["id"];
            });
          },
        ),
      ],
    );
  }

  Column buildCurrencySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 20),
        Text(
          lang["currency"][widget.ln],
          style: mySub0,
        ),
        DropdownButton(
          isExpanded: true,
          value: _selectedCurrency.isNotEmpty
              ? _selectedCurrency
              : currencyList[0]["title"],
          icon: Icon(Icons.arrow_drop_down, color: myDarkColor),
          underline: myUnderline,
          items: currencyList.map<DropdownMenuItem<String>>(
            (value) {
              return DropdownMenuItem<String>(
                value: value["title"],
                child: Text(
                  value["title"],
                  style: TextStyle(color: myDarkColor),
                ),
              );
            },
          ).toList(),
          onChanged: (value) {
            int _selectedCurrenctIndex =
                currencyList.indexWhere((element) => element["title"] == value);
            setState(() {
              _selectedCurrency = value;
              _selectedCurrencyId = currencyList[_selectedCurrenctIndex]["id"];
              // errorText = _selectedCurrency + _selectedCurrencyId.toString();
            });
          },
        ),
      ],
    );
  }

  Column buildWholeSalePrice() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 20.0),
        Text(lang["wholesale_price"][widget.ln], style: mySub0),
        Row(
          children: <Widget>[
            Expanded(
              child: TextFormField(
                controller: _wholesalePriceMinController,
                decoration: InputDecoration(
                  labelText: lang["min"][widget.ln],
                  contentPadding: EdgeInsets.only(top: 2),
                ),
                validator: (value) => value.isEmpty
                    ? lang["should_not_be_empty"][widget.ln]
                    : null,
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(width: 50),
            Expanded(
              child: TextFormField(
                controller: _wholesalePriceMaxController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(top: 2),
                  labelText: lang["max"][widget.ln],
                ),
                validator: (value) => value.isEmpty
                    ? lang["should_not_be_empty"][widget.ln]
                    : null,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        )
      ],
    );
  }

  TextFormField buildRetailPrice() {
    return TextFormField(
      controller: _retailPriceController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: lang["retail_price"][widget.ln],
      ),
      validator: (value) =>
          value.isEmpty ? lang["should_not_be_empty"][widget.ln] : null,
    );
  }

  Widget buildSubCategorySelector() {
    return subCategoryList == null || subCategoryList.length == 1
        ? Container()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20),
              Text(lang["subcategory"][widget.ln], style: mySub0),
              DropdownButton(
                isExpanded: true,
                value: _selectedSubCategory == ""
                    ? subCategoryList[0]["title_" + widget.ln]
                    : _selectedSubCategory,
                icon: Icon(Icons.arrow_drop_down, color: myDarkColor),
                underline: myUnderline,
                items: subCategoryList.map<DropdownMenuItem<String>>(
                  (value) {
                    return DropdownMenuItem<String>(
                      value: value["title_" + widget.ln],
                      child: Text(
                        value["title_" + widget.ln],
                        style: TextStyle(color: myDarkColor),
                      ),
                    );
                  },
                ).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSubCategory = value;
                    if (value == lang["all"][widget.ln])
                      _selectedSubCategoryId = 0;
                    else {
                      _selectedSubCategoryId = subCategoryList.indexWhere(
                          (element) =>
                              element["title_" + widget.ln] ==
                              _selectedSubCategory);
                      _selectedSubCategoryId =
                          subCategoryList[_selectedSubCategoryId]["id"];
                    }
                  });
                },
              ),
              SizedBox(height: 20.0),
            ],
          );
  }

  Column buildCategorySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 20),
        Text(lang["category"][widget.ln], style: mySub0),
        DropdownButton(
          isExpanded: true,
          value: _selectedCategory.isNotEmpty
              ? _selectedCategory
              : widget.categoryList[0]["title_" + widget.ln],
          icon: Icon(Icons.arrow_drop_down, color: myDarkColor),
          underline: myUnderline,
          items: widget.categoryList
              .where((element) =>
                  element["parent_id"] == 0 || element["parent_id"] == 1)
              .map<DropdownMenuItem<String>>(
            (value) {
              return DropdownMenuItem<String>(
                value: value["title_" + widget.ln],
                child: Text(
                  value["title_" + widget.ln],
                  style: TextStyle(color: myDarkColor),
                ),
              );
            },
          ).toList(),
          onChanged: (value) {
            int _selectedCategoryIndex = widget.categoryList.indexWhere(
              (element) => element["title_" + widget.ln] == value,
            );
            setState(() {
              _selectedCategory = value;
              _selectedCategoryId =
                  widget.categoryList[_selectedCategoryIndex]["id"];
              subCategoryList = List.from(
                widget.categoryList.where(
                    (element) => element["parent_id"] == _selectedCategoryId),
              );
              subCategoryList.insert(0, {
                "id": 0,
                "title_tm": lang["all"]["tm"],
                "title_en": lang["all"]["en"],
                "title_ru": lang["all"]["ru"],
                "parent_id": 1,
                "is_deleted": false
              });
              _selectedSubCategory = "";
              _selectedSubCategoryId = 0;
            });
            // print(subCategoryList);
          },
        ),
      ],
    );
  }

  TextFormField buildNameTextField() {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        labelText: lang["name"][widget.ln],
      ),
      validator: (value) =>
          value.isEmpty ? lang["should_not_be_empty"][widget.ln] : null,
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Column buildTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 20),
        Text(
          lang["type"][widget.ln],
          style: mySub0,
        ),
        DropdownButton(
          isExpanded: true,
          value: _selectedType.isNotEmpty ? _selectedType : types[0],
          icon: Icon(Icons.arrow_drop_down, color: myDarkColor),
          underline: myUnderline,
          items: types.map<DropdownMenuItem<String>>(
            (String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(color: myDarkColor),
                ),
              );
            },
          ).toList(),
          onChanged: (value) {
            setState(() {
              _selectedType = value;
            });
          },
        ),
      ],
    );
  }

  SuperAppBar buildSuperAppBar(BuildContext context) {
    return SuperAppBar(children: <Widget>[
      IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          }),
      Spacer(),
      Text(lang["new_ad"][widget.ln], style: myH5White),
      Spacer(),
      SizedBox(width: 40),
    ]);
  }
}
