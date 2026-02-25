-- Создание полнотекстового индекса
CREATE INDEX idx_documents_title ON documents USING gin(to_tsvector('russian', title));

-- Пример использования индекса для поиска
EXPLAIN ANALYZE SELECT * FROM documents WHERE to_tsvector('russian', title) @@ to_tsquery('russian', 'решение');

-- Заставить использовать индексы
SET enable_seqscan = ON;
