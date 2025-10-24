📖 Descrizione del progetto

Questo progetto dimostrativo utilizza dbt (Data Build Tool) per gestire e storicizzare dati dimensionali di esempio, ispirati al mondo del lusso (Louis Vuitton).
L’obiettivo è mostrare come implementare le logiche di Slowly Changing Dimensions (SCD) di tipo 1 e 3, partendo da sorgenti simulate (file CSV caricati con dbt seed) e trasformandole in modelli di staging e modelli finali.

⚙️ Struttura del progetto
1️⃣ Dati sorgente (/data)

Sono presenti quattro file CSV che rappresentano due use case:

SCD3 – Prodotti di lusso

scd3_products_t0.csv: stato iniziale dei prodotti

scd3_products_t1.csv: stato successivo, con variazioni di prezzo o nuovi prodotti

SCD1 – Negozi Louis Vuitton

scd1_stores_t0.csv: elenco iniziale dei punti vendita

scd1_stores_t1.csv: versione aggiornata con modifiche o aperture

I file sono caricati in Snowflake tramite dbt seed.

2️⃣ File di configurazione (src_luxury.yml)

Il file definisce la source luxury_data, con database e schema dinamici:

database: "{{ target.database }}"
schema: "{{ target.schema }}"


In questo modo il progetto resta portabile tra ambienti diversi (dev, test, prod).

3️⃣ Modelli di staging (/models/staging)

Contengono la logica di confronto tra t0 e t1:

scd1_stores_stg.sql → implementa la SCD1, dove i dati vengono aggiornati senza mantenere lo storico.

scd3_products_stg.sql → implementa la SCD3, dove si mantiene sia il valore corrente che il precedente (es. price_current e price_previous).

4️⃣ Modelli finali (/models/final)

Raccolgono i risultati unificati e pronti per l’analisi, derivati dagli staging.+

5️⃣ dbt Configuration

Il progetto è configurato con:

profile.yml collegato a Snowflake (ruolo dedicato MY_DBT_ROLE)

Warehouse: DBT_PROJECT_WH

Database: DBT_PROJECT_DB

Schema: DBT_PROJECT_SCHEMA

Output finale

Viste:

SCD1_STORES_STG

SCD3_PRODUCTS_STG

Tabelle finali:

FINAL_SCD1_STORES

FINAL_SCD3_PRODUCTS
