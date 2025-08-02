import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:save_money/assets/file_manager.dart';
import 'package:save_money/assets/lang/language.dart';
import 'package:save_money/screens/loading_screen.dart';
import 'package:save_money/screens/smart_saving_screen.dart';
import 'package:save_money/utils/datetime_helper.dart';
import 'package:save_money/widgets/app_drawer_widget.dart';
import 'package:save_money/widgets/card_home_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String userDisplayName = '';
  String userEmail = '';
  String userAvatar = '';
  String version = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    final displayName = await getLoginData('user_display_name');
    final email = await getLoginData('user_email');
    final avatar = await getLoginData('user_avatar');
    final info = await PackageInfo.fromPlatform();
    setState(() {
      userDisplayName = displayName;
      userEmail = email;
      userAvatar = avatar;
      version = info.version;
      isLoading = false;
    });
  }

  Future<String> getLoginData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final result = prefs.getString(key) ?? "";
    return result;
  }

  Future<void> clearLoginData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_email');
    await prefs.remove('user_display_name');
    await prefs.remove('user_avatar');
    await prefs.remove('user_access_token');
    await prefs.remove('user_id_google');
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void backToLogin() {
    Navigator.pop(context);
  }

  Future<void> _handleLogout() async {
    try {
      await clearLoginData();
      backToLogin();
    } catch (error) {
      debugPrint("❌ Logout failed: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const LoadingScreen()
        : Scaffold(
          key: _scaffoldKey,
          drawer: AppDrawerWidget(
            userName: userDisplayName,
            userEmail: userEmail,
            avatarUrl: userAvatar,
            appVersion: version,
            onLogout: _handleLogout,
          ),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                GestureDetector(
                  onTap: _openDrawer,
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.5),
                        child:
                            userAvatar.isEmpty
                                ? Padding(
                                  padding: const EdgeInsets.all(6),
                                  child: imagePicture(defaultAvatar),
                                )
                                : ClipOval(
                                  child: Image.network(
                                    userAvatar,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text.rich(
                              TextSpan(
                                text: '${AppLocale.hello.getString(context)}, ',
                                children: [
                                  TextSpan(
                                    text:
                                        userDisplayName.isEmpty
                                            ? 'N/A'
                                            : userDisplayName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            Text(
                              convertDate(
                                DateTime.now(),
                                format: AppLocale.formatDate.getString(context),
                              ),
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                AspectRatio(
                  aspectRatio: 1.6,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: svgPicture(bannerHome),
                  ),
                ),
                CardHomeWidget(
                  picture: imagePicture(saveMoneyIcon),
                  heading: AppLocale.smartSavingHeading.getString(context),
                  content: AppLocale.smartSavingContent.getString(context),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SmartSavingScreen(),
                      ),
                    );
                  },
                ),
                CardHomeWidget(
                  picture: imagePicture(investWiselyIcon),
                  heading: AppLocale.investWiselyHeading.getString(context),
                  content: AppLocale.investWiselyContent.getString(context),
                  onTap: () {},
                ),
                CardHomeWidget(
                  picture: imagePicture(trackExpensesIcon),
                  heading: AppLocale.trackExpensesHeading.getString(context),
                  content: AppLocale.trackExpensesContent.getString(context),
                  onTap: () {},
                ),
                CardHomeWidget(
                  picture: imagePicture(manageIncomeIcon),
                  heading: AppLocale.manageIncomeHeading.getString(context),
                  content: AppLocale.manageIncomeContent.getString(context),
                  onTap: () {},
                ),
              ],
            ),
          ),
        );
  }
}
