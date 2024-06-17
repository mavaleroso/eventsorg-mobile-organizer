import 'package:cached_network_image/cached_network_image.dart';
import 'package:eventsorg_mobile_organizer/view/widgets/my_text.dart';
import 'package:eventsorg_mobile_organizer/view/widgets/my_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:html/parser.dart';

import '../data/my_colors.dart';

class Tools {
  static void setStatusBarColor(Color color) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: color));
  }

  static String allCaps(String str) {
    if (str.isNotEmpty) {
      return str.toUpperCase();
    }
    return str;
  }

  static String convertDateTimeDisplay(String date, String format) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormater = DateFormat(format);
    final DateTime displayDate = displayFormater.parse(date);
    final String formatted = serverFormater.format(displayDate);
    return formatted;
  }

  static String getFormattedDateShort(int time) {
    DateFormat newFormat = DateFormat("MMM dd, yyyy");
    return newFormat.format(DateTime.fromMillisecondsSinceEpoch(time));
  }

  static String getFormattedDateSimple(int time) {
    DateFormat newFormat = DateFormat("MMMM dd, yyyy");
    return newFormat.format(DateTime.fromMillisecondsSinceEpoch(time));
  }

  static String getFormattedDateEvent(int time) {
    DateFormat newFormat = DateFormat("EEE, MMM dd yyyy");
    return newFormat.format(DateTime.fromMillisecondsSinceEpoch(time));
  }

  static String getFormattedTimeEvent(int time) {
    DateFormat newFormat = DateFormat("h:mm a");
    return newFormat.format(DateTime.fromMillisecondsSinceEpoch(time));
  }

  static String getFormattedCardNo(String cardNo) {
    if (cardNo.length < 5) return cardNo;
    return cardNo.replaceAllMapped(
        RegExp(r".{4}"), (match) => "${match.group(0)} ");
  }

  static void directUrl(String link) async {
    Uri uri = Uri.parse(link);
    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {}
  }

  static String parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body!.text).documentElement!.text;
    return parsedString;
  }

  static Widget displayImage(String url) {
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(color: MyColors.grey_20),
      errorWidget: (context, url, error) => Container(color: MyColors.grey_20),
    );
  }

  static String getFormattedDate(String date, bool simple) {
    try {
      DateTime tempDate = DateFormat("yyyy-MM-dd HH:mm:ss").parse(date);
      String format = simple ? "dd MMM yyyy" : "dd MMMM yyyy, hh:mm";
      DateFormat newFormat = DateFormat(format);
      return newFormat.format(tempDate);
    } catch (e) {
      return date;
    }
  }

  static FToast toastEvent(BuildContext context, description) {
    return MyToast.showCustom(
        context,
        Container(
          height: 50,
          decoration: BoxDecoration(
              color: Colors.green[500],
              borderRadius: const BorderRadius.all(Radius.circular(30))),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Icon(Icons.done, color: Colors.white, size: 20),
              Container(width: 10),
              Text("Successfully created!",
                  style:
                      MyText.body1(context)!.copyWith(color: MyColors.grey_5)),
              Container(width: 8),
            ],
          ),
        ));
  }
}
