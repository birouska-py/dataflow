# 🚀 Guia de Implantação do Projeto Dataflow

Bem-vindo ao guia de implantação do projeto Dataflow! Este documento irá te ajudar a configurar e executar os componentes do sistema usando Docker. Siga os passos abaixo para garantir que tudo funcione perfeitamente! 🎉

## 🧹 Passo 1: Limpar Volumes Anteriores

Antes de começarmos, é importante remover volumes antigos que possam interferir no novo ambiente. Execute o seguinte comando:

```bash
sudo rm -R ~/docker_files/volumes/dataflow
```

## 🐘 Passo 2: Subir o Banco de Dados

Vamos iniciar o banco de dados PostgreSQL! Execute o comando abaixo:

```bash
docker compose up -d postgres-df
```

## 🐋 Passo 3: Subir o Kafka e a Ferramenta de Visualização

Agora, é hora de subir o Kafka e a ferramenta de visualização Redpanda Console. Execute:

```bash
docker compose up -d kafka-broker-df redpanda-console-df
```

### 🔄 Rodar o Postman para Criação do Conector Source

Após iniciar o Kafka, abra o Postman e execute as requisições necessárias para criar o conector Source do PostgreSQL para o Kafka.

## ☁️ Passo 4: Subir o Datalake

Vamos agora iniciar o MinIO, nosso Datalake. Execute:

```bash
docker compose up -d minio-df
```

### 🔄 Rodar o Postman para Criação do Conector Sink

Depois de iniciar o MinIO, utilize o Postman para criar o conector Sink do Kafka para o MinIO S3.

## 🐼 Passo 5: Subir o MongoDB

Agora é a vez do MongoDB! Inicie-o com o comando abaixo:

```bash
docker compose up -d mongo-df
```

## 🌐 Passo 6: Subir o Mongo Express

Por último, mas não menos importante, vamos iniciar o Mongo Express para gerenciar nosso banco de dados MongoDB. Execute:

```bash
docker compose up -d mongo-express-df
```

### 🔄 Rodar o Postman para Criação do Conector Sink

Assim que o MongoDB e o Mongo Express estiverem rodando, use o Postman para criar o conector Sink do Kafka para o MongoDB.

## 🎉 Pronto!

Parabéns! Você agora configurou todos os componentes do projeto Dataflow. Se você seguiu todos os passos corretamente, tudo deve estar funcionando! Se precisar de ajuda, não hesite em perguntar. Boa sorte! 🍀

---

🌟 **Dicas Finais:**
- Sempre verifique os logs do Docker para possíveis erros: `docker logs <container_name>`
- Utilize `docker compose down` para parar todos os serviços quando não estiver em uso.

**Feliz desenvolvimento!** 🛠️