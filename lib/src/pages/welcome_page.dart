import 'dart:async';

import 'package:intl/intl.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gooday/src/widgets/appbar.dart';
import 'package:gooday/src/providers/user_provider.dart';
import 'package:gooday/src/models/notification_model.dart';
import 'package:gooday/src/services/api/notification_service.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({required this.goToPage, super.key});

  final ValueChanged<int> goToPage;

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final double _temperature = 10;
  DateTime _now = DateTime.now();
  final _notificationApi = NotificationApiService();

  Timer? _timer;

  String get _timeLabel {
    return DateFormat('H:mm').format(_now);
  }

  @override
  void initState() {
    _timer = Timer(const Duration(minutes: 1), () {
      setState(() {
        _now = DateTime.now();
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<List<NotificationModel>> _loadNotifications() async {
    final userProvider = context.read<UserProvider>();
    if (userProvider.data == null) return [];

    final userId = userProvider.data!.id!;
    return _notificationApi.getByDate(userId, DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/images/background.png'),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20, top: 10),
            child: AppBarCustom(
              titleCenter: false,
              brightness: Brightness.dark,
              title: Image.asset(width: 80, 'assets/images/logo-white.png'),
              suffix: Text(
                '$_temperature ºC | $_timeLabel',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20, left: 35, right: 35),
            child: Text.rich(
              TextSpan(
                text: 'Bom dia, ',
                children: [
                  TextSpan(
                    text:
                        '${context.watch<UserProvider>().data?.name?.split(' ')[0]}!',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            height: 150,
            child: FutureBuilder(
              future: _loadNotifications(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                }

                return _WelcomeNotificationList(
                  notifications: snapshot.data!,
                  goToPage: widget.goToPage,
                );
              },
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Image.asset('assets/images/betty.png'),
            ),
          )
        ],
      ),
    );
  }
}

class _WelcomeNotificationList extends StatelessWidget {
  const _WelcomeNotificationList({
    required this.notifications,
    required this.goToPage,
  });

  final ValueChanged<int> goToPage;
  final List<NotificationModel> notifications;

  String getTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  String getIconType(NotificationType type) {
    if (type == NotificationType.alert) return 'assets/icons/bell.svg';
    return 'assets/icons/bell.svg';
  }

  String getTypeLabel(NotificationType type) {
    if (type == NotificationType.alert) return 'Lembretes';
    return '---';
  }

  void _openNotification() {
    goToPage(3);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notifications.length,
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      itemBuilder: (context, index) {
        final item = notifications[index];

        return SizedBox(
          width: 270,
          child: Card(
            elevation: 5,
            clipBehavior: Clip.hardEdge,
            margin: const EdgeInsets.all(8),
            color: const Color(0xFF056799),
            child: InkWell(
              onTap: _openNotification,
              splashColor: Colors.white.withAlpha(10),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                        Text(
                          getTime(item.createdAt!),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        )
                      ],
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          item.message,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                width: 20,
                                getIconType(item.type),
                                colorFilter: const ColorFilter.mode(
                                    Colors.white, BlendMode.srcIn),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                getTypeLabel(item.type),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              )
                            ],
                          ),
                          const Icon(
                            Icons.chevron_right,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
