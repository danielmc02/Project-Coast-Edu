-- Ensure the "uuid-ossp" extension is available
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create the users table with UUID primary key
CREATE TABLE IF NOT EXISTS users (
   id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
   email VARCHAR(64) NOT NULL UNIQUE,
   name VARCHAR(64) ,
   password_hash VARCHAR(64) NOT NULL,
   interests json,
   verified_student bool DEFAULT false
);