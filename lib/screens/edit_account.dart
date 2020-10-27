import 'dart:convert';

import 'package:flagma_app/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../const.dart';
import '../countries.dart';
import '../lang.dart';
import '../widgets/super_app_bar.dart';

class EditAccount extends StatefulWidget {
  final String ln;
  final categoryList;

  EditAccount({this.ln, this.categoryList});
  @override
  _EditAccountState createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  String token;
  bool loadFailed = false, isLoading = false;
  final _formKey = GlobalKey<FormState>();
  String errorText = "", successText = "";

  TextEditingController _companyNameController,
      _addressController,
      _cityController,
      _regionController,
      _businnesDescriptionController,
      _foundationYearController,
      _employeeCountController,
      _websiteController,
      _phoneController;

  String _selectedCountry = "Turkmenistan",
      _selectedCategory = "",
      _selectedSubCategory = "";
  int _selectedCategoryId = 1, _selectedSubCategoryId = 0;
  List<dynamic> subCategoryList;

  @override
  void initState() {
    _companyNameController = TextEditingController();
    _addressController = TextEditingController();
    _cityController = TextEditingController();
    _regionController = TextEditingController();
    _businnesDescriptionController = TextEditingController();
    _foundationYearController = TextEditingController();
    _employeeCountController = TextEditingController();
    _websiteController = TextEditingController();
    _phoneController = TextEditingController();

    _getToken();
    _getAccount();
    super.initState();
  }

  void _getAccount() {
    getSPString("email").then((email) {
      getSPString("password").then((password) async {
        print("Email: " + email + " Password: " + password);
        try {
          setState(() {
            isLoading = true;
            loadFailed = false;
          });
          var res = await http.get(
              "https://api.flagma.biz/api/get_account?email=$email&password=$password");

          if (res.statusCode == 200) {
            var resMap = jsonDecode(res.body);
            setSPString("token", resMap["token"]);

            int _selectedCatIndex = categoryList.indexWhere(
                (element) => element["id"] == resMap["category_main_id"]);

            int _selectedSubCatIndex = categoryList.indexWhere(
                (element) => element["id"] == resMap["category_sub_id"]);

            if (_selectedCatIndex == -1) _selectedCatIndex = 0;

            setState(() {
              _companyNameController.text = resMap["company_name"].toString();
              _addressController.text = resMap["address"].toString();
              _businnesDescriptionController.text =
                  resMap["business_description"].toString();
              _cityController.text = resMap["city"].toString();
              _employeeCountController.text =
                  resMap["employee_count"].toString();
              _foundationYearController.text =
                  resMap["foundation_year"].toString();
              _phoneController.text = resMap["phone"].toString();
              _regionController.text = resMap["region"].toString();
              _websiteController.text = resMap["website"].toString();

              _selectedCategoryId = categoryList[_selectedCatIndex]["id"];
              _selectedCategory =
                  categoryList[_selectedCatIndex]["title_" + widget.ln];

              // _selectedSubCategoryId = categoryList[_selectedSubCatIndex]["id"];
              // _selectedSubCategory =
              //     categoryList[_selectedSubCatIndex]["title_" + widget.ln];

              isLoading = false;
              loadFailed = false;
            });
          }
        } catch (e) {
          print(e);
          setState(() {
            isLoading = false;
            loadFailed = true;
          });
        }
      });
    });
  }

