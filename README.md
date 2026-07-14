# Yemen Educational Platform — PoC: Universities Academic Model

This branch contains an initial PoC scaffold for the Universities academic data model, migrations, seed data and ingestion script.

Contents:
- /migrations: Flyway-style SQL files (V1..V5)
- /seed/seed_sample_universities.json: sample dataset (governorates, cities, sample university)
- /openapi/openapi_universities.yaml: OpenAPI skeleton for admin upsert & search
- /opensearch/opensearch_universities_mapping.json: OpenSearch mapping for universities index
- /scripts/ingest_university_sample.js: Node.js ingestion script (calls admin upsert endpoint and publishes Kafka events)
- /docs/er_diagram.puml: PlantUML ER diagram for the academic model
- README.md: this file

How to use (quick):
1. Start infrastructure: PostgreSQL (13+), Kafka, OpenSearch. For quick dev use a docker-compose or minikube.
2. Run Flyway migrations in /migrations or apply SQL files to your DB.
3. Configure API_BASE and API_TOKEN and run the ingestion script to upsert the sample university.

See README for complete details and next steps.
