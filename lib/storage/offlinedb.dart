import 'package:cuo_cutter/models/coupon.dart';
import 'package:cuo_cutter/models/store.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String _tableSavedCoupons = "saved_coupons";
final String _tableFollowedStores = "followed_stores";
final String _tableTopCouponCategories = "top_categories";
final String _tableCouponCategories = "coupons_categories";

final String _columnCategoryName = "category";

final String _columnCouponId = "coupon_id";
final String _columnAmountOff = "amount_off";
final String _columnPercentageOff = "percentage_off";
final String _columnId = "id";
final String _columnDesc = 'desc';
final String _columnStoreName = 'store_name';
final String _columnExp = 'exp';
final String _columnImage = 'qrcode';
final String _columnDiscountType = 'discount_type';
final String _columnCurrencyCode = 'currency_code';
final String _columnStoreId = 'store_id';
final String _columnStoreThemeColor = 'store_theme_color';
final String _columnOffer = "offer";
final String _columnTextCouponCode = "text_coupon_code";
final String _columnFollowing = 'following_store';
final String _columnIsTextCoupon = "is_text_coupon";
final String _columnTextCouponUrl = "text_coupon_url";

DiscountType _discountTypeFromString(String value) {
  switch (value) {
    case "voucher":
      return DiscountType.amount_off;
      break;
    case "percentage":
      return DiscountType.percentageOff;
      break;
    default:
      return null;
  }
}

String _discountTypeToString(DiscountType value) {
  switch (value) {
    case DiscountType.percentageOff:
      return "percentage";
      break;
    case DiscountType.amount_off:
      return "voucher";
      break;
    default:
      return null;
  }
}

class _Category {
  String categoryName;
  _Category(this.categoryName);
  Map<String, Object> toMap() {
    var map = <String, Object>{
      _columnCategoryName: this.categoryName,
    };
    return map;
  }

  _Category.fromMap(Map<String, Object> map) {
    this.categoryName = map[_columnCategoryName];
  }
}

class _FollowedStores {
  Store store;
  _FollowedStores(this.store);
  Map<String, Object> toMap() {
    var map = <String, Object>{
      _columnStoreId: this.store.storeId,
      _columnStoreThemeColor: this.store.themeColor.value,
      _columnStoreName: this.store.storeName,
      _columnFollowing: this.store.following == true ? 1 : 0,
    };
    return map;
  }

  _FollowedStores.fromMap(Map<String, Object> map) {
    this.store = Store(
      storeId: map[_columnStoreId],
      themeColor: Color(map[_columnStoreThemeColor]),
      following: map[_columnFollowing] == 1,
      storeName: map[_columnStoreName],
    );
  }
}

class _SavedCoupon {
  Coupon coupon;

  _SavedCoupon(this.coupon);

  Map<String, Object> toMap() {
    var map = <String, Object>{
      _columnCouponId: this.coupon.couponId,
      _columnDesc: this.coupon.desc,
      _columnExp: this.coupon.expiringTimeStamp,
      _columnImage: this.coupon.qrCodeUrl,
      _columnAmountOff: this.coupon.amountOff,
      _columnPercentageOff: this.coupon.percentageOff,
      _columnCurrencyCode: coupon.currencyCode,
      _columnTextCouponCode: this.coupon.textCouponCode,
      _columnTextCouponUrl: this.coupon.textCouponUrl,
      _columnIsTextCoupon: this.coupon.isTextCoupon == true ? 1 : 0,
      _columnFollowing: this.coupon.store.following == true ? 1 : 0,
      _columnStoreId: this.coupon.store.storeId,
      _columnStoreName: this.coupon.store.storeName,
      _columnStoreThemeColor: this.coupon.store.themeColor.value,
      _columnDiscountType: _discountTypeToString(this.coupon.discountType),
    };
    return map;
  }

  _SavedCoupon.fromMap(Map<String, Object> map) {
    this.coupon = Coupon(
      couponId: map[_columnCouponId],
      desc: map[_columnDesc],
      store: Store(
        storeName: map[_columnStoreName],
        storeId: map[_columnStoreId],
        following: map[_columnFollowing] == 1,
        themeColor: Color(map[_columnStoreThemeColor]),
      ),
      expiringTimeStamp: map[_columnExp],
      discountType: _discountTypeFromString(map[_columnDiscountType]),
      amountOff: map[_columnAmountOff],
      percentageOff: map[_columnPercentageOff],
      isTextCoupon: map[_columnIsTextCoupon] == 1,
      textCouponCode: map[_columnTextCouponCode],
      textCouponUrl: map[_columnTextCouponUrl],
      currencyCode: map[_columnCurrencyCode],
      qrCodeUrl: map[_columnImage],
    );
  }
}

class OfflineDbProvider {
  Database db;
  Future<void> initDb() async {
    String path = join(await getDatabasesPath(), 'coupon_cutterwdfkxkkkdhk.db');
    try {
      await open(path);
    } catch (e) {
      print("Unable to open database");
    }
  }

