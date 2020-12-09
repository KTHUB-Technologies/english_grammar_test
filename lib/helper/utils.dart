import 'dart:collection';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tocviet_customer/constants/constants.dart';
import 'package:tocviet_customer/localization/flutter_localizations.dart';
import 'package:tocviet_customer/res/images/images.dart';
import 'package:tocviet_customer/widget/android_dialog.dart';
import 'package:tocviet_customer/widget/ios_dialog.dart';

/// This method is used when we need to call a method after build() function is completed.
void onWidgetBuildDone(function) {
  SchedulerBinding.instance.addPostFrameCallback((_) {
    function();
  });
}

String capitalizeString(String string) {
  return "${string[0].toUpperCase()}${string.substring(1).toLowerCase()}";
}

double getScreenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double getScreenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

String addCountryCode(String phoneNumber) {
  String phoneNumberWithCountryCode = phoneNumber.replaceFirst('0', '+84', 0);
  return phoneNumberWithCountryCode;
}

String removeCountryCode(String phoneNumber) {
  String phoneNumberWithoutCountryCode;
  if (phoneNumber != null) {
    phoneNumberWithoutCountryCode = phoneNumber.replaceFirst('+84', '0', 0);
  } else {
    phoneNumberWithoutCountryCode = 'Guest';
  }

  return phoneNumberWithoutCountryCode;
}

void hideKeyboard(BuildContext context) {
  FocusScope.of(context).requestFocus(new FocusNode());
}

String formatBirthday(DateTime dateTime) {
  var formatter = DateFormat('dd/MM');
  String formatted = formatter.format(dateTime);
  return formatted;
}

String formatBirthdaySelected(DateTime dateTime) {
  var formatter = DateFormat('yyyyMMdd');
  String formatted = formatter.format(dateTime);
  return formatted;
}

String formatDateToHours(DateTime dateTime) {
  var formatter = DateFormat('H:mm');
  String formatted = formatter.format(dateTime);
  return formatted;
}

String formatDate(DateTime dateTime) {
  var formatter = DateFormat('EEEE, MMM d yyy');
  var formatted = formatter.format(dateTime);
  return formatted;
}

String formatDateForBirthDay(DateTime dateTime) {
  if (dateTime != null) {
    var formatter = DateFormat('yyyyMMdd');
    var formatted = formatter.format(dateTime);
    return formatted;
  } else
    return '0';
}

String formatDateToTimeForBooking(DateTime dateTime) {
  var formatter = DateFormat('dd/MM/yyyy');
  var formatted = formatter.format(dateTime);
  return formatted;
}

String formatDateTimeForHistory(DateTime dateTime) {
  var formatter = DateFormat('H:mm dd/MM/yyyy');
  var formatted = formatter.format(dateTime);
  return formatted;
}

List removeDuplicateElement(List list) {
  List finalList = [];
  var uniqueList = LinkedHashMap<String, bool>();
  for (var i in list) {
    uniqueList[i] = true;
  }
  for (var i in uniqueList.keys) {
    finalList.add(i);
  }
  return finalList;
}

replaceSpaceWithPlus(String raw) {
  var formatted = raw.replaceAll(" ", "+");
  return formatted;
}

convertPrice(num price) {
  var formatted = NumberFormat.simpleCurrency(decimalDigits: 0, locale: 'vi')
      .format(price.round());
  return formatted;
}

String badge(num userPoint) {
  if (userPoint != null) {
    if (userPoint >= Constants.NEW_MEMBER && userPoint < Constants.SILVER) {
      return Images.badge_normal;
    } else if (userPoint >= Constants.SILVER && userPoint < Constants.GOLD) {
      return Images.badge_silver;
    } else if (userPoint >= Constants.GOLD && userPoint < Constants.RUBY) {
      return Images.badge_gold;
    } else if (userPoint >= Constants.RUBY && userPoint < Constants.DIAMOND) {
      return Images.badge_ruby;
    } else if (userPoint >= Constants.DIAMOND) {
      return Images.badge_diamond;
    } else
      return '';
  }else
    return '';
}

