CREATE TABLE IF NOT EXISTS users(
  id serial PRIMARY KEY,
  email text NOT NULL UNIQUE,
  password_hash text NOT NULL
);