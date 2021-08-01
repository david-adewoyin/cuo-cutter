import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:cuo_cutter/models/coupon.dart';
import 'package:cuo_cutter/models/store.dart';
import 'package:cuo_cutter/models/user_store.dart';
import 'package:cuo_cutter/storage/offlinedb.dart';
import 'package:cuo_cutter/storage/request.dart';
import 'package:cuo_cutter/storage/response.dart';
import 'package:cuo_cutter/storage/testdata.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Base_Url is the url that the app connects to
const BASE_URL = "";

final base = BaseOptions(
  responseType: ResponseType.plain,
  baseUrl: BASE_URL,
);
final client = Dio();

//Store information to be used for infinite scrolling and pagination
class _CouponKeySet {
  String filterName;
  String lastCouponID;
  int lastCouponTime;
  _CouponKeySet({
    @required this.lastCouponID,
    @required this.lastCouponTime,
    this.filterName,
  });
}

enum StoreCouponActions {
  delete,
  saveToGallery,
//  share,
}
enum SaveCouponActions {
  remove,
  saveToGallery,
}
enum ListingCouponActions {
  saveToGallery,
//  share,
  addToFavourite,
}

class Storage {
  FlutterSecureStorage _secureStorage;
  SharedPreferences _prefs;
  OfflineDbProvider _offlineDbProvider;
  _CouponKeySet _storeCouponKeySet;
  _CouponKeySet _categoryKeySet;
  List<_CouponKeySet> _filterCouponsKeySetList = [];
  List<String> _topCategories = [];
  List<String> _searchCategories = [];

  static final Storage instance = Storage();
  Storage._();

  factory Storage() {
    var storage = Storage._();
    storage._initStorage();
    return storage;
  }
  _initStorage() async {
    _prefs = await SharedPreferences.getInstance();
    _secureStorage = FlutterSecureStorage();
    _offlineDbProvider = OfflineDbProvider();
    await setLastOnlineTime();
    await _offlineDbProvider.initDb();
  }

  //save  access token to encrypted storage
  _saveToken({@required String token}) async {
    _secureStorage.write(key: "token", value: token).catchError((e) {
      return Future.error("unable to write token to storage");
    });
  }

//check if the app instance is new
  Future<bool> isAppFreshInstalled() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      bool value = _prefs.getBool("freshinstall");
      if (value == null) {
        return Future.value(true);
      }
      return Future.value(value);
    } catch (e) {
      return Future.value(false);
    }
  }

  _setDefaultCurrency(String currency) {
    _prefs.setString("default_currency_code", currency);
  }

  String getDefaultCurrency() {
    try {
      var value = _prefs.getString("default_currency_code");
      if (value == null) {
        var format = NumberFormat.simpleCurrency();
        value = format.currencyName;
        return value;
      }
      return value;
    } catch (e) {
      var format = NumberFormat.simpleCurrency();
      var currencyCode = format.currencyName;
      return currencyCode;
    }
  }

  setFreshAppInstall() {
    _prefs.setBool("freshinstall", false);
  }