  Future open(String path) async {
    db = await openDatabase(path, version: 100,
        onCreate: (Database db, int version) async {
      await db.execute('''create table $_tableFollowedStores(
        $_columnStoreId text primary key,
          $_columnStoreThemeColor integer not null,
          $_columnFollowing integer not null,
        $_columnStoreName text not null);
        ''');
      await db.execute(''' create table $_tableTopCouponCategories(
$_columnId integer primary key autoincrement,
$_columnCategoryName text unique not null
      ); ''');
      await db.execute(''' create table $_tableCouponCategories(
        $_columnId integer primary key autoincrement,
        $_columnCategoryName text unique not null
        ''');
      await db.execute(''' create table $_tableSavedCoupons(
        $_columnId integer primary key autoincrement,
          $_columnCouponId text unique not null,
          $_columnDesc text not null,
          $_columnStoreName text not null,
          $_columnStoreId text not null,
          $_columnFollowing integer not null,
          $_columnStoreThemeColor integer not null,
          $_columnExp integer not null,
          $_columnDiscountType text not null,
          $_columnOffer Real not null,
          $_columnIsTextCoupon integer not null,
          $_columnTextCouponCode text,
          $_columnTextCouponUrl text,
          $_columnImage text ,
          $_columnPercentageOff Real,
          $_columnAmountOff Real,
          $_columnCurrencyCode text);
          ''');
    });
  }

  Future<List<String>> getTopCategories() async {
    List<Map> maps = await db
        .query(_tableTopCouponCategories, columns: [_columnCategoryName]);
    List<String> sc = [];
    for (var map in maps) {
      var c = _Category.fromMap(map);
      sc.add(c.categoryName);
    }
    return sc;
  }

  Future<List<String>> getAllCategories() async {
    List<Map> maps =
        await db.query(_tableCouponCategories, columns: [_columnCategoryName]);
    List<String> sc = [];
    for (var map in maps) {
      var c = _Category.fromMap(map);
      sc.add(c.categoryName);
    }
    return sc;
  }

  Future<void> insertAllTopCategories(List<String> categories) async {
    Batch batch = db.batch();
    batch.delete(_tableTopCouponCategories);
    for (var cat in categories) {
      batch.insert(_tableCouponCategories, _Category(cat).toMap());
    }
    batch.commit(noResult: true, continueOnError: true);
    return;
  }

  Future<void> insertAllCategories(List<String> categories) async {
    Batch batch = db.batch();
    batch.delete(_tableCouponCategories);
    for (var cat in categories) {
      batch.insert(_tableCouponCategories, _Category(cat).toMap());
    }
    batch.commit(noResult: true, continueOnError: true);
    return;
  }

  Future<List<Store>> getAllStores() async {
    List<Map> maps = await db.query(
      _tableFollowedStores,
      columns: [
        _columnStoreId,
        _columnStoreName,
      ],
    );
    List<Store> _stores = [];
    for (var map in maps) {
      try {
        print("ss");
        var s = _FollowedStores.fromMap(map).store;
        print(s);
        print("ass");
      } on DatabaseException catch (e) {
        print(e);
      } catch (e) {
        print(e);
        return Future.error("unable to load following stores");
      }
    }
    return _stores;
  }

  Future<int> deleteStore(String storeid) async {
    return await db.delete(_tableFollowedStores,
        where: '$_columnStoreId = ?', whereArgs: [storeid]);
  }

  Future<int> insertStore(Store store) async {
    try {
      var i =
          await db.insert(_tableFollowedStores, _FollowedStores(store).toMap());
      print("ddd");
      return i;
    } on DatabaseException catch (e) {
      print(e);
      if (e.isUniqueConstraintError()) {
        return Future.value(-1);
      }
    } catch (e) {
      print(e);
    }

    return Future.error("unable to process req");
  }

  Future<int> updateStore(Store store) async {
    return db.update(_tableFollowedStores, _FollowedStores(store).toMap(),
        where: '$_columnStoreId =?', whereArgs: [store.storeId]);
  }

  Future<Coupon> getCoupon(String couponId) async {
    List<Map> maps = await db.query(_tableSavedCoupons,
        columns: [
          _columnCouponId,
          _columnDesc,
          _columnExp,
          _columnImage,
          _columnStoreName
        ],
        where: '$_columnCouponId = ?',
        whereArgs: [couponId],
        orderBy: "rowid");
    if (maps.length > 0) {
      return _SavedCoupon.fromMap(maps.first).coupon;
    }
    return null;
  }

  Future<List<Coupon>> getAllCoupons() async {
    List<Map> maps = await db.query(_tableSavedCoupons,
        columns: [
          _columnId,
          _columnCouponId,
          _columnDesc,
          _columnExp,
          _columnImage,
          _columnStoreId,
          _columnCurrencyCode,
          _columnAmountOff,
          _columnPercentageOff,
          _columnStoreThemeColor,
          _columnStoreName
        ],
        orderBy: "$_columnId");

    List<Coupon> _sc = [];
    for (var map in maps) {
      try {
        var c = _SavedCoupon.fromMap(map).coupon;
        _sc.add(c);
      } catch (e) {
        print(e);
        return Future.error("unable to load saved coupons");
      }
    }
    return _sc;
  }

  Future<int> deleteCoupon(String couponId) async {
    return await db.delete(_tableSavedCoupons,
        where: '$_columnCouponId = ?', whereArgs: [couponId]);
  }

  Future<int> insertCoupon(Coupon coupon) async {
    try {
      var i = await db.insert(_tableSavedCoupons, _SavedCoupon(coupon).toMap());
      return i;
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        return Future.value(-1);
      }
    }

    return Future.error("unable to process req");
  }

  Future<int> updateCoupon(Coupon coupon) async {
    return db.update(_tableSavedCoupons, _SavedCoupon(coupon).toMap(),
        where: '$_columnCouponId =?', whereArgs: [coupon.couponId]);
  }

  Future close() async => db.close();
}
