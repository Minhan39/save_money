import 'dart:convert';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:save_money/assets/file_manager.dart';
import 'package:save_money/assets/lang/language.dart';
import 'package:save_money/models/smart_saving_model.dart';
import 'package:save_money/screens/loading_screen.dart';
import 'package:save_money/widgets/card_home_widget.dart';
import 'package:save_money/widgets/card_smart_saving_widget.dart';
import 'package:save_money/widgets/heading_widget.dart';
import 'package:save_money/widgets/status_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SmartSavingScreen extends StatefulWidget {
  const SmartSavingScreen({super.key});

  @override
  State<SmartSavingScreen> createState() => _SmartSavingScreenState();
}

class _SmartSavingScreenState extends State<SmartSavingScreen> {
  final String spreadsheetId = '1PbOqvtbjfB1tw1cvNYZYGWXnmhc0ezQQ9pzGR3P99PA';
  final String range = 'save_money';
  List<SmartSavingModel> savingList = [];
  String accessToken = '';
  String totalAmount = '';
  String goalAmount = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    init().then((value) async {
      await readSheet(accessToken, spreadsheetId, range);
    });
  }

  Future<String> getLoginData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final result = prefs.getString(key) ?? "";
    return result;
  }

  Future<void> readSheet(
      String accessToken, String spreadsheetId, String range) async {
        final Map<String, String>? headers =
        await user.authorizationClient.authorizationHeaders(scopes);
        
    final url =
        'https://sheets.googleapis.com/v4/spreadsheets/$spreadsheetId/values/$range';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<List<String>> list = (data['values'] as List)
          .map<List<String>>(
              (row) => (row as List).map<String>((e) => e.toString()).toList())
          .toList();
      final List<SmartSavingModel> items = list
          .skip(1)
          .map((m) => SmartSavingModel.fromArray(m))
          .where((e) => e.status != 'Đã huỷ')
          .toList();
      items.sort((a, b) => a.source.compareTo(b.source));
      setState(() {
        totalAmount = list[0][11];
        goalAmount = list[0][13];
        savingList = items;
      });
    } else {
      debugPrint('Error reading sheet: ${response.body}');
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const LoadingScreen()
        : Scaffold(
            body: SafeArea(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: HeadingWidget(text: AppLocale.smartSavingHeading.getString(context)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: CardSmartSavingWidget(
                          label: AppLocale.totalAmount.getString(context),
                          value: totalAmount,
                          picture: backAccount,
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          textColor: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CardSmartSavingWidget(
                          label: AppLocale.goalAmount.getString(context),
                          value: goalAmount,
                          picture: careerPromotion,
                          backgroundColor:
                              Theme.of(context).colorScheme.onSurface,
                          textColor: Theme.of(context).colorScheme.surface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  HeadingWidget(text: AppLocale.savingList.getString(context)),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: savingList.length,
                    itemBuilder: (context, index) {
                      final item = savingList[index];
                      return CardHomeWidget(
                        picture: getSource(item.source),
                        heading: item.principalAmount,
                        content:
                            '${item.interestRate} | ${item.interestAmount}\n${item.startDate} to ${item.endDate}',
                        onTap: () {},
                        trailing: StatusWidget(label: getStatus(item.status)),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
  }

  Widget getSource(String source) {
    switch (source) {
      case 'BIDV':
        return imagePicture(bidv);
      case 'MB':
        return imagePicture(mb);
      case 'MOMO':
        return imagePicture(momo);
      case 'TIKOP':
        return imagePicture(tikop);
      default:
        return imagePicture(bidv);
    }
  }

  String getStatus(String status) {
    switch (status) {
      case 'Đang xử lý':
        return AppLocale.pending.getString(context);
      case 'Đã huỷ':
        return AppLocale.cancel.getString(context);
      case 'Hoàn thành':
        return AppLocale.success.getString(context);
      default:
        return AppLocale.pending.getString(context);
    }
  }
}
