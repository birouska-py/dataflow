import psycopg2
import time

def insert_records(duration_seconds):
    try:
        # Conexão com o banco de dados PostgreSQL
        connection = psycopg2.connect(
            host="localhost",
            database="dvdrental",
            user="postgres",
            password="postgres"
        )
        cursor = connection.cursor()

        # Preparando a query de inserção
        insert_query = """
        INSERT INTO public.actor
        (actor_id, first_name, last_name, last_update)
        VALUES(nextval('actor_actor_id_seq'::regclass), %s, %s, now());
        """

        # Dados de teste
        first_name = "John"
        last_name = "Doe"

        # Marcador de tempo inicial
        start_time = time.time()
        elapsed_time = 0
        count = 0

        # Inserindo registros continuamente até que a duração seja alcançada
        while elapsed_time < duration_seconds:
            cursor.execute(insert_query, (first_name, last_name))
            count += 1

            # Atualizando o marcador de tempo final
            elapsed_time = time.time() - start_time

        # Commit das transações
        connection.commit()

        print(f"Inseridos {count} registros em {elapsed_time:.2f} segundos.")

    except (Exception, psycopg2.Error) as error:
        print("Erro ao conectar ou executar a inserção no PostgreSQL:", error)
    finally:
        # Fechando a conexão
        if connection:
            cursor.close()
            connection.close()
            print("Conexão com PostgreSQL fechada.")

if __name__ == "__main__":
    # Defina a duração do teste em segundos (3 minutos = 180 segundos)
    duration_seconds = 180
    insert_records(duration_seconds)
