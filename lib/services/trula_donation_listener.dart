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
  Timer? _timer;

  String lastFirstLine = '';
  final Map<String, DateTime> _recentDonations = {};

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

  /// Получение доната из JS через WebView с расширенным логированием
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
      debugPrint('🔍 Trula JS innerText:\n$text');

      final firstLine = text.split('\n').first.trim();
      debugPrint('🔔 Trula firstLine: "$firstLine"');
      debugPrint('🧠 Последний учтённый firstLine: "$lastFirstLine"');

      if (firstLine.isEmpty) {
        debugPrint('⚠️ Пропускаем: firstLine пустой');
        return null;
      }

      if (firstLine == lastFirstLine) {
        debugPrint('⚠️ Пропускаем: такой же firstLine как в прошлый раз');
        return null;
      }

      final regex =
          RegExp(r'(\d+(?:\.\d+)?)\s+руб\s+от\s+(.+)', caseSensitive: false);
      final match = regex.firstMatch(firstLine);

      if (match != null && match.groupCount >= 2) {
        final amountStr = match.group(1)!;
        final amount = int.tryParse(amountStr.split('.').first) ?? 0;
        final usernameOriginal = match.group(2)!.trim();
        final username = '$usernameOriginal (trula)';

        final key = '$username|$amount';
        final now = DateTime.now();

        // Очистка старых
        _recentDonations
            .removeWhere((_, dt) => now.difference(dt).inMinutes > 2);

        debugPrint('📦 Текущие донаты в памяти:');
        _recentDonations.forEach((k, v) {
          final ago = now.difference(v).inSeconds;
          debugPrint('  • $k — $ago сек назад');
        });

        if (_recentDonations.containsKey(key)) {
          final lastTime = _recentDonations[key]!;
          final diff = now.difference(lastTime).inSeconds;
          if (diff < 5) {
            debugPrint(
                '⏱️ Донат "$key" повторяется слишком быстро: $diff сек < 5 сек. Пропускаем.');
            return null;
          } else {
            debugPrint(
                '🔁 Донат "$key" пришёл через $diff сек — принимаем повтор.');
          }
        } else {
          debugPrint('🆕 Новый донат "$key" — принимаем.');
        }

        _recentDonations[key] = now;
        lastFirstLine = firstLine;

        debugPrint('✅ Trula: $username отправил $amount руб');

        // Перезагрузка и ожидание очистки
        try {
          await _controller.reload();
          debugPrint('🔄 WebView успешно обновлён (reload)');

          Future.delayed(const Duration(seconds: 2), () async {
            try {
              final check = await _controller.executeScript(script);
              final cleared = check == null || check.trim().isEmpty;
              if (cleared) {
                debugPrint('🧹 Получен пустой текст. Очищаем lastFirstLine.');
                lastFirstLine = '';
              } else {
                debugPrint(
                    '⏳ Повторная проверка: .notification__text всё ещё содержит текст.');
              }
            } catch (e) {
              debugPrint('⚠️ Ошибка при проверке очистки текста: $e');
            }
          });
        } catch (e) {
          debugPrint('⚠️ Ошибка при WebView.reload(): $e');
        }

        return TrulaDonation(username, amount);
      } else {
        debugPrint('❌ Не удалось распарсить строку: "$firstLine"');
      }
    } catch (e) {
      debugPrint('🚨 Исключение в fetchLatestDonation: $e');
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