//returns the access token from the secure storage
  Future<String> _getToken() async {
    String token = await _secureStorage.read(key: "token").catchError((e) {
      throw Future.error("unable to read token");
    });
    return Future.value(token);
  }

  bool isUserLoggedIn() {
    try {
      var value = _prefs.getBool("is_logged_in");
      return value ?? false;
    } catch (e) {
      return false;
    }
  }

  setLastOnlineTime() async {
    await _prefs.setInt(
        "last_online_time", DateTime.now().millisecondsSinceEpoch);
  }

  int lastOnlineTime() {
    try {
      var value = _prefs.getInt("last_online_time");
      return value ?? -1;
    } catch (e) {
      return -1;
    }
  }

  List<String> topCategories() {
    return _topCategories;
  }

  // send a login request to the server
  Future<bool> loginUser(
      {@required String email, @required String password}) async {
    // for debug returns true
    return true;
    try {
      var client = Dio(BaseOptions(
          responseType: ResponseType.plain,
          baseUrl: BASE_URL,
          contentType: Headers.formUrlEncodedContentType));
      var res = await client.post(
        'user/login',
        data: {"email": email, "password": password},
      );
      if (res.statusCode == 200) {
        var json = jsonDecode(res.data);
        String token = json["token"];
        _saveToken(token: token);
        _prefs.setBool("is_logged_in", true);

        return Future.value(true);
      }
    } on DioError catch (e) {
      if (e.response != null) {
        try {
          // if response status == 409 for invalid emaill or password
          Map err = jsonDecode(e.response.data);
          ResponseError res = ResponseError.fromJson(err);
          return Future.error(res.desc);
        } catch (e) {
          return Future.error("Unable to process request");
        }
      } else {
        return Future.error("Unable to process request");
      }
    }
    return Future.error("Unable to process request");
  }

  // fetch initial coupons to display from the server
  Future<List<List<Coupon>>> fetchInitialCoupons() async {
    var list = await Future.wait([
      instance.fetchPopularCoupons(),
      instance.fetchLatestCoupons(),
    ]);
    var cats = instance.fetchTopCategories();
    _topCategories = await cats;
    return [list[0], list[1]];
  }

  Future<List<String>> getCouponsCategories() async {
    try {
      var cats = await _offlineDbProvider.getAllCategories();
      return cats;
    } catch (e) {}
    // returns test data for testing
    return testCategories;

    var client = Dio(BaseOptions(
        responseType: ResponseType.plain,
        baseUrl: BASE_URL,
        contentType: Headers.formUrlEncodedContentType));
    var res =
        await client.get("/coupon/categories", queryParameters: {"limit": 100});
    if (res.statusCode == 200) {
      try {
        var json = jsonDecode(res.data);
        var c = CategoriesResponse.fromJson(json);
        _offlineDbProvider.insertAllCategories(c.categories);
        return c.categories;
      } catch (e) {}
    }
    return [];
  }

  Future<List<String>> fetchTopCategories() async {
    var client = Dio(
      BaseOptions(
          responseType: ResponseType.plain,
          baseUrl: BASE_URL,
          contentType: Headers.formUrlEncodedContentType),
    );
    // returns test data for testing
    return testCategories;
    var res = await client
        .get("/coupon/categories", queryParameters: {"limit": 10, "top": true});
    if (res.statusCode == 200) {
      try {
        var json = jsonDecode(res.data);
        var c = CategoriesResponse.fromJson(json);
        return c.categories;
      } catch (e) {}
    }
    return [];
  }

  Future<List<String>> fetchSearchCategories() async {
    // returns test data for testing
    return testCategories;

    if (_searchCategories.isNotEmpty) {
      return Future.value(_searchCategories);
    }
    var now = DateTime.now();
    if ((now.millisecondsSinceEpoch - lastOnlineTime()) <
        Duration(days: 1).inMilliseconds) {
      try {
        var cat = await _offlineDbProvider.getTopCategories();
        if (cat.isNotEmpty) {
          return cat;
        }
      } catch (e) {}
    } else {
      setLastOnlineTime();
    }
    var client = Dio(BaseOptions(
        responseType: ResponseType.plain,
        baseUrl: BASE_URL,
        contentType: Headers.formUrlEncodedContentType));
    var res = await client.get("/search/categories");
    if (res.statusCode == 200) {
      try {
        var json = jsonDecode(res.data);
        var c = CategoriesResponse.fromJson(json);
        _offlineDbProvider.insertAllTopCategories(c.categories);
        return c.categories;
      } catch (e) {
        Future.error("unable to fetch content");
      }
    }
    return [];
  }

  // returns a list of the latest coupons with the filter applied
  Future<List<Coupon>> filterLatestList(String filter) async {
    // returns test data for testing
    return testCoupons;

    var client = Dio(BaseOptions(
        responseType: ResponseType.plain,
        baseUrl: BASE_URL,
        contentType: Headers.formUrlEncodedContentType));
    var res =
        await client.get("/coupon/latest", queryParameters: {"filter": filter});
    if (res.statusCode == 200) {
      try {
        var json = jsonDecode(res.data);
        var couponList = CouponListResponse.fromJson(json);
        _filterCouponsKeySetList.add(_CouponKeySet(
            lastCouponID: couponList.lastCouponId,
            lastCouponTime: couponList.lastCouponTime,
            filterName: filter));

        return couponList.coupons;
      } catch (e) {
        print(e);
        return Future.error("unable to load filtered coupons");
      }
    }
    return Future.error("unable to load filtered coupons");
  }

// returns a list of the popular coupons with the filter applied
  Future<List<Coupon>> filterPopularList(String filter) async {
    // returns test data for testing
    return testCoupons;
    var client = Dio(BaseOptions(
        responseType: ResponseType.plain,
        baseUrl: BASE_URL,
        contentType: Headers.formUrlEncodedContentType));
    var res = await client
        .get("/coupon/popular", queryParameters: {"filter": filter});
    if (res.statusCode == 200) {
      try {
        var json = jsonDecode(res.data);
        var couponList = CouponListResponse.fromJson(json);
        return couponList.coupons;
      } catch (e) {
        return Future.error("unable to load filtered coupons");
      }
    }
    return Future.error("unable to load filtered coupons");
  }

