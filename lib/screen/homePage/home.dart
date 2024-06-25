import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/language_provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return  Center(
      child: TextButton(onPressed: () {
        context.read<LanguageProvider>().changeLocale(context, const Locale('vi'));
      },
          child: const Text('Change language to Vietnamese')),
    );
  }
}