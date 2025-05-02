# LocalStack Setup

Install localstack https://docs.localstack.cloud/getting-started/installation/

Then run 'localstack start' you should see something like this in your terminal
![image](https://github.com/user-attachments/assets/8abb4d4c-793d-4688-95b4-dbbba54716a3)

Now go to https://app.localstack.cloud/inst/default/status to see the available services and if everything is running and working.
![image](https://github.com/user-attachments/assets/e0c5b471-85e4-4a45-a766-32f95d86c3f5)


# Terraform Setup
follow the instructions in the official documentation https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
then create a .tf file with your settings and run the commands
`terraform init`
`terraform apply`

![image](https://github.com/user-attachments/assets/4c053168-84ad-4717-8c10-874f8d1a01ac)


# Code 

Now we will create an application using boto3, a well-known AWS client in Python. The idea is to simulate a connection and use of a database using terraform and localstack. Since the only database provided for free by localstack is dynamodb, we will use it.
We create the table creation settings (note that the host and port must be the same ones created by localstack).

python code
```
dynamodb = boto3.resource(
    "dynamodb",
    endpoint_url="http://localhost:4566",
    region_name="us-east-1",
    aws_access_key_id="test",
    aws_secret_access_key="test",
)
```
terraform config

```
provider "aws" {
  region                      = "us-east-1"
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  endpoints {
    dynamodb = "http://localhost:4566"
    iam      = "http://localhost:4566"
    sts      = "http://localhost:4566"
  }
}
```
After running the code you will see something like this

```
python app.py
{'Item': {'value': 'worked!', 'id': '123'}, 'ResponseMetadata': {'RequestId': '017e19cb-412c-47fb-9f44-bd9b5c3f0ecf', 'HTTPStatusCode': 200, 'HTTPHeaders': {'server': 'TwistedWeb/24.3.0', 'date': 'Fri, 02 May 2025 14:21:36 GMT', 'content-type': 'application/x-amz-json-1.0', 'content-length': '57', 'x-amzn-requestid': '017e19cb-412c-47fb-9f44-bd9b5c3f0ecf', 'x-amz-crc32': '1725436555'}, 'RetryAttempts': 0}}
```
And checking on localstack you can see your information saved there.

![image](https://github.com/user-attachments/assets/5751185a-13e2-4a03-8d79-cf51ceeeac08)
![image](https://github.com/user-attachments/assets/8d7155cc-6124-4973-9c48-008575f3b23b)





