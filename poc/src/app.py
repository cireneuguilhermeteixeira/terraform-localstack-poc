import boto3

dynamodb = boto3.resource(
    "dynamodb",
    endpoint_url="http://localhost:4566",
    region_name="us-east-1",
    aws_access_key_id="test",
    aws_secret_access_key="test",
)

tabela = dynamodb.Table("MyTable")
tabela.put_item(Item={"id": "123", "value": "worked!"})
print(tabela.get_item(Key={"id": "123"}))