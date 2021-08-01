import 'package:cuo_cutter/models/store.dart';
import 'package:cuo_cutter/models/user_store.dart';
import 'package:cuo_cutter/storage/storage.dart';
import 'package:cuo_cutter/theme.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:validators/validators.dart';

class StoreManagementPage extends StatefulWidget {
  final Store store;
  StoreManagementPage({@required this.store});
  @override
  _StoreManagementState createState() => _StoreManagementState();
}

class _StoreManagementState extends State<StoreManagementPage> {
  Future<List<Employee>> _employeeFuture = Storage.instance.fetchEmployees();
  // Future<List<Store>> _subStoresFuture = Storage.instance.fetchSubStores();
  List<Widget> _employeesWidgets = [];
  // List<Widget> _subStoresWidgets = [];
  TextEditingController _storeNameController;
  TextEditingController _storeTaglineController;
  TextEditingController _storeAddressController;

  String nameEdit = "";
  String taglineEdit = "";
  String addressEdit = "";
  TextEditingController _emailController;
  String _activeEdit = "Edit";
  bool _editMode = false;
  @override
  void initState() {
    _storeNameController =
        TextEditingController(text: widget.store?.storeName ?? "Store Name");
    _storeTaglineController =
        TextEditingController(text: widget.store?.tagline ?? "Store Tagline");
    _storeAddressController =
        TextEditingController(text: widget.store?.address ?? "Store Address");
    _emailController = TextEditingController();

    loadSEmployeesData();
    // loadsubStoreData();
    super.initState();
  }

  /*  loadsubStoreData() async {
    try {
      // var stores = await _subStoresFuture;
      //  for (var store in stores) {
      //   _subStoresWidgets.add(buildSubStore(store));
      //  }
    } catch (e) {
      print(e);
      print("the dd");
      Fluttertoast.showToast(
        msg: "Unable to sub stores data",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 3,
        backgroundColor: onErrorColor,
        textColor: Colors.black,
        fontSize: 16.0,
      );
    }
  } */

  loadSEmployeesData() async {
    try {
      var employees = await _employeeFuture;
      print(employees?.length);
      for (var emp in employees) {
        _employeesWidgets.add(buildEmployee(emp));
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Unable to load employees data",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 3,
        backgroundColor: onErrorColor,
        textColor: Colors.black,
        fontSize: 16.0,
      );
    }
  }

  String _emailValidator(String value) {
    if (!isEmail(value)) {
      return "Enter a valid email address";
    }

    return null;
  }

  bool _emailIsValid(String value) {
    return isEmail(value);
  }

  submitForm() async {
    try {
      Storage.instance.editStoreChanges(
          nameEdit: nameEdit,
          taglineEdit: taglineEdit,
          addressEdit: addressEdit);
      _activeEdit = "Edit ";
      _editMode = false;
    } catch (e) {
      ScaffoldMessenger.maybeOf(context).showSnackBar(
        SnackBar(
          content: Text("Unable to change store details,try again later"),
        ),
      );
      return;
    }
  }

  @override
  void dispose() {
    _storeNameController?.dispose();
    _storeTaglineController?.dispose();
    _storeAddressController?.dispose();
    _emailController?.dispose();
    super.dispose();
  }

  addSubStore(String email) {}
  addEmployee(String email) {}

  Widget buildEmployee(Employee employee) {
    return ListTile(
      title: Text(
        employee.fullName,
        style: body1,
      ),
      subtitle: Text("ff ${employee.state}"),
    );
  }

