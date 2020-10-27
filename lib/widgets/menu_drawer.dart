import 'package:flagma_app/const.dart';
import 'package:flagma_app/screens/edit_account.dart';
import 'package:flagma_app/screens/login_screen.dart';
import 'package:flagma_app/screens/main_screen.dart';
import 'package:flagma_app/screens/my_ads.dart';
import 'package:flagma_app/screens/new_ad.dart';
import 'package:flagma_app/screens/register_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../lang.dart';

class MenuDrawer extends StatefulWidget {
  final unitList, categoryList, currencyList;
  final Function setLang;
  final String ln, token;

  MenuDrawer({
    this.token,
    this.unitList,
    this.categoryList,
    this.currencyList,
    this.setLang,
    this.ln,
  });

  @override
  _MenuDrawerState createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .60,
      color: myPrimaryColor,
      padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          buildMenuTitle(context),
          SizedBox(height: 20),
          // Show proper menu items by logged in or not
          widget.token == null || widget.token == ""
              ? Column(
                  children: [
                    buildLoginButton(context),
                    buildRegisterButton(context)
                  ],
                )
              : Column(
                  children: [
                    buildNewAdButton(context),
                    buildMyAdsButton(context),
                    buildEditAccountButton(context),
                    buildLogoutButton(context),
                  ],
                ),
          Spacer(),
          buildLanguageSelector(),
        ],
      ),
    );
  }

  FlatButton buildRegisterButton(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => RegisterScreen(ln: widget.ln),
          ),
        );
      },
      child: Row(
        children: <Widget>[Text(lang["register"][widget.ln], style: myH5White)],
      ),
    );
  }

  FlatButton buildLoginButton(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => LoginScreen(ln: widget.ln),
          ),
        );
      },
      child: Row(
        children: <Widget>[Text(lang["login"][widget.ln], style: myH5White)],
      ),
    );
  }

  Row buildMenuTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(lang["flagma_menu"][widget.ln],
            style: myH3.copyWith(color: Colors.white)),
        IconButton(
          icon: Icon(Icons.close, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }

  FlatButton buildNewAdButton(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        if (widget.categoryList != null && widget.categoryList.length > 0)
          getSPString("profile").then((v) {
            if (v.isEmpty)
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => AlertDialog(
                        title: Text(lang["attention"][widget.ln]),
                        content: Text(lang["fill_company_profile"][widget.ln]),
                        actions: [
                          FlatButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                CupertinoPageRoute(
                                  builder: (_) => EditAccount(
                                    ln: widget.ln,
                                    categoryList: widget.categoryList,
                                  ),
                                ),
                              );
                            },
                            child: Text(lang["complete_profile"][widget.ln]),
                          )
                        ],
                      ));
            else
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (_) => NewAd(
                    ln: widget.ln,
                    currencyList: widget.currencyList,
                    unitList: widget.unitList,
                    categoryList: widget.categoryList,
                  ),
                ),
              );
          });
      },
      child: Row(
        children: <Widget>[Text(lang["new_ad"][widget.ln], style: myH5White)],
      ),
    );
  }

  FlatButton buildMyAdsButton(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (_) => MyAds(
              ln: widget.ln,
              currencyList: widget.currencyList,
              unitList: widget.unitList,
            ),
          ),
        );
      },
      child: Row(
        children: <Widget>[Text(lang["my_ads"][widget.ln], style: myH5White)],
      ),
    );
  }

  FlatButton buildEditAccountButton(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        if (widget.categoryList != null && widget.categoryList.length > 0)
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (_) => EditAccount(
                categoryList: widget.categoryList,
                ln: widget.ln,
              ),
            ),
          );
      },
      child: Row(
        children: <Widget>[
          Text(lang["my_account"][widget.ln], style: myH5White)
        ],
      ),
    );
  }

  FlatButton buildLogoutButton(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        setSPString("token", "");
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => MainScreen(ln: widget.ln),
          ),
        );
      },
      child: Row(
        children: <Widget>[Text(lang["logout"][widget.ln], style: myH5White)],
      ),
    );
  }

  Row buildLanguageSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
          decoration:
              widget.ln == "tm" ? myLanguageIconSelectedDecoration : null,
          child: IconButton(
            icon: Image.asset("assets/icons/turkmenistan.png"),
            onPressed: () {
              setSPString("ln", "tm");
              widget.setLang("tm");
            },
          ),
        ),
        Container(
          decoration:
              widget.ln == "ru" ? myLanguageIconSelectedDecoration : null,
          child: IconButton(
            icon: Image.asset("assets/icons/russia.png"),
            onPressed: () {
              widget.setLang("ru");
              setSPString("ln", "ru");
            },
          ),
        ),
        Container(
          decoration:
              widget.ln == "en" ? myLanguageIconSelectedDecoration : null,
          child: IconButton(
            icon: Image.asset("assets/icons/united-states.png"),
            onPressed: () {
              widget.setLang("en");
              setSPString("ln", "en");
            },
          ),
        ),
      ],
    );
  }
}
