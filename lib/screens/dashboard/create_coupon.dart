import 'dart:io';

import 'package:cuo_cutter/models/coupon.dart';
import 'package:cuo_cutter/storage/storage.dart';
import 'package:cuo_cutter/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:validators/validators.dart';
import 'package:currency_picker/currency_picker.dart';

class CreateCouponPage extends StatefulWidget {
  @override
  _CreateCouponPageState createState() => _CreateCouponPageState();
}

class _CreateCouponPageState extends State<CreateCouponPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _dateController;
  TextEditingController _couponDescController;
  TextEditingController _catController;
  FocusNode _focusNode;

  static DateFormat _dateFormat = DateFormat.yMMMMd();
  String _expiringDate;
  String _desc;
  int _expiringDateInEpoch;
  bool _isTextCoupon = false;
  bool _unlimtedRedemption = true;
  bool _singleUserRedemption = false;
  String _currencyCode;
  DiscountType _discountType = DiscountType.percentageOff;

  double _amountOff;
  double _percentageOff;

  int _redemptionLimit;
  String _webUrl;
  String _textCouponCode;
  bool _show = true;
  List<String> _catsList = [];
  List<String> _catsSelected = [];
  List<Widget> _catsSelectedWidget = [];
  List<String> _allCategories = [];
  final _buttonColor = primaryColor;

  @override
  void initState() {
    _expiringDate = _dateFormat.format(DateTime.now());
    _focusNode = FocusNode();
    _catController = TextEditingController();
    _dateController = TextEditingController(text: _expiringDate);
    _currencyCode = Storage.instance.getDefaultCurrency();
    _couponDescController = TextEditingController();
    initData();
    super.initState();
  }

  initData() async {
    _catsList = await Storage.instance.getCouponsCategories();
  }

  @override
  void dispose() {
    _dateController?.dispose();
    _couponDescController?.dispose();
    _catController?.dispose();
    _focusNode?.dispose();
    super.dispose();
  }

  _resetControllers() {
    _couponDescController?.clear();
  }

  Widget _buildTag(String value) {
    _catsSelected.add(value);
    Widget wid;
    wid = Container(
      margin: EdgeInsets.only(right: 10, bottom: 5),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.white,
            onPrimary: Colors.black87,
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          ),
          child: Text(
            value,
          ),
          onPressed: () {
            setState(() {
              _catsSelectedWidget.remove(wid);
            });
            _catsSelected.remove(value);
          }),
    );
    setState(() {
      _catsSelectedWidget.add(wid);
    });
    return wid;
  }

  _submitForm() {
    var future = Storage.instance.createStoreCoupon(
      discountType: _discountType,
      amountOff: _amountOff,
      percentageOff: _percentageOff,
      desc: _desc,
      expiringDate: _expiringDateInEpoch,
      categories: _catsSelected,
      currencyCode: _currencyCode,
      //singleUserUse: _singleUserRedemption,
      unlimitedRedemption: _unlimtedRedemption,
      redemptionLimit: _redemptionLimit,
      isTextCoupon: _isTextCoupon,
      textCouponCode: _textCouponCode,
      webUrl: _webUrl,
    );

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: FutureBuilder<void>(
              future: future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 80),
                      SizedBox(
                        height: 50,
                        width: 50,
                        child: CircularProgressIndicator(
                          backgroundColor: secondaryColor.withOpacity(0.5),
                          strokeWidth: 6,
                        ),
                      ),
                      SizedBox(height: 80),
                    ],
                  );
                }
                if (snapshot.hasError) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 30),
                      Icon(
                        Icons.error,
                        color: onErrorColor,
                        size: 46,
                      ),
                      SizedBox(height: 30),
                      Text("Unable to create coupon", style: body1),
                      SizedBox(height: 50),
                      Container(
                        alignment: Alignment.bottomCenter,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: _buttonColor,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 100, vertical: 10),
                            ),
                            onPressed: () {
                              Navigator.maybeOf(context).pop();
                            },
                            child: Text(
                              "Close",
                              style: body1,
                            )),
                      ),
                      SizedBox(height: 20),
                    ],
                  );
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  _resetControllers();

                  return Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 30),
                        Icon(
                          Icons.done_rounded,
                          size: 46,
                        ),
                        SizedBox(height: 30),
                        Text("Coupon Created", style: body1),
                        SizedBox(height: 50),
                        Container(
                          alignment: Alignment.bottomCenter,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: _buttonColor,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 100, vertical: 10),
                              ),
                              onPressed: () {
                                Navigator.maybeOf(context).pop();
                              },
                              child: Text(
                                "Close",
                                style: body1,
                              )),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  );
                }
                return Container();
              },
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundVariant1Color,
        iconTheme: IconThemeData(color: primaryColor),
        elevation: 0.5,
        title: Text(
          "Create Coupon",
          style: h5,
        ),
      ),
      backgroundColor: backgroundVariant1Color,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          margin: EdgeInsets.only(top: 20),
          child: Stack(
            children: [
              ListView(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownButtonFormField<DiscountType>(
                          isExpanded: true,
                          dropdownColor: backgroundVariant3Color,
                          decoration: InputDecoration(
                            labelText: "Coupon Type",
                            border: OutlineInputBorder(),
                          ),
                          hint: Text("type of discount the coupon represent"),
                          value: DiscountType.percentageOff,
                          onChanged: (value) {
                            setState(() {
                              _discountType = value;
                            });
                          },
                          items: [
                            DropdownMenuItem(
                              child: Text("Percentage off"),
                              value: DiscountType.percentageOff,
                            ),
                            DropdownMenuItem(
                              child: Text("Amount off"),
                              value: DiscountType.amount_off,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        if (_discountType == DiscountType.percentageOff)
                          TextFormField(
                            onFieldSubmitted: (percentageOff) {
                              _percentageOff = double.parse(percentageOff);
                            },
                            maxLines: 1,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Enter percentage off",
                              labelText: "Percentage off",
                            ),
                            validator: (String value) {
                              if (!isLength(value, 1)) {
                                return 'Enter a value';
                              }

                              var c = int.parse(value);
                              if (c <= 0) {
                                return "percentage off must be greather than 0";
                              }
                              return null;
                            },
                          ),
                        if (_discountType == DiscountType.amount_off)
                          TextFormField(
                            onFieldSubmitted: (amountOff) {
                              _amountOff = double.parse(amountOff);
                            },
                            maxLines: 1,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Enter amount off",
                              labelText: "Amount off",
                            ),
                            validator: (String value) {
                              if (!isLength(value, 1)) {
                                return 'Enter a value';
                              }

                              var c = int.parse(value);
                              if (c <= 0) {
                                return "amount off must be greather than 0";
                              }
                              return null;
                            },
                          ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: _couponDescController,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: "Coupon Description",
                            hintText: "Enter coupon description",
                            border: OutlineInputBorder(),
                          ),
                          minLines: 1,
                          maxLines: 4,
                          maxLength: 200,
                          onFieldSubmitted: (value) {
                            _desc = value;
                          },
                          validator: (String value) {
                            if (!isLength(value, 20)) {
                              return 'value lenght must be greather than 20';
                            }

                            return null;
                          },
                        ),
                        Text(
                          "An example of a description is 'Get 10% off when you spend 1000 or more at our store'",
                          style: body2.copyWith(color: Colors.grey),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.datetime,
                          textInputAction: TextInputAction.next,
                          controller: _dateController,
                          decoration: InputDecoration(
                            labelText: "Expiring date",
                            hintText: "Enter Coupon expiring date",
                            border: OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(FontAwesomeIcons.calendarAlt),
                              onPressed: () async {
                                var v = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.now().add(
                                      Duration(days: 365),
                                    ),
                                    helpText: "select expiring date",
                                    fieldHintText: "select expiring date");

                                setState(() {
                                  var _exp = _dateFormat.format(v);

                                  _dateController.value =
                                      TextEditingValue(text: _exp);
                                });
                              },
                            ),
                          ),
                          onFieldSubmitted: (value) {
                            _expiringDateInEpoch =
                                DateTime.tryParse(value).millisecondsSinceEpoch;
                          },
                          validator: (value) {
                            DateTime date;
                            try {
                              date = _dateFormat.parse(value);
                            } catch (e) {
                              return "Not a valid date";
                            }
                            if (date.isBefore(DateTime.now())) {
                              return "date cannot be lesser than today";
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        TypeAheadFormField(
                          suggestionsBoxController: SuggestionsBoxController(),
                          hideOnEmpty: true,
                          hideOnError: true,
                          validator: (value) {
                            if (_catsSelected.length < 1) {
                              return "select at least 1 category";
                            }
                            return null;
                          },
                          direction: AxisDirection.up,
                          textFieldConfiguration: TextFieldConfiguration(
                            textInputAction: TextInputAction.next,
                            controller: _catController,
                            focusNode: _focusNode,
                            onSubmitted: (value) {
                              setState(() {
                                _catController.clear();
                              });
                              _buildTag(value);
                            },
                            decoration: InputDecoration(
                              labelText: "categories",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          transitionBuilder:
                              (context, suggestionBox, controller) {
                            return suggestionBox;
                          },
                          onSuggestionSelected: (value) {
                            _buildTag(value);
                          },
                          suggestionsCallback: (value) {
                            var c = _catsList.where((element) => element
                                .toLowerCase()
                                .contains("value".toLowerCase()));

                            return c;
                          },
                          itemBuilder: (context, value) {
                            return Container(
                              padding: EdgeInsets.all(20),
                              child: Text(value),
                            );
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Wrap(
                          children: _catsSelectedWidget,
                        ),
                        SizedBox(
                          height: 30,
                        ),

                        if (_discountType == DiscountType.amount_off)
                          ListTile(
                            contentPadding: EdgeInsets.only(right: 15),
                            title: Text(
                              "Currency",
                              style: body1,
                            ),
                            subtitle: Text("Select coupon currency"),
                            trailing: GestureDetector(
                              onTap: () {
                                showCurrencyPicker(
                                  context: context,
                                  showFlag: true,
                                  showCurrencyName: true,
                                  showCurrencyCode: true,
                                  onSelect: (Currency currency) {
                                    var c = currency.code;
                                    _currencyCode = c;
                                  },
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.only(
                                    top: 20, bottom: 20, left: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(1000),
                                  //  color: Colors.red,
                                ),
                                child: Text(
                                  _currencyCode,
                                  style: body1,
                                ),
                              ),
                            ),
                          ),

                        SwitchListTile.adaptive(
                          activeColor: _buttonColor,
                          dense: false,
                          contentPadding: EdgeInsets.all(0),
                          isThreeLine: true,
                          title: Text("Text coupon"),
                          subtitle: Text(
                              "generate text coupon that can be validated through your backend"),
                          value: _isTextCoupon,
                          onChanged: (value) {
                            setState(() {
                              _isTextCoupon = value;
                              if (value) {
                                _show = value;
                              }
                            });
                          },
                        ),
                        if (_isTextCoupon)
                          /*    Container(
                            padding: EdgeInsets.only(top: 20),
                            child: TextFormField(
                              onFieldSubmitted: (value) {
                                _textCouponCode = value;
                              },
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                labelText: "Coupon code",
                                hintText: "Enter Coupon code",
                                border: OutlineInputBorder(),
                              ),
                              minLines: 1,
                              maxLines: 4,
                              maxLength: 50,
                              validator: (String value) {
                                return null;
                              },
                            ),
                          ), */
                          if (_isTextCoupon)
                            Container(
                              padding: EdgeInsets.only(top: 20),
                              child: TextFormField(
                                onFieldSubmitted: (value) {
                                  _webUrl = value;
                                },
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  labelText: "Enter website url",
                                  hintText:
                                      "Enter website url coupon can be used",
                                  border: OutlineInputBorder(),
                                ),
                                minLines: 1,
                                maxLines: 4,
                                maxLength: 200,
                                validator: (String value) {
                                  if (!isURL(value)) {
                                    return "not a valid url";
                                  }
                                  return null;
                                },
                              ),
                            ),
                        //future_v2
                        /*   if (!_isTextCoupon)
                          SwitchListTile.adaptive(
                            activeColor: _buttonColor,
                            dense: false,
                            contentPadding: EdgeInsets.all(0),
                            isThreeLine: true,
                            title: Text("Single user instance use"),
                            subtitle: Text(
                                "A single user can only use this coupon once.A fresh coupon image is generated for each  individual user"),
                            value: _singleUserRedemption,
                            onChanged: (value) {
                              setState(() {
                                _singleUserRedemption = value;
                              });
                            },
                          ), */

                        SwitchListTile.adaptive(
                          dense: false,
                          activeColor: _buttonColor,
                          contentPadding: EdgeInsets.only(bottom: 20),
                          isThreeLine: true,
                          title: Text("Unlimited redemption"),
                          subtitle: Text(
                              "The coupon has no limit on the number of times it can be use by an unlimited number of people"),
                          value: _unlimtedRedemption,
                          onChanged: (value) {
                            setState(() {
                              _unlimtedRedemption = value;
                              _show = value;
                            });
                          },
                        ),
                        if (!_show)
                          TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "Redemption limit",
                              hintText:
                                  "enter the maximum number of times the coupon can be redeemed",
                              border: OutlineInputBorder(),
                            ),
                            minLines: 1,
                            onFieldSubmitted: (value) {
                              _redemptionLimit = int.tryParse(value);
                            },
                            validator: (String value) {
                              if (!isLength(value, 1)) {
                                return 'Enter a value';
                              }

                              var c = int.parse(value);
                              if (c <= 0) {
                                return "number must be greather than 0";
                              }
                              return null;
                            },
                          ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: _buttonColor,
                              // padding: EdgeInsets.all(0),
                            ),
                            child: Text("Create Coupon"),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                _focusNode.unfocus();
                                _submitForm();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
