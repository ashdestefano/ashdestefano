CREATE DATABASE ashdestefano;

CREATE USER arjoyce WITH PASSWORD 'arpass';

ALTER ROLE arjoyce SET client_encoding TO 'utf8';
ALTER ROLE arjoyce SET default_transaction_isolation TO 'read committed';
ALTER ROLE arjoyce SET timezone TO 'UTC';

GRANT ALL PRIVILEGES ON DATABASE ashdestefano TO arjoyce;