import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

class DonatePayDonationListener {
  final String token;
  final void Function(String username, int amount) onDonation;

  Timer? _timer;
  int _lastDonationId = 0;
  final String _prefsKey = 'donatepay_last_id';
  bool _initialized = false;

  DonatePayDonationListener({
    required this.token,
    required this.onDonation,
  });

  void startListening() async {
    LogManager.log(Level.INFO, '🎧 DonatePay API Listener: Запуск');

    await _loadLastId();

    // Первый запуск — не обрабатывать старые донаты, только запомнить последний ID
    if (!_initialized) {
      final uri = Uri.parse(
          'https://donatepay.ru/api/v1/notifications?access_token=$token&type=donation&limit=1');
      try {
        final response = await http.get(uri);
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['status'] == 'success' &&
              data['data'] is List &&
              data['data'].isNotEmpty) {
            _lastDonationId = data['data'][0]['id'];
            await _saveLastId();
            LogManager.log(Level.INFO,
                '⏳ Первый запуск — пропущен донат ID $_lastDonationId, только инициализация');
          }
        }
      } catch (e) {
        LogManager.log(
            Level.SEVERE, '❌ Ошибка при первом получении доната: $e');
      }
      _initialized = true;
      return startListening();
    }

    _timer = Timer.periodic(const Duration(seconds: 10), (_) async {
      final uri = Uri.parse(
          'https://donatepay.ru/api/v1/notifications?access_token=$token&type=donation&limit=10');

      try {
        final response = await http.get(uri);
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['status'] == 'success' && data['data'] is List) {
            List donations = data['data'];
            for (final d in donations.reversed) {
              int id = d['id'];
              if (id > _lastDonationId) {
                _lastDonationId = id;
                await _saveLastId();

                final vars = d['vars'];
                final name = (vars['name'] ?? 'Без имени').toString();
                final amount = int.tryParse(vars['sum'].toString()) ?? 0;

                LogManager.log(Level.INFO,
                    '💰 Новый донат от $name (donatepay) на сумму $amount руб (ID: $id)');
                onDonation('$name (donatepay)', amount);
              }
            }
          } else {
            LogManager.log(Level.WARNING,
                '⚠️ Некорректный формат данных от API DonatePay');
          }
        } else {
          LogManager.log(Level.WARNING,
              '❌ DonatePay API ошибка ${response.statusCode}: ${response.body}');
        }
      } catch (e) {
        LogManager.log(Level.SEVERE, '❌ Исключение в DonatePay API: $e');
      }
    });
  }

  Future<void> _loadLastId() async {
    final prefs = await SharedPreferences.getInstance();
    _lastDonationId = prefs.getInt(_prefsKey) ?? 0;
    LogManager.log(
        Level.INFO, '🔄 Загружен последний ID доната: $_lastDonationId');
  }

  Future<void> _saveLastId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefsKey, _lastDonationId);
    LogManager.log(
        Level.INFO, '💾 Сохранён последний ID доната: $_lastDonationId');
  }

  void dispose() {
    _timer?.cancel();
    LogManager.log(Level.INFO, '📴 DonatePay API Listener остановлен');
  }
}
