# ToDoListOson

Тестовое задание iOS: загрузка списка Todos из API, кэширование в Core Data, пагинация, поиск и экран деталей.

## 📱 Технологии
- UIKit (programmatic UI)
- Core Data (кэширование / оффлайн режим)
- URLSession (сетевые запросы)
- Архитектура MVC

## 🚀 Функциональность
- **Загрузка данных из API**  
  - Todos: [https://jsonplaceholder.typicode.com/todos](https://jsonplaceholder.typicode.com/todos)  
  - Users: [https://jsonplaceholder.typicode.com/users](https://jsonplaceholder.typicode.com/users)
- **Объединение данных**  
  - Для каждого Todo добавляется имя и email пользователя.
- **TableView**  
  - В ячейке отображается `title` и `userName`.  
  - Если задача выполнена → показывается ✅ checkmark.
- **Экран деталей**  
  - При выборе ячейки открывается экран деталей с информацией: `title`, `userName`, `email`, `completed`.
- **Пагинация**  
  - Локальная пагинация (по 20 элементов).  
  - При прокрутке вниз подгружается следующая страница.
- **Поиск (SearchBar)**  
  - Фильтрация задач по `title` или `userName`.  
  - Работает вместе с пагинацией.
- **Кэширование (Offline)**  
  - При наличии интернета → данные берутся из API и сохраняются в Core Data.  
  - При отсутствии интернета → отображаются данные из Core Data.

## 📂 Архитектура проекта
- `HomeVC` – главный экран со списком (table view, поиск, пагинация, переход на детали).  
- `DetailVC` – экран с информацией по одной задаче.  
- `CoreDataManager` – работа с Core Data (сохранение, получение, удаление).  
- `ToDoListItem` – сущность Core Data.  
- `ToDoService` – сервис для загрузки Todos и Users из API.

## 🛠 Установка
1. Клонировать репозиторий:
   ```bash
   git clone https://github.com/<username>/ToDoListOson.git

