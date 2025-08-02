import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:save_money/assets/lang/language.dart';
import 'package:save_money/assets/theme/theme_managar.dart';

class AppDrawerWidget extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String avatarUrl;
  final String appVersion;
  final VoidCallback onLogout;

  const AppDrawerWidget({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.avatarUrl,
    required this.appVersion,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final FlutterLocalization localization = FlutterLocalization.instance;
    final String currentLanguageCode = localization.currentLocale?.languageCode ?? 'en';
    final ThemeManager themeManager = ThemeManager.instance;

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            accountName: Text(
              userName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            accountEmail: Text(
              userEmail,
              style: const TextStyle(fontSize: 14),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage:
                  avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
              child: avatarUrl.isEmpty
                  ? Text(
                      userName.isNotEmpty ? userName[0].toUpperCase() : '?',
                      style: const TextStyle(fontSize: 40),
                    )
                  : null,
            ),
          ),

          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ExpansionTile(
                  leading: Icon(Icons.color_lens,
                      color: Theme.of(context).colorScheme.primary),
                  title: Text(AppLocale.themeColor.getString(context)),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Text(
                        AppLocale.selectColor.getString(context),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: List.generate(
                          themeManager.colorOptions.length,
                          (index) => _ColorCircle(
                            color: themeManager.colorOptions[index].color,
                            isSelected: themeManager.currentColorIndex == index,
                            onTap: () {
                              themeManager.changeColor(index);
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                ExpansionTile(
                  leading: Icon(Icons.language,
                      color: Theme.of(context).colorScheme.primary),
                  title: Text(AppLocale.language.getString(context)), 
                  children: [
                    RadioListTile<String>(
                      title: const Text('English'),
                      value: 'en',
                      groupValue: currentLanguageCode,
                      onChanged: (value) {
                        if (value != null) {
                          localization.translate(value);
                          Navigator.pop(context);
                        }
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('Tiếng Việt'),
                      value: 'vn',
                      groupValue: currentLanguageCode,
                      onChanged: (value) {
                        if (value != null) {
                          localization.translate(value);
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ],
                ),
                
                const Divider(),
                
                ListTile(
                  leading: Icon(Icons.logout,
                      color: Theme.of(context).colorScheme.primary),
                  title: Text(AppLocale.logout.getString(context)),
                  onTap: () {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(AppLocale.confirmation.getString(context)),
                        content: Text(AppLocale.logoutConfirmation.getString(context)),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(AppLocale.cancel.getString(context)),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              onLogout();
                            },
                            child: Text(AppLocale.logout.getString(context)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // App version at the bottom
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              '${AppLocale.version.getString(context)} $appVersion',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ColorCircle extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _ColorCircle({
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.white : Colors.transparent,
            width: 3,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: color.withValues(alpha: 0.6),
                blurRadius: 8,
                spreadRadius: 2,
              ),
          ],
        ),
      ),
    );
  }
}