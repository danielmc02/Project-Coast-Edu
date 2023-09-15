-- Ensure the "uuid-ossp" extension is available
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create the users table with UUID primary key
CREATE TABLE IF NOT EXISTS users (
   id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
   email VARCHAR(64) NOT NULL UNIQUE,
   password_hash text NOT NULL,
   salt text NOT NULL

);


CREATE TABLE IF NOT EXISTS public_users
(
   id uuid PRIMARY KEY NOT NULL,
   name VARCHAR(20) NOT NULL,
   interests json NOT NULL,
   verified_student BOOLEAN DEFAULT false,
   friends json,
   CONSTRAINT fk_id
      FOREIGN KEY (id)
      REFERENCES users(id)
);