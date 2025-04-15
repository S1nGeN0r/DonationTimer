# ⏱️ Donathon Countdown Timer

📘 Available languages: [🇺🇸 English](#english) | [🇷🇺 Русский](#русский)

---

## 🇺🇸 English

Your stream just got a power-up. Every donation = more time on the clock!

### 🍌 Supported Services

| Service         | Status | Comment       |
|-----------------|--------|---------------|
| DonationAlerts  | ✅     | Working       |
| Donate.Stream   | ❌     | In progress   |
| DonatePay       | ✅     | Working       |
| Donatty         | ❌     | Planned       |
| StreamElements  | ❌     | Planned       |
| TRULA MUSIC     | ✅     | Working       |

### ✨ Features

- User-friendly Windows interface  
- Web panel (local + external)  
- OBS timer overlay + mini dock panel  
- Auto time add-on per donation  
- Remote control via external IP

### 🛠️ Installation

No .exe yet — time to flex your dev skills!

```bash
git clone https://github.com/S1nGeN0r/DonationTimer.git
cd DonationTimer
flutter pub get
flutter build windows
flutter run -d windows
```

### 🚀 Usage

- http://localhost:8080/timer — browser source for OBS  
- http://localhost:8080/dashboard — full control panel  
- http://localhost:8080/mini — OBS mini dock

### 🌍 Remote Access

Set up port forwarding (default port is 8080) and access it via your public IP:  
`http://123.45.67.89:8080/dashboard`

Control your stream from literally anywhere. 🌍  
Just stay safe — VPN or password recommended.

### 📚 Wiki
Instructions (EN)

### 📝 License
MIT — use it, tweak it, share it!

---

## 🇷🇺 Русский

> 🎉 Пусть таймер крутится, донаты капают, а стрим оживает!

### 🍌 Поддержка сервисов:

|     Сервис     | Статус |  Комментарий |
|:--------------:|:------:|:------------:|
| DonationAlerts |    ✅   |   Работает   |
| Donate.Stream  |    ❌   |   В процессе |
| DonatePay      |    ✅   |   Работает   |
| Donatty        |    ❌   |   В планах   |
| StreamElements |    ❌   |   В планах   |
| TRULA MUSIC    |    ✅   |   Работает   |

### ✨ Основные фишки:

- Удобный интерфейс (Windows)
- Тёмная тема, пепежка, удобство
- Веб-панель управления (локально и удалённо)
- Таймер для OBS и мини-док
- Интеграция с донатами: авто-прибавка времени
- Удалённое управление через IP

### 🛠️ Установка и запуск

> Пока `.exe` нет — но ты же крутой, справишься!

```bash
git clone https://github.com/S1nGeN0r/DonationTimer.git
cd DonationTimer
flutter pub get
flutter build windows
flutter run -d windows
```

### 🚀 Использование

- http://localhost:8080/timer — таймер в OBS  
- http://localhost:8080/dashboard — панель управления  
- http://localhost:8080/mini — мини-док для OBS

### 🌍 Удалённое управление

Просто настрой проброс порта 8080 на роутере и заходи по своему внешнему IP:  
`http://123.45.67.89:8080/dashboard`

Теперь можно рулить стримом из любой точки мира. 🌍  
Но для безопасности лучше использовать VPN или пароль.

### 📚 Wiki
Инструкция (RU)

### 📝 Лицензия
MIT — бери, кастомизируй, используй!
