# Epic: Statistics

## Технические требования
- Архитектура: MVVM
- Верстка: SwiftUI
- iOS: 17.0+
- Сеть и многопоточность: async/await (Swift Concurrency)

 Декомпозиция на 3 равные части

1/3 — UI Statistics + базовая навигация
Цель: сверстать экран статистики и экран пользователя по макету, добавить сортировку, настроить переходы.
Задачи:
Добавить вкладку Statistics в TabBar
Estimate: 0.5h
Actual: 1 h
StatisticsView: список пользователей (UI)
Estimate: 1.5h
Actual: 2.5h
Сортировка (UI + логика сортировки на мок-данных)
Estimate: 1.0h
Actual: 1.5h
Навигация: переход на экран UserCard
Estimate: 0.5h
Actual: 1h 
UserCardView: верстка (заглушки текста/данных)
Estimate: 1.0h
Actual: 2 h
Коллекция NFT (UI строки/переход-заглушка)
Estimate: 0.5h
Actual: 1.0h

Итого 1/3: Estimate 6.0h / Actual 8.0h

---

 2/3 — Сеть + модели + состояния загрузки
**Цель:** получать пользователей/данные с API, обрабатывать ошибки и состояния.

Задачи:
1. Добавить сетевой слой для Statistics (requests, endpoints)
Estimate: 2h
Actual: 
2. StatisticsService: загрузка списка пользователей
Estimate: 2h
Actual: 
4. Состояния UI: loading / error / empty / content
Estimate: 2h
Actual: 
5. Интеграция данных в StatisticsViewModel
Estimate: 1.5h
Actual: 
6. Данные для UserCard (описание, сайт, count)
Estimate: 0.5h
Actual: 

Итого 1/3: Estimate 8.0h / Actual 6.0h

---

 3/3 — Интеграция коллекции + полировка + тестирование
**Цель:** переход в коллекцию, загрузка NFT, финальная интеграция и чистка.

Задачи:
1. Экран коллекции NFT пользователя (UI)
Estimate: 0.5h
Actual: 
2. Сеть: загрузка NFT пользователя
Estimate: 2h
Actual: 
3. Обработка ошибок/лоадеров на коллекции
Estimate: 1h
Actual: 
4. Реальный переход по кнопке “Перейти на сайт пользователя”
Estimate: 1h
Actual: 
5. Рефакторинг, устранение warning’ов, чистка
Estimate: 0.5h
Actual: 
6. Проверка требований и финальные правки по ревью

Итого 1/3: Estimate 5.0h / Actual 
