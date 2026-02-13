CREATE TABLE documents (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255),
    date DATE,
    type VARCHAR(50)
);

CREATE TABLE cases (
    id SERIAL PRIMARY KEY,
    number VARCHAR(50),
    court VARCHAR(255),
    participants TEXT
);

CREATE TABLE entities (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    type VARCHAR(50),
    document_id INTEGER REFERENCES documents(id)
);
