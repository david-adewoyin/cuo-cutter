import 'dart:math';

import 'package:cuo_cutter/models/coupon.dart';
import 'package:cuo_cutter/models/store.dart';
import 'package:cuo_cutter/theme.dart';

List<Coupon> testCoupons = [
  Coupon(
    store: Store(
        storeId: "asdf",
        storeName: "Rive Global Store",
        tagline: "Home of exotic dresses",
        address: "24 Beach view harajuku Tokyo",
        couponCount: 30,
        themeColor: colorList[Random().nextInt(colorList.length)],
        following: false),
    couponId: "1",
    currencyCode: "ngn",
    amountOff: 3000,
    discountType: DiscountType.amount_off,
    expiringTimeStamp: 1617007915,
    desc: 'Get 20% off when you buy 2000 worth of goods and more',
    isTextCoupon: false,
  ),
  Coupon(
    store: Store(
        storeId: "asdf",
        storeName: "Rive Global Store",
        themeColor: colorList[Random().nextInt(colorList.length)],
        tagline: "Home of exotic dresses",
        address: "24 Beach view harajuku Tokyo",
        couponCount: 30,
        following: false),
    couponId: "2",
    amountOff: 5000,
    currencyCode: "usd",
    discountType: DiscountType.amount_off,
    expiringTimeStamp: 1617007915,
    desc: 'Get 20% off when you buy #2000 worth of goods and more',
    isTextCoupon: false,
  ),
  Coupon(
    store: Store(
        themeColor: colorList[Random().nextInt(colorList.length)],
        storeId: "asdf",
        storeName: "Rive Global Store",
        tagline: "Home of exotic dresses",
        address: "24 Beach view harajuku Tokyo",
        couponCount: 30,
        following: false),
    couponId: "3",
    percentageOff: 30,
    currencyCode: "eur",
    discountType: DiscountType.percentageOff,
    expiringTimeStamp: 1617007915,
    desc: 'Get 20% off when you buy #2000 worth of goods and more',
    isTextCoupon: false,
  ),
  Coupon(
    store: Store(
        themeColor: colorList[Random().nextInt(colorList.length)],
        storeId: "asdf",
        storeName: "Rive Global Store",
        tagline: "Home of exotic dresses",
        address: "24 Beach view harajuku Tokyo",
        couponCount: 30,
        following: false),
    couponId: "123433",
    amountOff: 5000,
    percentageOff: 30,
    discountType: DiscountType.percentageOff,
    expiringTimeStamp: 1617007915,
    currencyCode: "yen",
    desc: 'Get 20% off when you buy 2000 worth of goods and more',
    isTextCoupon: false,
  ),
  Coupon(
    store: Store(
        storeId: "asdf",
        storeName: "Rive Global Store",
        themeColor: colorList[Random().nextInt(colorList.length)],
        tagline: "Home of exotic dresses",
        address: "24 Beach view harajuku Tokyo",
        couponCount: 30,
        following: false),
    couponId: "1",
    amountOff: 3000,
    discountType: DiscountType.amount_off,
    expiringTimeStamp: 1617007915,
    desc: 'Get 20% off when you buy #2000 worth of goods and more',
    isTextCoupon: false,
  ),
  Coupon(
    store: Store(
        themeColor: colorList[Random().nextInt(colorList.length)],
        storeId: "asdf",
        storeName: "Rive Global Store",
        tagline: "Home of exotic dresses",
        address: "24 Beach view harajuku Tokyo",
        couponCount: 30,
        following: false),
    couponId: "12354",
    amountOff: 6000,
    discountType: DiscountType.amount_off,
    expiringTimeStamp: 1617007915,
    desc: 'Get 20% off when you buy #2000 worth of goods and more',
    isTextCoupon: false,
  ),
  Coupon(
    store: Store(
        themeColor: colorList[Random().nextInt(colorList.length)],
        storeId: "asdf",
        storeName: "Rive Global Store",
        tagline: "Home of exotic dresses",
        address: "24 Beach view harajuku Tokyo",
        couponCount: 30,
        following: false),
    couponId: "1",
    currencyCode: "usd",
    percentageOff: 50,
    discountType: DiscountType.percentageOff,
    expiringTimeStamp: 1617007915,
    desc: 'Get 20% off when you buy #2000 worth of goods and more',
    isTextCoupon: false,
  ),
  Coupon(
    store: Store(
        storeId: "asdf",
        themeColor: colorList[Random().nextInt(colorList.length)],
        storeName: "Rive Global Store",
        tagline: "Home of exotic dresses",
        address: "24 Beach view harajuku Tokyo",
        couponCount: 30,
        following: false),
    couponId: "2",
    currencyCode: "usd",
    amountOff: 5000,
    discountType: DiscountType.amount_off,
    expiringTimeStamp: 1617007915,
    desc: 'Get 20% off when you buy #2000 worth of goods and more',
    isTextCoupon: false,
  ),
  Coupon(
    store: Store(
        storeId: "asdf",
        themeColor: colorList[Random().nextInt(colorList.length)],
        storeName: "Rive Global Store",
        tagline: "Home of exotic dresses",
        address: "24 Beach view harajuku Tokyo",
        couponCount: 30,
        following: false),
    couponId: "3",
    currencyCode: "usd",
    percentageOff: 30,
    discountType: DiscountType.percentageOff,
    expiringTimeStamp: 1617007915,
    desc: 'Get 20% off when you buy #2000 worth of goods and more',
    isTextCoupon: false,
  ),
  Coupon(
    store: Store(
        storeId: "asdf",
        themeColor: colorList[Random().nextInt(colorList.length)],
        storeName: "Rive Global Store",
        tagline: "Home of exotic dresses",
        address: "24 Beach view harajuku Tokyo",
        couponCount: 30,
        following: false),
    couponId: "123433",
    amountOff: 5000,
    percentageOff: 30,
    currencyCode: "yen",
    discountType: DiscountType.percentageOff,
    expiringTimeStamp: 1617007915,
    desc: 'Get 20% off when you buy #2000 worth of goods and more',
    isTextCoupon: false,
  ),
  Coupon(
    store: Store(
        storeId: "asdf",
        themeColor: colorList[Random().nextInt(colorList.length)],
        storeName: "Rive Global Store",
        tagline: "Home of exotic dresses",
        address: "24 Beach view harajuku Tokyo",
        couponCount: 30,
        following: false),
    couponId: "1",
    currencyCode: "ngn",
    amountOff: 3000,
    discountType: DiscountType.amount_off,
    expiringTimeStamp: 1617007915,
    desc: 'Get 20% off when you buy #2000 worth of goods and more',
    isTextCoupon: false,
  ),
];

List<Store> testStores = [
  Store(
    storeId: "asdf",
    storeName: "Rive Global Store",
    tagline: "Home of exotic dresses",
    address: "24 Beach view harajuku Tokyo",
    couponCount: 30,
    following: false,
  ),
  Store(
    storeId: "asdf",
    storeName: "Rive Global Store",
    tagline: "Home of exotic dresses",
    address: "24 Beach view harajuku Tokyo",
    couponCount: 30,
    following: false,
  ),
  Store(
    storeId: "asdf",
    themeColor: colorList[Random().nextInt(colorList.length)],
    storeName: "Rive Global Store",
    tagline: "Home of exotic dresses",
    address: "24 Beach view harajuku Tokyo",
    couponCount: 30,
    following: false,
  ),
];

List<String> testCategories = [
  "Food",
  "Books",
  "Manga",
  "Restaurant",
  "Clothing",
  "Fashion",
  "Furnitures",
  "Hotels",
];
