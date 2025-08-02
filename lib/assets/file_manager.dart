import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

const String bannerHome = 'lib/assets/image/banner_home.svg';
const String saveMoneyIcon = 'lib/assets/image/save_money_icon.png';
const String investWiselyIcon = 'lib/assets/image/invest_wisely_icon.png';
const String trackExpensesIcon = 'lib/assets/image/track_expenses_icon.png';
const String manageIncomeIcon = 'lib/assets/image/manage_income_icon.png';
const String defaultAvatar = 'lib/assets/image/default_avatar.png';
const String backAccount = 'lib/assets/image/bank_account.png';
const String careerPromotion = 'lib/assets/image/career_promotion.png';
const String bidv = 'lib/assets/image/bidv.png';
const String mb = 'lib/assets/image/mb.png';
const String momo = 'lib/assets/image/momo.png';
const String tikop = 'lib/assets/image/tikop.png';
const String google = 'lib/assets/image/google.png';
const String appLogo = 'lib/assets/image/app_logo.png';

Widget svgPicture(String name) => SvgPicture.asset(
      name,
      semanticsLabel: 'SVG IMAGE',
    );

Widget imagePicture(String name) => Image.asset(name);
