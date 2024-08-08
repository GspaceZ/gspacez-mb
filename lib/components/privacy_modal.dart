import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class PrivacyModal extends StatefulWidget {
  const PrivacyModal({super.key});

  @override
  _PrivacyModalState createState() => _PrivacyModalState();
}

class _PrivacyModalState extends State<PrivacyModal> {
  int? _selectedOption;

  final List<Map<String, dynamic>> privacyOptions = [
    {
      'icon': Icons.public,
      'title': 'post.privacy.public_title',
      'subtitle': 'post.privacy.public_subtitle',
      'value': 0,
    },
    {
      'icon': Icons.people,
      'title': 'post.privacy.friends_title',
      'subtitle': 'post.privacy.friends_subtitle',
      'value': 1,
    },
    {
      'icon': Icons.lock,
      'title': 'post.privacy.private_title',
      'subtitle': 'post.privacy.private_subtitle',
      'value': 2,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // Background color
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.close, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
              Text(
                FlutterI18n.translate(context, 'post.privacy.title'),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  FlutterI18n.translate(context, 'post.privacy.done'),
                  style: const TextStyle(color: Colors.blue, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const Divider(color: Colors.grey),
          Expanded(
            child: ListView(
              children: privacyOptions.map((option) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Icon(option['icon'], color: Colors.black, size: 30,),
                            const SizedBox(width: 20.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    FlutterI18n.translate(context, option['title']),
                                    style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  if (FlutterI18n.translate(context, option['subtitle']).isNotEmpty)
                                    Text(
                                      FlutterI18n.translate(context, option['subtitle']),
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Radio<int>(
                        activeColor: Colors.blue,
                        value: option['value'],
                        groupValue: _selectedOption,
                        onChanged: (int? newValue) {
                          setState(() {
                            _selectedOption = newValue;
                          });
                        },
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
