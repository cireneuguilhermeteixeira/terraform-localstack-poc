from testcontainers.core.container import DockerContainer
import boto3
import time

def test_dynamodb_com_localstack():
    # Get LocalStack up and running with just DynamoDB
    with DockerContainer("localstack/localstack:latest") \
        .with_exposed_ports(4566) \
        .with_env("SERVICES", "dynamodb") \
        .with_env("EDGE_PORT", "4566") as localstack:

        port = localstack.get_exposed_port(4566)
        endpoint = f"http://localhost:{port}"

        # Wait for LocalStack to initialize (may improve with healthcheck)
        time.sleep(5)

        # Create DynamoDB client pointing to the container
        dynamodb = boto3.client(
            "dynamodb",
            endpoint_url=endpoint,
            region_name="us-east-1",
            aws_access_key_id="test",
            aws_secret_access_key="test"
        )

        # Create  fake table
        dynamodb.create_table(
            TableName="TestTable",
            KeySchema=[{"AttributeName": "id", "KeyType": "HASH"}],
            AttributeDefinitions=[{"AttributeName": "id", "AttributeType": "S"}],
            BillingMode="PAY_PER_REQUEST"
        )

        # Insert a item
        dynamodb.put_item(
            TableName="TestTable",
            Item={"id": {"S": "123"}, "name": {"S": "Test"}}
        )

        # Get a item
        resp = dynamodb.get_item(
            TableName="TesteTabela",
            Key={"id": {"S": "123"}}
        )

        assert resp["Item"]["name"]["S"] == "Test"