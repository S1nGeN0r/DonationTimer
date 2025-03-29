// donation_services.dart

import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Абстрактный класс для всех донат-сервисов
abstract class DonationService {
  final String widgetUrl;
  Function(double amount, String? username)? onDonationReceived;

  DonationService(this.widgetUrl);

  Future<void> connect();
  void dispose();
}

/// Реализация для DonatePay
class DonatePayService extends DonationService {
  WebSocketChannel? _channel;
  late StreamSubscription _subscription;

  DonatePayService(String widgetUrl) : super(widgetUrl);

  @override
  Future<void> connect() async {
    final wsUrl = 'wss://centrifugo.donatepay.ru:43002/connection/websocket';
    _channel = WebSocketChannel.connect(Uri.parse(wsUrl));

    _subscription = _channel!.stream.listen(
      _onMessage,
      onError: (e) => print('[DonatePay] WebSocket error: \$e'),
      onDone: () => print('[DonatePay] WebSocket closed'),
    );
  }

  void _onMessage(dynamic message) {
    try {
      final Map<String, dynamic> jsonData = json.decode(message);
      final event = jsonData['data']?['data'];

      if (event != null && event['amount'] != null) {
        final amount = double.tryParse(event['amount'].toString()) ?? 0;
        final username = event['name']?.toString() ?? 'Anon';
        onDonationReceived?.call(amount, username);
      }
    } catch (e) {
      print('[DonatePay] Ошибка парсинга сообщения: \$e');
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    _channel?.sink.close();
  }
}

/// Заглушка для других сервисов
class StreamlabsService extends DonationService {
  StreamlabsService(String widgetUrl) : super(widgetUrl);

  @override
  Future<void> connect() async {
    // TODO: добавить реализацию
    print('[Streamlabs] Подключение пока не реализовано');
  }

  @override
  void dispose() {
    // TODO: очистить ресурсы
  }
}

class DonationAlertsService extends DonationService {
  DonationAlertsService(String widgetUrl) : super(widgetUrl);

  @override
  Future<void> connect() async {
    // TODO: добавить реализацию
    print('[DonationAlerts] Подключение пока не реализовано');
  }

  @override
  void dispose() {
    // TODO: очистить ресурсы
  }
}

class TipeeeStreamService extends DonationService {
  TipeeeStreamService(String widgetUrl) : super(widgetUrl);

  @override
  Future<void> connect() async {
    // TODO: добавить реализацию
    print('[TipeeeStream] Подключение пока не реализовано');
  }

  @override
  void dispose() {
    // TODO: очистить ресурсы
  }
}

/// Автоопределение сервиса по URL
DonationService? detectDonationService(String url) {
  final uri = Uri.tryParse(url);
  if (uri == null) return null;

  final host = uri.host.toLowerCase();
  if (host.contains('donatepay.ru')) return DonatePayService(url);
  if (host.contains('streamlabs.com')) return StreamlabsService(url);
  if (host.contains('donationalerts.ru')) return DonationAlertsService(url);
  if (host.contains('tipeee')) return TipeeeStreamService(url);

  return null;
}
