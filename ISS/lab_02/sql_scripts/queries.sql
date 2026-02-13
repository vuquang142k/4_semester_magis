-- Пример запроса: выбрать все документы определенного типа
SELECT * FROM documents WHERE type = 'Приказ';

-- Пример запроса: найти дела по номеру
SELECT * FROM cases WHERE number = 'P34567';

-- Пример запроса: связать данные из разных таблиц
SELECT d.title, e.name, d.date
FROM documents as d
LEFT JOIN entities as e ON d.id = e.document_id;