String memberClass(num userPoint, context) {
  if (userPoint >= Constants.NEW_MEMBER && userPoint < Constants.SILVER) {
    return FlutterLocalizations.of(context).getString(context, 'new_member');
  } else if (userPoint >= Constants.SILVER && userPoint < Constants.GOLD) {
    return FlutterLocalizations.of(context).getString(context, 'silver_member');
  } else if (userPoint >= Constants.GOLD && userPoint < Constants.RUBY) {
    return FlutterLocalizations.of(context).getString(context, 'gold_member');
  } else if (userPoint >= Constants.RUBY && userPoint < Constants.DIAMOND) {
    return FlutterLocalizations.of(context).getString(context, 'ruby_member');
  } else if (userPoint >= Constants.DIAMOND) {
    return FlutterLocalizations.of(context)
        .getString(context, 'diamond_member');
  } else
    return '';
}

String nextBadge(num userPoint) {
  if (userPoint >= Constants.NEW_MEMBER && userPoint < Constants.SILVER) {
    return Images.badge_silver;
  } else if (userPoint >= Constants.SILVER && userPoint < Constants.GOLD) {
    return Images.badge_gold;
  } else if (userPoint >= Constants.GOLD && userPoint < Constants.RUBY) {
    return Images.badge_ruby;
  } else if (userPoint >= Constants.RUBY && userPoint < Constants.DIAMOND) {
    return Images.badge_diamond;
  } else if (userPoint >= Constants.DIAMOND) {
    return Images.badge_diamond;
  } else
    return null;
}

String nextMemberClass(num userPoint, context) {
  if (userPoint >= Constants.NEW_MEMBER && userPoint < Constants.SILVER) {
    return FlutterLocalizations.of(context).getString(context, 'silver_member');
  } else if (userPoint >= Constants.SILVER && userPoint < Constants.GOLD) {
    return FlutterLocalizations.of(context).getString(context, 'gold_member');
  } else if (userPoint >= Constants.GOLD && userPoint < Constants.RUBY) {
    return FlutterLocalizations.of(context).getString(context, 'ruby_member');
  } else if (userPoint >= Constants.RUBY && userPoint < Constants.DIAMOND) {
    return FlutterLocalizations.of(context)
        .getString(context, 'diamond_member');
  } else if (userPoint >= Constants.DIAMOND) {
    return FlutterLocalizations.of(context)
        .getString(context, 'diamond_member');
  } else
    return '';
}

double classProgress(num userPoint) {
  if (userPoint >= Constants.NEW_MEMBER && userPoint < Constants.SILVER) {
    return (userPoint - Constants.NEW_MEMBER) /
        (Constants.SILVER - Constants.NEW_MEMBER);
  } else if (userPoint >= Constants.SILVER && userPoint < Constants.GOLD) {
    return (userPoint - Constants.SILVER) / (Constants.GOLD - Constants.SILVER);
  } else if (userPoint >= Constants.GOLD && userPoint < Constants.RUBY) {
    return (userPoint - Constants.GOLD) / (Constants.RUBY - Constants.GOLD);
  } else if (userPoint >= Constants.RUBY && userPoint < Constants.DIAMOND) {
    return (userPoint - Constants.RUBY) / (Constants.DIAMOND - Constants.RUBY);
  } else if (userPoint >= Constants.DIAMOND) {
    return 1;
  } else
    return 0;
}

int discountServiceBaseOnClass(num userPoint) {
  if (userPoint >= Constants.NEW_MEMBER && userPoint < Constants.SILVER) {
    return 0;
  } else if (userPoint >= Constants.SILVER && userPoint < Constants.GOLD) {
    return 5;
  } else if (userPoint >= Constants.GOLD && userPoint < Constants.RUBY) {
    return 10;
  } else if (userPoint >= Constants.RUBY && userPoint < Constants.DIAMOND) {
    return 15;
  } else if (userPoint >= Constants.DIAMOND) {
    return 20;
  } else
    return 0;
}

