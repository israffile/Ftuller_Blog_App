import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  final List<Map<String, String>> notifications = [
    {
      'message': 'Your schedule has been booked on January 27th, 2023.',
      'id': 'CO8006.987.432',
      'time': '09:32 am',
    },
    {
      'message': 'Someone has made payment for your care request on January 25th, 2023.',
      'id': 'CO8177.981.883',
      'time': '09:32 am',
    },
    {
      'message': 'Your schedule has been booked on January 27th, 2023.',
      'id': 'CO8006.987.432',
      'time': '09:32 am',
    },
    {
      'message': 'Your schedule has been booked on January 27th, 2023.',
      'id': 'CO8006.987.432',
      'time': '09:32 am',
    },
    {
      'message': 'Someone has made payment for your care request from January 25th, 2023.',
      'id': 'CO8157.987.006',
      'time': '09:32 am',
    },
    {
      'message': 'Someone has made payment for your care request from January 25th, 2023.',
      'id': 'CO8009.987.463',
      'time': '09:32 am',
    },
  ];

  NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return ListTile(
            leading: const Icon(Icons.notifications),
            title: Text(notification['message']!),
            subtitle: Text('Care request id: ${notification['id']}\n${notification['time']}'),
          );
        },
      ),
    );
  }
}
