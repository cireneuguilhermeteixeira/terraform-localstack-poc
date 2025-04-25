from testcontainers.postgres import PostgresContainer
import psycopg2

def test_postgres_connection():
    with PostgresContainer("postgres:15") as postgres:
        conn = psycopg2.connect(
            host=postgres.get_container_host_ip(),
            port=postgres.get_exposed_port(5432),
            user=postgres.USER,
            password=postgres.PASSWORD,
            dbname=postgres.DB
        )
        cursor = conn.cursor()
        cursor.execute("SELECT 1")
        assert cursor.fetchone()[0] == 1