int discountProductBaseOnClass(num userPoint) {
  if (userPoint >= Constants.NEW_MEMBER && userPoint < Constants.SILVER) {
    return 5;
  } else if (userPoint >= Constants.SILVER && userPoint < Constants.GOLD) {
    return 6;
  } else if (userPoint >= Constants.GOLD && userPoint < Constants.RUBY) {
    return 7;
  } else if (userPoint >= Constants.RUBY && userPoint < Constants.DIAMOND) {
    return 10;
  } else if (userPoint >= Constants.DIAMOND) {
    return 15;
  } else
    return 0;
}

int discountBaseOnBirthday(num birthday, num subtotal) {
  if (birthday != 0) {
    var now = DateTime.now();
    var monthOfBirth = int.parse(birthday.toString().substring(4, 6));
    var dateOfBirth = int.parse(birthday.toString().substring(6, 8));
    int difference =
        now.difference(DateTime(now.year, monthOfBirth, dateOfBirth)).inDays;
    int discount;
    if (difference >= 0 && difference < 7) {
      discount = subtotal - ((subtotal * 30) / 100).round();
      return discount;
    } else if (difference >= 7 && difference < 31) {
      discount = discount = subtotal - ((subtotal * 15) / 100).round();
      return discount;
    } else
      return 0;
  } else
    return 0;
}

int discountServiceByBirthday(num birthday) {
  if (birthday != 0) {
    var now = DateTime.now();
    var monthOfBirth = int.parse(birthday.toString().substring(4, 6));
    var dateOfBirth = int.parse(birthday.toString().substring(6, 8));
    int difference =
        now.difference(DateTime(now.year, monthOfBirth, dateOfBirth)).inDays;
    int discount;
    if (difference >= 0 && difference < 7) {
      discount = 30;
      return discount;
    } else if (difference >= 7 && difference < 30) {
      discount = 15;
      return discount;
    } else
      return 0;
  } else
    return 0;
}

int discountProductByBirthday(num birthday) {
  if (birthday != 0) {
    var now = DateTime.now();
    var monthOfBirth = int.parse(birthday.toString().substring(4, 6));
    var dateOfBirth = int.parse(birthday.toString().substring(6, 8));
    int difference =
        now.difference(DateTime(now.year, monthOfBirth, dateOfBirth)).inDays;
    int discount;
    if (difference >= 0 && difference < 7) {
      discount = 20;
      return discount;
    } else if (difference >= 7 && difference < 30) {
      discount = 10;
      return discount;
    } else
      return 0;
  } else
    return 0;
}

String alertBirthday(num birthday, context) {
  if (birthday != 0) {
    var now = DateTime.now();
    var monthOfBirth = int.parse(birthday.toString().substring(4, 6));
    var dateOfBirth = int.parse(birthday.toString().substring(6, 8));
    int difference =
        now.difference(DateTime(now.year, monthOfBirth, dateOfBirth)).inDays;
    String alert;
    if (difference >= 0 && difference < 7) {
      alert = 'Bạn được giảm giá 30% nhân dịp sinh nhật của bạn';
      return alert;
    } else if (difference >= 7 && difference < 31) {
      alert = 'Bạn được giảm giá 15% nhân dịp sinh nhật của bạn';
      return alert;
    } else
      return '';
  } else
    return '';
}

int subTotal(List<num> prices) {
  var subTotal;
  if (prices.isNotEmpty) {
    subTotal = prices.reduce((a, b) => a + b);
    return subTotal;
  } else
    subTotal = 0;
  return subTotal;
}

int rateByStaff(String raw, bool isNewStaff) {
  int rate;
  if (!isNewStaff) {
    rate = int.parse(raw.substring(0, 2));
    return rate;
  } else {
    rate = int.parse(raw.substring(0, 2)) - int.parse(raw.substring(3, 4));
    return rate;
  }
}

String getSalon(int salon, context) {
  String salonName;
  switch (salon) {
    case 1:
      salonName = FlutterLocalizations.of(context)
          .getString(context, 'salon_le_quang_dinh');
      return salonName;
    case 2:
      salonName = FlutterLocalizations.of(context)
          .getString(context, 'salon_hoang_hoa_tham');
      return salonName;
    default:
      salonName = '';
      return salonName;
  }
}

