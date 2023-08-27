CREATE TABLE IF NOT EXISTS Users(
  id serial PRIMARY KEY,
  email text NOT NULL UNIQUE,
  password_hash text NOT NULL
);