// returns a list of popular coupons
  Future<List<Coupon>> fetchPopularCoupons() async {
    // returns test data for testing
    return testCoupons;
    try {
      var client = Dio(BaseOptions(
        responseType: ResponseType.plain,
        baseUrl: BASE_URL,
      ));
      var res = await client.get("coupon/popular");

      if (res.statusCode == 200) {
        try {
          var json = jsonDecode(res.data);
          var couponList = CouponListResponse.fromJson(json);
          return (couponList.coupons);
        } catch (e) {
          return Future.error("unable to load popular coupons");
        }
      }
    } catch (e) {
      return Future.error("unable to load popular coupons");
    }
    return Future.error("unable to load popular coupons");
  }

  // returns a list of the latest coupons
  Future<List<Coupon>> fetchLatestCoupons() async {
    // returns test data for testing
    return testCoupons;
    try {
      var client = Dio(BaseOptions(
        responseType: ResponseType.plain,
        baseUrl: BASE_URL,
      ));
      var res = await client.get("coupon/latest");

      if (res.statusCode == 200) {
        try {
          var json = jsonDecode(res.data);
          var couponList = CouponListResponse.fromJson(json);

          var keySet = _filterCouponsKeySetList
              .where((element) => (element.filterName == "all"));
          if (keySet.isEmpty) {
            _filterCouponsKeySetList.add(_CouponKeySet(
                filterName: "all",
                lastCouponID: couponList.lastCouponId,
                lastCouponTime: couponList.lastCouponTime));
          }

          return (couponList.coupons);
        } on MissingRequiredKeysException catch (e) {
          print(e.missingKeys);
          return Future.error("unable to load latest coupons");
        }
      }
    } catch (e) {
      print(e);
      return Future.error("unable to load latest coupons");
    }
    return Future.error("unable to load latest coupons");
  }

  Future<List<Coupon>> fetchLatestCouponsBeforeIDAndTimeFiltered(
      {@required String filter}) async {
    // returns test data for testing
    return testCoupons;
    try {
      var client = Dio(BaseOptions(
        responseType: ResponseType.plain,
        baseUrl: BASE_URL,
      ));

      var keySet = _filterCouponsKeySetList
          .where((element) => (element.filterName == filter));

      var res = await client.get("coupon/latest", queryParameters: {
        "couponid": keySet.isNotEmpty ? keySet.first.lastCouponID : "",
        "lasttime": keySet.isNotEmpty ? keySet.first.lastCouponTime : "",
        //replace all with space for latest coupon
        "filter": filter == "all" ? "" : filter,
      });

      if (res.statusCode == 200) {
        try {
          var json = jsonDecode(res.data);
          var couponList = CouponListResponse.fromJson(json);

          var keySet = _filterCouponsKeySetList
              .where((element) => (element.filterName == filter));
          if (keySet.isEmpty) {
            _filterCouponsKeySetList.add(_CouponKeySet(
                filterName: filter,
                lastCouponID: couponList.lastCouponId,
                lastCouponTime: couponList.lastCouponTime));
          } else {
            keySet.first.lastCouponID = couponList.lastCouponId;
            keySet.first.lastCouponTime = couponList.lastCouponTime;
          }

          return couponList.coupons;
        } catch (e) {
          return Future.error("unable to load more coupon");
        }
      }
      if (res.statusCode == 204) {
        return Future.value([]);
      }
    } catch (e) {
      return Future.error("unable to load more coupon");
    }
    return Future.error("unable to load more coupons");
  }

  Future<Coupon> fetchSingleCoupon(String couponId) async {
    // returns test data for testing
    return testCoupons[0];
    try {
      var client = Dio(BaseOptions(
        responseType: ResponseType.plain,
        baseUrl: BASE_URL,
      ));
      var res = await client.get("coupon/$couponId");

      if (res.statusCode == 200) {
        try {
          var json = jsonDecode(res.data);
          var coupon = SingleCouponResponse.fromJson(json);
          return (coupon.coupon);
        } catch (e) {
          return Future.error("unable to load coupon");
        }
      }
    } catch (e) {
      return Future.error("unable to load coupon");
    }
    return Future.error("unable to load coupon");
  }

  Future<Store> fetchStoreDetails({@required String storeid}) async {
    // returns test data for testing
    return testStores[0];
    try {
      var client = Dio(BaseOptions(
        responseType: ResponseType.plain,
        baseUrl: BASE_URL,
      ));
      var res = await client.get("store/$storeid");

      if (res.statusCode == 200) {
        try {
          var json = jsonDecode(res.data);
          var store = StoreResponse.fromJson(json);

          return (store.store);
        } on MissingRequiredKeysException catch (e) {
          print(e.missingKeys);

          return Future.error("unable to load store details");
        }
      }
    } catch (e) {
      return Future.error("unable to load store details");
    }
    return Future.error("unable to load store details");
  }

  Future<List<Coupon>> fetchStoreCoupons({@required String storeid}) async {
    // returns test data for testing
    return testCoupons;
    try {
      var client = Dio(BaseOptions(
        responseType: ResponseType.plain,
        baseUrl: BASE_URL,
      ));
      var res = await client.get("store/$storeid/coupons");
      if (res.statusCode == 200) {
        try {
          var json = jsonDecode(res.data);
          var c = CouponListResponse.fromJson(json);
          _storeCouponKeySet = _CouponKeySet(
            lastCouponID: c.lastCouponId,
            lastCouponTime: c.lastCouponTime,
          );

          return (c.coupons);
        } on MissingRequiredKeysException catch (e) {
          print(e.missingKeys);

          return Future.error("unable to load store coupons");
        }
      }
    } catch (e) {
      return Future.error("unable to load store coupons");
    }
    return Future.error("unable to load store coupons");
  }

  Future<List<Coupon>> fetchStoreCouponsBeforeIDAndTime(
      {@required String storeid}) async {
    // returns test data for testing
    return testCoupons;
    try {
      var client = Dio(BaseOptions(
        responseType: ResponseType.plain,
        baseUrl: BASE_URL,
      ));

      var res = await client.get("store/$storeid/coupons", queryParameters: {
        "last": _storeCouponKeySet.lastCouponID ?? "",
        "time": _storeCouponKeySet.lastCouponTime ?? "",
      });
      if (res.statusCode == 200) {
        try {
          var json = jsonDecode(res.data);
          var c = CouponListResponse.fromJson(json);
          _storeCouponKeySet = _CouponKeySet(
            lastCouponID: c.lastCouponId,
            lastCouponTime: c.lastCouponTime,
          );

          return (c.coupons);
        } on MissingRequiredKeysException catch (e) {
          print(e.missingKeys);
          return Future.error("unable to load store coupons");
        }
      }
    } catch (e) {
      print(e);
      return Future.error("unable to load store coupons");
    }
    return Future.error("unable to load store coupons");
  }

  Future<Store> fetchUserStore() async {
    // returns test data for testing
    return testStores[0];
    String accessToken;
    try {
      accessToken = await _getToken();
    } catch (e) {
      print(e);
      return Future.error("unable to fetch access token");
    }
    try {
      var client = Dio(BaseOptions(
        headers: {"authorization": "bearer $accessToken"},
        responseType: ResponseType.plain,
        baseUrl: BASE_URL,
      ));
      var res = await client.get("store");
      if (res.statusCode == 200) {
        try {
          var json = jsonDecode(res.data);
          var store = StoreResponse.fromJson(json);

          return (store.store);
        } on MissingRequiredKeysException catch (e) {
          print(e.missingKeys);

          return Future.error("unable to load store details");
        }
      }
    } catch (e) {
      return Future.error("unable to load store details");
    }
    return Future.error("unable to load store details");
  }

  Future<List<Coupon>> fetchUserStoreCoupons({@required String filter}) async {
    String accessToken;
    // returns test data for testing
    return testCoupons;
    try {
      accessToken = await _getToken();
    } catch (e) {
      print(e);
      return Future.error("unable to fetch access token");
    }
    try {
      var client = Dio(BaseOptions(
        headers: {"authorization": "bearer $accessToken"},
        responseType: ResponseType.plain,
        baseUrl: BASE_URL,
      ));

      var res = await client
          .get("store/dashboard/coupons", queryParameters: {"filter": filter});

      if (res.statusCode == 200) {
        try {
          var json = jsonDecode(res.data);
          print(json);
          print("wand");
          var c = UserStoreCouponListResponse.fromJson(json);

          print(c.coupons);
          return (c.coupons);
        } on MissingRequiredKeysException catch (e) {
          print(e.missingKeys);
          return Future.error("unable to load store coupons");
        } catch (e) {
          print(e);
          return Future.error("unable to load store coupons");
        }
      }
    } on DioError catch (e) {
      print(e.response?.data);
      return Future.error("unable to load store coupons");
    }
    return Future.error("unable to load store coupons");
  }

  Future<int> fetchUserStoreCouponRedeemedCount(
      {@required String filter}) async {
    String accessToken;
    // returns test data for testing
    return 30;
    try {
      accessToken = await _getToken();
    } catch (e) {
      print(e);
      return Future.error("unable to fetch access token");
    }
    try {
      var client = Dio(BaseOptions(
        headers: {"authorization": "bearer $accessToken"},
        responseType: ResponseType.plain,
        baseUrl: BASE_URL,
      ));

      var res = await client.get("store/dashboard/coupons/redeemedcount",
          queryParameters: {"filter": filter});

      if (res.statusCode == 200) {
        try {
          var json = jsonDecode(res.data);
          return (json["count"]);
        } on MissingRequiredKeysException catch (e) {
          print(e.missingKeys);
          return Future.error("unable to load store coupons");
        }
      }
    } on DioError catch (e) {
      print(e.response.data);
      return Future.error("unable to load store coupons");
    }
    return Future.error("unable to load store coupons");
  }

  Future<List<Coupon>> fetchCouponsSaved() async {
    // returns test data for testing
    return testCoupons;
    Connectivity connectivity = Connectivity();
    var internetAccess = await connectivity.checkConnectivity();
    switch (internetAccess) {
      case ConnectivityResult.none:
        return Future.value(_offlineDbProvider.getAllCoupons());
      default:
    }

    if (isUserLoggedIn() == false) {
      print("User is not logged in");
      return Future.value(_offlineDbProvider.getAllCoupons());
    }
    String accessToken;
    try {
      accessToken = await _getToken();
    } catch (e) {
      return Future.error("unable to fetch access token");
    }

    var client = Dio(BaseOptions(
        responseType: ResponseType.plain,
        baseUrl: BASE_URL,
        headers: {"authorization": "bearer $accessToken"},
        contentType: Headers.formUrlEncodedContentType));
    var res = await client.get("store/dashboard/coupons/saved");
    if (res.statusCode == 200) {
      try {
        var json = jsonDecode(res.data);
        var _res = CouponListResponse.fromJson(json);

        for (var coupon in _res.coupons) {
          print(coupon.couponId);
          _offlineDbProvider.insertCoupon(coupon);
        }
        return _res.coupons;
      } catch (e) {
        return Future.error("unable to load saved coupons");
      }
    }
    return Future.error("unable to load saved coupons");
  }

  Future<List<Store>> fetchStoresFollowed() async {
    // returns test data for testing
    return testStores;
    Connectivity connectivity = Connectivity();
    var internetAccess = await connectivity.checkConnectivity();
    switch (internetAccess) {
      case ConnectivityResult.none:
        return Future.value(_offlineDbProvider.getAllStores());
      default:
    }
    if (isUserLoggedIn() == false) {
      print("User is not logged in");
      return Future.value(_offlineDbProvider.getAllStores());
    }
    String accessToken;
    try {
      accessToken = await _getToken();
    } catch (e) {
      return Future.error("unable to fetch access token");
    }
    try {
      var client = Dio(BaseOptions(
        headers: {"authorization": "bearer $accessToken"},
        responseType: ResponseType.plain,
        baseUrl: BASE_URL,
      ));

      var res = await client.get("store/dashboard/followed");

      if (res.statusCode == 200) {
        try {
          var json = jsonDecode(res.data);
          var storesList = StoreListResponse.fromJson(json);
          return storesList.stores;
        } on MissingRequiredKeysException catch (e) {
          print(e.missingKeys);
          return Future.error("unable to fetch stores");
        }
      }
    } on DioError catch (e) {
      print("here david");
      print(e);
      return Future.error("unable to fetch stores");
    }
    return Future.error("unable to fetch stores");
  }

  /* Future<List<Store>> fetchSubStores() async {
    String accessToken;
    try {
      accessToken = await _getToken();
    } catch (e) {
      print(e);
      return Future.error("unable to fetch access token");
    }
    try {
      var client = Dio(BaseOptions(
        headers: {"authorization": "bearer $accessToken"},
        responseType: ResponseType.plain,
        baseUrl: BASE_URL,
      ));

      var res = await client.get("store/dashboard/employee");

      if (res.statusCode == 200) {
        try {
          var json = jsonDecode(res.data);
          var storesList = StoreListResponse.fromJson(json);
          return storesList.stores;
        } on MissingRequiredKeysException catch (e) {
          print(e.missingKeys);
          return Future.error("unable fetch sub stores");
        }
      }
    } on DioError catch (e) {
      print(e);
      return Future.error("unable to fetch sub stores");
    }
    return Future.error("unable to fetch sub stores");
  }
 */
  Future<List<Employee>> fetchEmployees() async {
    String accessToken;
    try {
      accessToken = await _getToken();
    } catch (e) {
      print(e);
      return Future.error("unable to fetch access token");
    }
    try {
      var client = Dio(BaseOptions(
        headers: {"authorization": "bearer $accessToken"},
        responseType: ResponseType.plain,
        baseUrl: BASE_URL,
      ));

      var res = await client.get("store/dashboard/employee");

      if (res.statusCode == 200) {
        try {
          var json = jsonDecode(res.data);
          print("david adew frfrrrr \n\n\n");
          var employees = EmployeesListResponse.fromJson(json);
          print("davif \n\n\n\n");
          return employees.employees;
        } on MissingRequiredKeysException catch (e) {
          print(e.missingKeys);
          return Future.error("unable fetch employees");
        }
      }
    } on DioError catch (e) {
      print(e.response.data);
      return Future.error("unable to fetch employees");
    }
    return Future.error("unable to fetch employees");
  }

  Future<void> editStoreChanges(
      {String nameEdit, String taglineEdit, String addressEdit}) async {
    String accessToken;
    try {
      accessToken = await _getToken();
    } catch (e) {
      print(e);
      return Future.error("unable to fetch access token");
    }
    try {
      var client = Dio(BaseOptions(
        headers: {"authorization": "bearer $accessToken"},
        responseType: ResponseType.plain,
        baseUrl: BASE_URL,
      ));

      var payload = EditStorePayload(
          name: nameEdit, tagline: taglineEdit, address: addressEdit);
      var res =
          await client.post("store/dashboard/store", data: payload.toJson());
      if (res.statusCode == 200) {
        return;
      }
    } on DioError catch (e) {
      print(e.response.data);
      return Future.error("unable to change store details");
    }
    return Future.error("unable to change store details");
  }

  Future<List<Coupon>> fetchCategoryCoupons({String categoryName}) async {
    // returns test data for testing
    return testCoupons;
    try {
      var client = Dio(BaseOptions(
        responseType: ResponseType.plain,
        baseUrl: BASE_URL,
      ));

      var res =
          await client.get("category/$categoryName/coupons", queryParameters: {
        "couponid": _categoryKeySet?.lastCouponID ?? "",
        "lasttime": _categoryKeySet?.lastCouponTime ?? "",
      });

      if (res.statusCode == 200) {
        try {
          var json = jsonDecode(res.data);
          var couponList = CouponListResponse.fromJson(json);
          print(json);

          _categoryKeySet = _CouponKeySet(
              lastCouponID: couponList.lastCouponId,
              lastCouponTime: couponList.lastCouponTime);
          return couponList.coupons;
        } catch (e) {
          return Future.error("unable to load more coupon");
        }
      }
      if (res.statusCode == 204) {
        return Future.value([]);
      }
    } catch (e) {
      print(e);
      return Future.error("unable to load more coupon");
    }
    return Future.error("unable to load more coupons");
  }

  Future<void> createStoreCoupon(
      {@required DiscountType discountType,
      @required int expiringDate,
      @required List<String> categories,
      @required bool isTextCoupon,
      @required desc,
      double amountOff,
      double percentageOff,
      //  @required bool singleUserUse,
      @required bool unlimitedRedemption,
      @required String currencyCode,
      String webUrl,
      String textCouponCode,
      int redemptionLimit}) async {
    String accessToken;
    try {
      accessToken = await _getToken();
    } catch (e) {
      print(e);
      return Future.error("unable to fetch access token");
    }
    try {
      var client = Dio(BaseOptions(
        headers: {"authorization": "bearer $accessToken"},
        responseType: ResponseType.plain,
        contentType: "application/json",
        baseUrl: BASE_URL,
      ));

      var payload = CreateCouponPayload(
        percentageOff: percentageOff,
        amountOff: amountOff,
        desc: desc,
        categories: categories,
        currency: currencyCode,
        discountType: discountType,
        expiringDate: expiringDate,

        // singleUserUse: singleUserUse,
        unlimitedRedemption: unlimitedRedemption,
        redemptionLimit: redemptionLimit,
        isTextCoupon: isTextCoupon,
      );

      var res =
          await client.post("store/dashboard/coupon", data: payload.toJson());

      if (res.statusCode == 200) {
        try {
          var json = jsonDecode(res.data);
          print(json);
          return true;
        } on MissingRequiredKeysException catch (e) {
          print(e.missingKeys);
          return Future.error("unable to create coupon");
        }
      }
      _setDefaultCurrency(currencyCode);
    } on DioError catch (e) {
      print(e.response.data);
      return Future.error("unable to create coupon");
    }
    return Future.error("unable to create coupons");
  }

  followStore(Store store) {
    if (isUserLoggedIn() == false) {
      return _offlineDbProvider.insertStore(store);
    }
  }

  unFollowStore(Store store) {
    if (isUserLoggedIn() == false) {
      return _offlineDbProvider.deleteStore(store.storeId);
    }
  }

  Future<void> deleteStoreCoupon(String couponId) async {
    String accessToken;
    try {
      accessToken = await _getToken();
    } catch (e) {
      return Future.error("unable to fetch access token");
    }
    try {
      var client = Dio(BaseOptions(
        headers: {"authorization": "bearer $accessToken"},
        responseType: ResponseType.plain,
        contentType: "application/json",
        baseUrl: BASE_URL,
      ));

      var payload = CouponPayload(
        action: CouponPayloadAction.delete,
        couponId: couponId,
      );

      var res =
          await client.post("store/dashboard/coupon", data: payload.toJson());

      if (res.statusCode == 200) {
        return;
      }
    } on DioError catch (e) {
      print(e.response.data);
      return Future.error("unable to delete coupon");
    }
    return Future.error("unable to delete coupon");
  }

  Future<void> removeSavedCoupon(String couponId) async {
    if (isUserLoggedIn() == false) {
      _offlineDbProvider.deleteCoupon(couponId);
    }
    String accessToken;
    try {
      accessToken = await _getToken();
    } catch (e) {
      try {
        if (isUserLoggedIn() == false) {
          _offlineDbProvider.deleteCoupon(couponId);
          return;
        }
      } catch (e) {
        return Future.error("unable to delete coupon");
      }
    }
    try {
      var client = Dio(BaseOptions(
        headers: {"authorization": "bearer $accessToken"},
        responseType: ResponseType.plain,
        contentType: "application/json",
        baseUrl: BASE_URL,
      ));

      var payload = CouponPayload(
        action: CouponPayloadAction.delete,
        couponId: couponId,
      );

      var res =
          await client.post("store/dashboard/coupon", data: payload.toJson());
      if (res.statusCode == 200) {
        try {
          _offlineDbProvider.deleteCoupon(couponId);
        } catch (e) {}
        return;
      }
    } on DioError catch (e) {
      print(e.response.data);
      return Future.error("unable to delete coupon");
    }
    return Future.error("unable to delete coupon");
  }

  Future<void> storeCouponAction(
      Coupon coupon, StoreCouponActions action) async {
    switch (action) {
      case StoreCouponActions.delete:
        return deleteStoreCoupon(coupon.couponId);

        break;
      case StoreCouponActions.saveToGallery:
        // TODO: Handle this case.
        break;
    }
    return Future.error("unable to process request");
  }

  Future<void> savedCouponAction(Coupon coupon, SaveCouponActions action) {
    switch (action) {
      case SaveCouponActions.remove:
        return removeSavedCoupon(coupon.couponId);
        break;
      case SaveCouponActions.saveToGallery:
        break;
        return Future.error("unable to process request");
    }
  }

  Future<void> couponAction(Coupon coupon, ListingCouponActions action) async {
    switch (action) {
      case ListingCouponActions.addToFavourite:
        if (isUserLoggedIn()) {
          String accessToken;
          try {
            accessToken = await _getToken();
          } catch (e) {
            return Future.error("unable to fetch access token");
          }
          try {
            var client = Dio(BaseOptions(
              headers: {"authorization": "bearer $accessToken"},
              responseType: ResponseType.plain,
              contentType: "application/json",
              baseUrl: BASE_URL,
            ));

            var payload = CouponPayload(
              action: CouponPayloadAction.delete,
              couponId: coupon.couponId,
            );

            var res = await client.post("store/dashboard/coupon",
                data: payload.toJson());

            if (res.statusCode == 200) {
              return;
            }
          } on DioError catch (_) {
            return Future.error("unable to delete coupon");
          }
        }
        try {
          _offlineDbProvider.insertCoupon(coupon);
          return;
        } catch (e) {
          return Future.error("unable to add favourite");
        }

        break;
      case ListingCouponActions.saveToGallery:
        //TODO
        break;
    }
    return Future.error("unable to process request");
  }

  Future<CouponState> checkCouponState({String couponid}) async {
    try {
      var client = Dio(BaseOptions(
        responseType: ResponseType.plain,
        contentType: "application/json",
        baseUrl: BASE_URL,
      ));

      var res = await client.post("store/coupon/$couponid/checkstate");
      if (res.statusCode == 200) {
        var json = jsonDecode(res.data);
        String state = json["state"];
        switch (state) {
          case "active":
            return CouponState.active;
            break;
          case "used":
            return CouponState.used;
            break;
          case "inactive":
            return CouponState.inactive;
            break;
          default:
            return Future.error("valid state not provided");
        }
      }
    } on DioError catch (e) {
      if (e.response.statusCode > 500) {
        return Future.error("unable to check coupon state");
      }
      if (e.response.statusCode > 400 && e.response.statusCode < 500) {
        return Future.error("coupon is not valid");
      }
    }
    return Future.error("unable to check coupon state");
  }

  Future<void> verifyCoupon({String couponid}) async {
    String accessToken;
    try {
      accessToken = await _getToken();
    } catch (e) {
      return Future.error("unable to process request");
    }
    try {
      var client = Dio(BaseOptions(
        responseType: ResponseType.plain,
        headers: {"authorization": "bearer $accessToken"},
        contentType: "application/json",
        baseUrl: BASE_URL,
      ));

      var res = await client.post("store/coupon/$couponid/verify");
      if (res.statusCode == 200) {
        return;
      }
    } on DioError catch (e) {
      if (e.response.statusCode > 500) {
        return Future.error("unable to verify coupon");
      }
      if (e.response.statusCode == 404) {}
      if (e.response.statusCode > 400 && e.response.statusCode < 500) {
        var json = jsonDecode(e.response.data);
        String message = json["message"];
        return Future.error(message);
      }
    }
    return Future.error("unable to check coupon state");
  }

  suspendEmployee({@required String empId}) async {
    String accessToken;
    try {
      accessToken = await _getToken();
    } catch (e) {
      return Future.error("unable to process request");
    }
    try {
      var client = Dio(BaseOptions(
        responseType: ResponseType.plain,
        headers: {"authorization": "bearer $accessToken"},
        contentType: "application/json",
        baseUrl: BASE_URL,
      ));

      var payload =
          EmployeePayload(empId: empId, action: EmployeePayloadAction.suspend);
      var res =
          await client.post("store/dashboard/employee", data: payload.toJson());
      if (res.statusCode == 200) {
        return;
      }
    } on DioError catch (e) {
      if (e.response.statusCode > 500) {
        return Future.error("unable to suspend employee");
      }
      if (e.response.statusCode == 404) {}
      if (e.response.statusCode > 400 && e.response.statusCode < 500) {
        var json = jsonDecode(e.response.data);
        String message = json["message"];
        return Future.error(message);
      }
    }
    return Future.error("unable to suspend employee");
  }

  resumeEmployee({@required String empId}) async {
    String accessToken;
    try {
      accessToken = await _getToken();
    } catch (e) {
      return Future.error("unable to process request");
    }
    try {
      var client = Dio(BaseOptions(
        responseType: ResponseType.plain,
        headers: {"authorization": "bearer $accessToken"},
        contentType: "application/json",
        baseUrl: BASE_URL,
      ));

      var payload =
          EmployeePayload(empId: empId, action: EmployeePayloadAction.resume);
      var res =
          await client.post("store/dashboard/employee", data: payload.toJson());
      if (res.statusCode == 200) {
        return;
      }
    } on DioError catch (e) {
      if (e.response.statusCode > 500) {
        return Future.error("unable to resume employee");
      }
      if (e.response.statusCode > 400 &&
          e.response.statusCode != 400 &&
          e.response.statusCode < 500) {
        var json = jsonDecode(e.response.data);
        String message = json["message"];
        return Future.error(message);
      }
    }
    return Future.error("unable to resume employee");
  }

  removeEmployee({@required String empId}) async {
    String accessToken;
    try {
      accessToken = await _getToken();
    } catch (e) {
      return Future.error("unable to process request");
    }
    try {
      var client = Dio(BaseOptions(
        responseType: ResponseType.plain,
        headers: {"authorization": "bearer $accessToken"},
        contentType: "application/json",
        baseUrl: BASE_URL,
      ));

      var payload =
          EmployeePayload(empId: empId, action: EmployeePayloadAction.remove);
      var res =
          await client.post("store/dashboard/employee", data: payload.toJson());
      if (res.statusCode == 200) {
        return;
      }
    } on DioError catch (e) {
      if (e.response.statusCode > 500) {
        return Future.error("unable to remove employee");
      }
      if (e.response.statusCode == 404) {}
      if (e.response.statusCode > 400 && e.response.statusCode < 500) {
        var json = jsonDecode(e.response.data);
        String message = json["message"];
        return Future.error(message);
      }
    }
    return Future.error("unable to remove employee");
  }

  addEmployee({@required String email}) async {
    String accessToken;
    try {
      accessToken = await _getToken();
    } catch (e) {
      return Future.error("unable to process request");
    }
    try {
      var client = Dio(BaseOptions(
        responseType: ResponseType.plain,
        headers: {"authorization": "bearer $accessToken"},
        contentType: "application/json",
        baseUrl: BASE_URL,
      ));

      var payload =
          EmployeePayload(email: email, action: EmployeePayloadAction.create);
      var res =
          await client.post("store/dashboard/employee", data: payload.toJson());
      if (res.statusCode == 200) {
        return;
      }
    } on DioError catch (e) {
      if (e.response.statusCode > 500) {
        return Future.error("unable to create employee");
      }
      if (e.response.statusCode == 404) {}
      if (e.response.statusCode > 400 && e.response.statusCode < 500) {
        var json = jsonDecode(e.response.data);
        String message = json["message"];
        return Future.error(message);
      }
    }
    return Future.error("unable to create employee");
  }
  //addSubStore(String email) async {}
  //removeSubStore(String id) async {}
  //getSubStores() async {}
}