String getPaymentMethod(int payment, context) {
  String paymentMethod;
  switch (payment) {
    case 1:
      paymentMethod =
          FlutterLocalizations.of(context).getString(context, 'pay_cash');

      return paymentMethod;
    case 2:
      paymentMethod =
          FlutterLocalizations.of(context).getString(context, 'wallet');
      return paymentMethod;
    default:
      paymentMethod = '';
      return paymentMethod;
  }
}

String paymentStatus(num paymentStatus, context) {
  switch (paymentStatus) {
    case 1:
      return FlutterLocalizations.of(context).getString(context, 'completed');
    case 2:
      return FlutterLocalizations.of(context)
          .getString(context, 'not_completed');
    case 3:
      return 'Chưa giao hàng';
    case 4:
      return 'Đang giao hàng';
    case 5:
      return 'Hủy đơn hàng';

    default:
      return '';
  }
}

bool isBirthday(bool isRewarded, num birthday) {
  if (birthday != 0) {
    var now = DateTime.now();
    var monthOfBirth = int.parse(birthday.toString().substring(4, 6));
    var dateOfBirth = int.parse(birthday.toString().substring(6, 8));
    int difference =
        now.difference(DateTime(now.year, monthOfBirth, dateOfBirth)).inDays;
    if (difference >= 0 && difference < 31 && isRewarded) {
      return true;
    } else
      return false;
  } else
    return false;
}

int discountByBirthday(num birthday) {
  if (birthday != 0) {
    var now = DateTime.now();
    var monthOfBirth = int.parse(birthday.toString().substring(4, 6));
    var dateOfBirth = int.parse(birthday.toString().substring(6, 8));
    int difference =
        now.difference(DateTime(now.year, monthOfBirth, dateOfBirth)).inDays;
    int discount;
    if (difference >= 0 && difference < 7) {
      discount = 30;
      return discount;
    } else if (difference >= 7 && difference < 31) {
      discount = 15;
      return discount;
    } else
      return 0;
  } else
    return 0;
}

String alertDiscountServiceByClass(num userPoint) {
  if (userPoint >= Constants.NEW_MEMBER && userPoint < Constants.SILVER) {
    return 'Bạn cần lên hạng bạc để nhận được giảm giá';
  } else if (userPoint >= Constants.SILVER && userPoint < Constants.GOLD) {
    return 'Bạn được giảm giá 5% dịch vụ';
  } else if (userPoint >= Constants.GOLD && userPoint < Constants.RUBY) {
    return 'Bạn được giảm giá 10% dịch vụ';
  } else if (userPoint >= Constants.RUBY && userPoint < Constants.DIAMOND) {
    return 'Bạn được giảm giá 15% dịch vụ';
  } else if (userPoint >= Constants.DIAMOND) {
    return 'Bạn được giảm giá 20% dịch vụ';
  } else
    return '';
}

int discountByRate(int subTotal, int discountRate) {
  int discountByRate;
  if (subTotal == 0) {
    discountByRate = 0;
    return discountByRate;
  } else {
    discountByRate = subTotal - ((discountRate * subTotal) / 100).round();
    return discountByRate;
  }
}

showConfirmDialog(BuildContext context,
    {String title, String content, Function cancel, Function confirm}) {
  if (Platform.isIOS) {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return IOSDialog(
            title: title,
            content: content,
            cancel: cancel,
            confirm: () {
              Navigator.pop(context);
              confirm();
            },
          );
        });
  } else {
    showDialog(
        context: context,
        builder: (context) {
          return AndroidDialog(
            title: title,
            content: content,
            cancel: cancel,
            confirm: () {
              Navigator.pop(context);
              confirm();
            },
          );
        });
  }
}

void showDialogAskLogin(BuildContext context) {
  showConfirmDialog(context,
      title: FlutterLocalizations.of(context).getString(context, 'ask_sign_in'),
      content: FlutterLocalizations.of(context)
          .getString(context, 'sign_in_for_more_features'),
      cancel: () => Get.back(),
      confirm: () {
        Get.offNamedUntil('/LoginScreen', (route) => false);
      });
}
