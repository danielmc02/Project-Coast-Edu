-- Ensure the "uuid-ossp" extension is available
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create the users table with UUID primary key
CREATE TABLE IF NOT EXISTS users (
   id uuid PRIMARY KEY DEFAULT uuid_generate_v4() UNIQUE,
   email VARCHAR(64) NOT NULL UNIQUE,
   password_hash text NOT NULL,
   salt text NOT NULL

);


CREATE TABLE IF NOT EXISTS public_users
(
   id uuid PRIMARY KEY NOT NULL UNIQUE,
   name VARCHAR(20) ,
   interests json ,
   verified_student BOOLEAN DEFAULT false,
   friends json,
   CONSTRAINT fk_id
      FOREIGN KEY (id)
      REFERENCES users(id)
);

/*
   Creates a function to be triggered that automatically creates
   a public interface version of private users that is used for
   interfacing with others
*/
CREATE OR REPLACE FUNCTION create_public_user_instance()
   RETURNS TRIGGER
   LANGUAGE plpgsql
AS $$
BEGIN
   INSERT INTO public_users(id)
   VALUES(NEW.id);
   RETURN NEW;
   END;
$$;

/*
   Triggered when a private user is added, their respective
   public account is also created.
*/
CREATE TRIGGER create_public_user_instance
   AFTER INSERT
   ON users
   FOR EACH ROW
   EXECUTE FUNCTION create_public_user_instance();



/*
CREATE OR REPLACE FUNCTION delete_public_private_user_instance()
   RETURNS TRIGGER
   LANGUAGE plpgsql
AS $$
    BEGIN
   DELETE FROM public

   END;
   $$;

CREATE TRIGGER delete_public_private_user_instance
   AFTER DELETE
   ON public_users
   FOR EACH ROW
   EXECUTE FUNCTION delete_public_private_user_instance()
   */