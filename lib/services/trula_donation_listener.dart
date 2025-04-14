import 'dart:async';
import 'dart:ui';
import 'package:webview_windows/webview_windows.dart';
import 'package:flutter/foundation.dart';

/// Модель доната Trula
class TrulaDonation {
  final String username;
  final int amount;

  TrulaDonation(this.username, this.amount);
}

/// Листенер для Trula Music через WebView
class TrulaDonationListener {
  final String token;
  final void Function(String username, int amount) onDonation;

  final _controller = WebviewController();
  String lastFirstLine = '';
  Timer? _timer;

  final Map<String, DateTime> _recentDonations = {}; // Защита от дублей

  TrulaDonationListener({
    required this.token,
    required this.onDonation,
  });

  /// Инициализация WebView и загрузка страницы
  Future<void> _initWebView() async {
    await _controller.initialize();
    _controller.setBackgroundColor(const Color(0x00ffffff));

    await _controller
        .loadUrl('https://trula-music.ru/obs/notification/?token=$token');

    debugPrint('🌐 WebView загружен Trula-виджет');

    await Future.delayed(const Duration(seconds: 3));
  }

  /// Получение доната из JS через WebView
  Future<TrulaDonation?> fetchLatestDonation() async {
    try {
      const script = '''
        (function() {
          const el = document.querySelector('.notification__text');
          return el ? el.innerText.trim() : '';
        })()
      ''';

      final result = await _controller.executeScript(script);

      if (result == null || result.trim().isEmpty) {
        debugPrint('ℹ️ JS вернул пустую строку');
        return null;
      }

      final text = result.trim();
      debugPrint('🔍 Trula JS innerText: "$text"');

      final firstLine = text.split('\n').first.trim();
      debugPrint('🔔 Trula firstLine: "$firstLine"');

      if (firstLine.isEmpty || firstLine == lastFirstLine) {
        debugPrint('ℹ️ Повторный или пустой донат');
        return null;
      }

      final regex = RegExp(r'(\d+)\s+руб\s+от\s+(.+)', caseSensitive: false);
      final match = regex.firstMatch(firstLine);

      if (match != null && match.groupCount >= 2) {
        final amount = int.tryParse(match.group(1)!) ?? 0;
        final usernameOriginal = match.group(2)!.trim();
        final username = '$usernameOriginal (trula)';

        final key = '$username|$amount';
        final now = DateTime.now();

        if (_recentDonations.containsKey(key)) {
          final lastTime = _recentDonations[key]!;
          final difference = now.difference(lastTime).inSeconds;
          if (difference < 5) {
            debugPrint(
                '⏱️ Донат повторяется менее чем через 5 секунд ($difference сек). Пропускаем.');
            return null;
          }
        }

        // Обновляем время
        _recentDonations[key] = now;

        debugPrint('✅ Trula: $username отправил $amount руб');
        lastFirstLine = firstLine;

        return TrulaDonation(username, amount);
      } else {
        debugPrint('⚠️ Не удалось распарсить: "$firstLine"');
      }
    } catch (e) {
      debugPrint('❌ Ошибка при получении Trula доната через JS: $e');
    }
    return null;
  }

  /// Запуск WebView и прослушивания донатов
  void startListening() async {
    debugPrint('▶️ Trula: Запуск WebView и прослушивания донатов');
    await _initWebView();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) async {
      final donation = await fetchLatestDonation();
      if (donation != null) {
        onDonation(donation.username, donation.amount);
      }
    });
  }

  /// Остановка прослушивания
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
  }
}