  void _getToken() {
    getSPString("token").then((value) => token = value);
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _regionController.dispose();
    _businnesDescriptionController.dispose();
    _foundationYearController.dispose();
    _employeeCountController.dispose();
    _websiteController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              buildSuperAppBar(context),
              Expanded(
                child: loadFailed
                    ? refreshButton(_getAccount, widget.ln)
                    : ListView(
                        padding: EdgeInsets.zero,
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  buildCompanyNameField(),
                                  buildCountrySelector(),
                                  buildRegionField(),
                                  buildCityField(),
                                  buildAddressField(),
                                  buildBusinnessDescriptionField(),
                                  buildFoundationYearField(),
                                  buildEmployeeCountField(),
                                  buildWebsiteField(),
                                  buildPhoneField(),
                                  buildCategorySelector(),
                                  // buildSubCategorySelector(),
                                  SizedBox(height: 10),
                                  errorText.isNotEmpty
                                      ? Center(
                                          child: Text(errorText,
                                              style: myH5.copyWith(
                                                  color: Colors.red)),
                                        )
                                      : Container(),

                                  SizedBox(height: 10),
                                  successText.isNotEmpty
                                      ? Center(
                                          child: Text(successText,
                                              style: myH5.copyWith(
                                                  color: Colors.green)),
                                        )
                                      : Container(),

                                  SizedBox(height: 20),
                                  buildEditButton(),
                                  SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
          isLoading ? loading : Container(),
        ],
      ),
    );
  }

  // Widget buildSubCategorySelector() {
  //   return subCategoryList == null || subCategoryList.length == 1
  //       ? Container()
  //       : Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: <Widget>[
  //             SizedBox(height: 20),
  //             Text(lang["subcategory"][widget.ln], style: mySub0),
  //             DropdownButton(
  //               isExpanded: true,
  //               value: _selectedSubCategory == ""
  //                   ? subCategoryList[0]["title_" + widget.ln]
  //                   : _selectedSubCategory,
  //               icon: Icon(Icons.arrow_drop_down, color: myDarkColor),
  //               underline: myUnderline,
  //               items: subCategoryList.map<DropdownMenuItem<String>>(
  //                 (value) {
  //                   return DropdownMenuItem<String>(
  //                     value: value["title_" + widget.ln],
  //                     child: Text(
  //                       value["title_" + widget.ln],
  //                       style: TextStyle(color: myDarkColor),
  //                     ),
  //                   );
  //                 },
  //               ).toList(),
  //               onChanged: (value) {
  //                 setState(() {
  //                   _selectedSubCategory = value;
  //                   if (value == lang["all"][widget.ln])
  //                     _selectedSubCategoryId = 0;
  //                   else {
  //                     _selectedSubCategoryId = subCategoryList.indexWhere(
  //                         (element) =>
  //                             element["title_" + widget.ln] ==
  //                             _selectedSubCategory);
  //                     _selectedSubCategoryId =
  //                         subCategoryList[_selectedSubCategoryId]["id"];
  //                   }
  //                 });
  //               },
  //             ),
  //             SizedBox(height: 20.0),
  //           ],
  //         );
  // }

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

  FlatButton buildEditButton() {
    return FlatButton(
      onPressed: () async {
        setState(() {
          errorText = "";
          successText = "";
          isLoading = true;
          loadFailed = false;
        });
        if (_selectedCategoryId == 1) {
          setState(() {
            setState(() {
              errorText = lang["choose_cat"][widget.ln];
            });
            return;
          });
        }
        print("token: " + token);
        if (_formKey.currentState.validate()) {
          try {
            var res = await http.post(
              "https://api.flagma.biz/api/modify_account",
              headers: {"Authorization": " Bearer " + token},
              body: {
                "company_name": _companyNameController.text,
                "country": _selectedCountry,
                "region": _regionController.text,
                "city": _cityController.text,
                "foundation_year": _foundationYearController.text,
                "employee_count": _employeeCountController.text,
                "address": _addressController.text,
                "business_description": _businnesDescriptionController.text,
                "category_main_id": _selectedCategoryId.toString(),
                "category_sub_id": _selectedSubCategoryId.toString(),
                "phone": _phoneController.text,
                "website": _websiteController.text,
              },
            );
            if (res.statusCode == 200)
              setState(() {
                successText = lang["edit_success"][widget.ln];
                setSPString("profile", "complete");
                isLoading = false;
                loadFailed = false;
              });
          } catch (e) {
            setState(() {
              errorText = lang["check_connection"][widget.ln];
              isLoading = false;
              loadFailed = true;
            });
          }
        }
      },
      color: myPrimaryColor,
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Center(
        child: Text(
          lang["edit_account"][widget.ln],
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  TextFormField buildPhoneField() {
    return TextFormField(
      controller: _phoneController,
      decoration: InputDecoration(labelText: "Phone"),
      keyboardType: TextInputType.phone,
      validator: (value) =>
          value.isEmpty ? lang["should_not_be_empty"][widget.ln] : null,
    );
  }

  TextFormField buildWebsiteField() {
    return TextFormField(
      controller: _websiteController,
      decoration: InputDecoration(labelText: "Website"),
      keyboardType: TextInputType.url,
    );
  }

  TextFormField buildFoundationYearField() {
    return TextFormField(
      controller: _foundationYearController,
      decoration: InputDecoration(labelText: "Foundation Year"),
      keyboardType: TextInputType.number,
    );
  }

  TextFormField buildEmployeeCountField() {
    return TextFormField(
      controller: _employeeCountController,
      decoration: InputDecoration(labelText: "Eployee Count"),
      keyboardType: TextInputType.number,
    );
  }

  TextFormField buildBusinnessDescriptionField() {
    return TextFormField(
      controller: _businnesDescriptionController,
      decoration: InputDecoration(
        labelText: "Businness Description",
      ),
      keyboardType: TextInputType.multiline,
      maxLines: 3,
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

  TextFormField buildAddressField() {
    return TextFormField(
      controller: _addressController,
      decoration: InputDecoration(labelText: "Address"),
      keyboardType: TextInputType.streetAddress,
      validator: (value) =>
          value.isEmpty ? lang["should_not_be_empty"][widget.ln] : null,
    );
  }

  TextFormField buildCityField() {
    return TextFormField(
      controller: _cityController,
      validator: (value) =>
          value.isEmpty ? lang["should_not_be_empty"][widget.ln] : null,
      decoration: InputDecoration(labelText: "City"),
    );
  }

  TextFormField buildCompanyNameField() {
    return TextFormField(
      controller: _companyNameController,
      validator: (value) =>
          value.isEmpty ? lang["should_not_be_empty"][widget.ln] : null,
      decoration: InputDecoration(labelText: "Company name"),
    );
  }

  TextFormField buildRegionField() {
    return TextFormField(
      controller: _regionController,
      validator: (value) =>
          value.isEmpty ? lang["should_not_be_empty"][widget.ln] : null,
      decoration: InputDecoration(labelText: "Region"),
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
      Text(lang["my_account"][widget.ln], style: myH5White),
      Spacer(),
      SizedBox(width: 40),
    ]);
  }
}