  Widget buildSubStore(Store store) {
    return ListTile(
      title: Text(store.storeName),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SafeArea(
          child: Theme(
            data: Theme.of(context).copyWith(
              accentColor: Colors.white,
              primaryColor: primaryColor,
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(primary: primaryColor),
              ),
            ),
            child: Container(
              padding: EdgeInsets.only(top: 10),
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                children: [
                  Stack(
                    children: [
                      BackButton(
                        color: primaryColor,
                      ),
                      Positioned(
                        right: 0,
                        child: TextButton(
                          onPressed: () {
                            setState(
                              () {
                                if (_editMode) {
                                  submitForm();
                                } else {
                                  _editMode = true;
                                  _activeEdit = "Save";
                                }
                              },
                            );
                          },
                          child: Row(
                            children: [
                              Text(_activeEdit),
                              Icon(
                                _editMode ? Icons.done : Icons.edit,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  /*  Center(
                    child: GestureDetector(
                      onTap: () {
                        if (_editMode) {
                          //TODO pick an image
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.only(bottom: 20),
                        child: !_editMode
                            ? Center(
                                child: widget.store?.image == null
                                    ? Container()
                                    : Container(
                                        width: 120,
                                        height: 80,
                                        color: secondaryColor,
                                      ),
                              )
                            : Container(
                                width: 120,
                                height: 80,
                                alignment: Alignment.bottomRight,
                                color: Colors.grey.withOpacity(0.5),
                                child: Icon(
                                  Icons.image,
                                  size: 38,
                                  color: Colors.black,
                                ),
                              ),
                      ),
                    ),
                  ), */
                  _editMode
                      ? Container(
                          child: TextField(
                            onSubmitted: (value) {
                              nameEdit = value;
                            },
                            textAlign: TextAlign.center,
                            controller: _storeNameController,
                            style: h5,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 10),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                color: Colors.white54,
                                width: 2,
                              )),
                            ),
                          ),
                        )
                      : Text(
                          _storeNameController.text,
                          textAlign: TextAlign.center,
                          style: h5,
                        ),
                  SizedBox(
                    height: 15,
                  ),
                  _editMode
                      ? Container(
                          child: TextField(
                            onSubmitted: (value) {
                              taglineEdit = value;
                            },
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            controller: _storeTaglineController,
                            style:
                                body1.copyWith(fontWeight: FontWeight.normal),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 5),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                color: Colors.white54,
                                width: 1,
                              )),
                            ),
                          ),
                        )
                      : Text(
                          _storeTaglineController.text,
                          textAlign: TextAlign.center,
                          style: body1.copyWith(height: 2),
                        ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.white70,
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        LimitedBox(
                          maxWidth: 300,
                          child: _editMode
                              ? TextField(
                                  onSubmitted: (value) {
                                    addressEdit = value;
                                  },
                                  textAlign: TextAlign.center,
                                  controller: _storeAddressController,
                                  maxLines: 3,
                                  style: body2.copyWith(
                                    color: Colors.white70,
                                  ),
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 5),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                      color: Colors.white54,
                                      width: 1,
                                    )),
                                  ),
                                )
                              : Text(
                                  _storeAddressController.text,
                                  style: body2.copyWith(
                                    color: Colors.white70,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  ExpansionTile(
                    tilePadding: EdgeInsets.all(0),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        "Employees are capable of validating coupons but lack the capability to add other employees, create or view store dashboard.",
                        style: body2.copyWith(
                          color: Colors.white.withAlpha(220),
                        ),
                      ),
                    ),
                    title: Row(
                      children: [
                        Text(
                          "Employees",
                          style: h5,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: backgroundVariant1Color,
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        var email =
                                            _emailController.text.trim();
                                        bool valid = _emailIsValid(email);

                                        if (!valid) {
                                          return;
                                        }

                                        _emailController.clear();
                                        addEmployee(
                                            _emailController.text.trim());
                                        Navigator.maybeOf(context).pop();
                                      },
                                      child: Text(
                                        "Submit",
                                        style: body1.copyWith(
                                          color: primaryColor,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.maybeOf(context).pop();
                                      },
                                      child: Text(
                                        "Cancel",
                                        style: body1.copyWith(
                                            color: Colors.white70),
                                      ),
                                    )
                                  ],
                                  content: TextFormField(
                                    controller: _emailController,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: _emailValidator,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.done,
                                    decoration: InputDecoration(
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                      ),
                                      counterText: "",
                                      prefixIcon: Icon(
                                        Icons.email,
                                        size: 18,
                                      ),
                                      labelText: "Email",
                                      hintText: 'Enter employee email address',
                                    ),
                                  ),
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 20),
                                      Text(
                                        "Enter employee email address",
                                        style: body1,
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        "An email will be sent to this address to be accepted in other to be added as an employee",
                                        style: body1.copyWith(
                                            fontSize: 15.5,
                                            fontWeight: FontWeight.w300),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        )
                      ],
                    ),
                    children: _employeesWidgets,
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
