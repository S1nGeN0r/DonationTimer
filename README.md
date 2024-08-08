# Таймер для донатона 
![GitHub Downloads (all assets, all releases)](https://img.shields.io/github/downloads/MjKey/DonatonTimer/total) ![GitHub Release](https://img.shields.io/github/v/release/MjKey/DonatonTimer)
 ![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/MjKey/DonatonTimer/Flutter.yml) [![Stars](https://img.shields.io/github/stars/MjKey/DonatonTimer?style=flat&logo=data:image/svg%2bxml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZlcnNpb249IjEiIHdpZHRoPSIxNiIgaGVpZ2h0PSIxNiI+PHBhdGggZD0iTTggLjI1YS43NS43NSAwIDAgMSAuNjczLjQxOGwxLjg4MiAzLjgxNSA0LjIxLjYxMmEuNzUuNzUgMCAwIDEgLjQxNiAxLjI3OWwtMy4wNDYgMi45Ny43MTkgNC4xOTJhLjc1MS43NTEgMCAwIDEtMS4wODguNzkxTDggMTIuMzQ3bC0zLjc2NiAxLjk4YS43NS43NSAwIDAgMS0xLjA4OC0uNzlsLjcyLTQuMTk0TC44MTggNi4zNzRhLjc1Ljc1IDAgMCAxIC40MTYtMS4yOGw0LjIxLS42MTFMNy4zMjcuNjY4QS43NS43NSAwIDAgMSA4IC4yNVoiIGZpbGw9IiNlYWM1NGYiLz48L3N2Zz4=&logoSize=auto&label=Stars&labelColor=666666&color=eac54f)](https://github.com/MjKey/DonatonTimer/)  
**Донатон Таймер** — это приложение для управления таймером, которое интегрируется с донатами DonationAlerts, позволяя отслеживать и управлять временем в зависимости от поступивших донатов.  
Также присутствует **оверлей таймера** для OBS, чтобы ваши зрители видели таймер!
>> Это моя первая разработка приложения на Flutter, до этого писал только на Python, думаю, получилось неплохо, пользуйтесь! 😺
>> 
>> Будет полезно тем, кто хочет себе удобный и функциональный таймер для донатона!

### Инструкция ✬ [RU](https://github.com/MjKey/DonatonTimer/wiki/Настройка-и-использование-%5BRU%5D) | [EN](https://github.com/MjKey/DonatonTimer/wiki/Setting-and-using-%5BEN%5D) (⸝⸝ᵕᴗᵕ⸝⸝)

Read this in other languages: [English](https://github.com/MjKey/DonatonTimer/blob/main/README-EN.md)

## 🎯 Ключевые возможности

- ### Интерфейс программы под Windows

  ![Интерфейс](https://github.com/MjKey/DonatonTimer/blob/main/img/main.gif?raw=true)

  - Есть тёмная тема
  - Удобное управление
  - Пепежка

- **Веб-интерфейс для управления таймером:**
  - Старт/Стоп таймера
  - Изменение времени на таймере

- **Управление таймером с телефона:**
  - Доступ к веб-интерфейсу с мобильных устройств
  - Удобное управление таймером в мобильной версии

- **Интеграция с донатами:**
  - Отображение последних донатов
  - Отображение топ донатеров
  - Автоматичкое прибавление времени от доната
  - Настройка - сколько минут прибавить за 100 рублей.

- **Мини-версия для Док-Панели OBS:**
  - Упрощённый интерфейс для использования в док-панели OBS
 
## 🛠️ Установка и запуск

### Установка релизов

1. **Скачайте установочный файл:**
   - Перейдите в раздел [Releases](https://github.com/MjKey/DonatonTimer/releases) и скачайте последнюю версию `DTimer-Setup.exe`.

2. **Запустите установочный файл:**
   - Дважды щелкните по скачанному файлу `DTimer-Setup.exe` и следуйте инструкциям на экране для установки приложения.
  
### Установка артифактов

1. **Скачайте последний артифакт:**
   - Перейдите в раздел [Actions](https://github.com/MjKey/DonatonTimer/actions) выберите последний удавшийся билд (c галочкой)
   - Снизу будет Artifacts -> Lastest - скачиваем, разархивируем в любую папку.

2. **Запустите таймер**
   - Дважды щелкните по файлу `donat_timer.exe`.
   - Proffit!

## 🚀 Использование

- **Интерфейс и другое:**
  - `http://localhost:8080/timer` для вставки в источник "Бразуер" - таймер собствнно будет отображаться в OBS.
  - Перейдите на `http://localhost:8080/dashboard` для веб-панели управления в бразуере.
  - `http://localhost:8080/mini` для встравивание в док-панель* OBS.
 
  *Для этого в OBS Studio -> Док-панели (D) -> Пользовательские док-панели браузера (C)
  ![Настройка док-панели](https://github.com/MjKey/DonatonTimer/blob/main/img/dockpanel.jpg?raw=true)

## 💬 Вопросы и поддержка

Если у вас есть вопросы или вы столкнулись с проблемами, не стесняйтесь открыть issue на [GitHub](https://github.com/MjKey/DonatonTimer/issues).

## 📝 Лицензия

Этот проект лицензируется под лицензией MIT — см. [LICENSE](LICENSE) для подробностей.

---

### Сборка из исходного кода

1. **Клонируйте репозиторий:**

   ```bash
   git clone https://github.com/MjKey/DonatonTimer.git
   ```

2. **Перейдите в директорию проекта:**

   ```bash
   cd DonatonTimer
   ```

3. **Установите зависимости:**

   ```bash
   flutter pub get
   ```

4. **Соберите проект для Windows:**

   ```bash
   flutter build windows
   ```
   
   **Или запустите для Windows**

   ```bash
   flutter run -d windows
   ```

   # Обратный отчёт для донатона
