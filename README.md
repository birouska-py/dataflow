# Objective

The objective of this Proof of Concept (POC) is to implement Change Data Capture (CDC) in PostgreSQL and use Debezium connectors with Kafka to capture changes in database records. These changes are then sent to a data lake (S3) and a MongoDB database. The goal is to demonstrate the seamless integration and data flow from source databases to data lakes and NoSQL databases, ensuring real-time data synchronization and availability.

# Docker Compose Setup for Data Flow Services

This Docker Compose setup includes several services for a data flow pipeline, organized into three main categories: Source, Orchestration, and Sink. These services are configured to work together to provide a comprehensive data streaming and management solution. 

![Solution POC Dataflow](./solution/POC-Dataflow-Solution.png)

## Services

### Source

#### PostgreSQL (Relational Database)

- **Image**: `postgres:${POSTGRES_VERSION}`
- **Container Name**: `postgres-df`
- **Ports**: `5432`

### Orchestration

#### Kafka Broker

- **Image**: `bitnami/kafka:${KAFKA_VERSION}`
- **Container Name**: `kafka-broker-df`
- **Ports**: `9092`

#### Kafka Connect with Debezium

- **Image**: `debezium/connect`
- **Container Name**: `kafka-connect-df`
- **Ports**: `8083`
- **Depends On**: `kafka-broker-df`, `postgres-df`

#### Redpanda Console

- **Image**: `docker.redpanda.com/redpandadata/console:${REDPANDA_VERSION}`
- **Container Name**: `redpanda-console-df`
- **Ports**: `8080`
- **Depends On**:
  - `kafka-broker-df`
  - `kafka-connect-df`

### Sink

#### MinIO (Data Lake)

- **Image**: `minio/minio:${MINIO_VERSION}`
- **Container Name**: `minio-df`
- **Ports**: `9000` (MinIO), `9001` (MinIO Console)

#### MongoDB (NoSQL Database)

- **Image**: `mongo:${MONGODB_VERSION}`
- **Container Name**: `mongodb-df`
- **Ports**: `27017`

#### Mongo Express

- **Image**: `mongo-express:latest`
- **Container Name**: `mongo-express-df`
- **Ports**: `8091`

### API

#### Flask API

- **Path**: `apis/iot-ingestion/dataflow-iot.api.py`
- **Run API**: `python apis/iot-ingestion/dataflow-iot.api.py`
- **Ports**: `5000`
- **Description**: This service runs a Flask API that interacts with the data flow pipeline.
- **Documentation URL**: `http://127.0.0.1:5000/docs`

**The versions of the containers are specified in a `.env` file available in the project.**

## Networks

- **dataflow_network**: A custom bridge network for inter-service communication.

## Access URLs

- **Kafka Broker**: `localhost:9092`
- **PostgreSQL**: `localhost:5432`
  - **User**: `postgres`
  - **Password**: `postgres`
- **Kafka Connect**: `http://localhost:8083`
- **MinIO**:
  - MinIO Console: `http://localhost:9051`
    - **User**: `admin`
    - **Password**: `minioadmin`
  - S3 Endpoint: `http://localhost:9050`
- **Redpanda Console**: `http://localhost:8080`
- **MongoDB**: `localhost:27017`
  - **User**: `root`
  - **Password**: `password`
- **Mongo Express**: `http://localhost:8091`
  - **User**: `admin`
  - **Password**: `pass`
- **Flask API**: `http://127.0.0.1:5000/docs`

## Setup Instructions

### Creating a Python Environment

1. **Create a Python 3.12 Environment**:
   ```bash
   python3.12 -m venv venv
   ```

2. **Activate the Environment**:
   - On macOS/Linux:
     ```bash
     source venv/bin/activate
     ```
   - On Windows:
     ```bash
     venv\Scripts\activate
     ```

3. **Install Requirements**:
   Make sure you have a `requirements.txt` file in your `apis` folder, then run:
   ```bash
   pip install -r apis/requirements.txt
   ```

## Data Flow

1. **Source**: Data is ingested from the PostgreSQL database.
2. **Orchestration**: Kafka serves as the streaming platform, with Schema Registry managing the schemas, and Kafka Connect with Debezium capturing changes from PostgreSQL.
3. **Sink**: Processed data is stored in MinIO (data lake) and MongoDB (NoSQL database), with Mongo Express providing a web-based MongoDB admin interface.
4. **API**: The Flask API serves as an interface for interacting with the data flow, allowing users to perform CRUD operations and access data.

This setup provides a comprehensive data flow pipeline with PostgreSQL as the data source, Kafka for data streaming and orchestration, and MinIO and MongoDB as data sinks, all managed and monitored through various consoles and interfaces.

