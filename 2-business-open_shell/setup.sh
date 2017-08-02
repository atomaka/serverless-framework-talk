#!/bin/bash
set -x

role=$(AWS_DEFAULT_REGION=us-east-2 aws iam create-role \
  --path /examples/ \
	--role-name business-hours-lambda \
	--assume-role-policy-document file://resources/role-policy.json \
    | jq '.Role.Arn' \
    | tr -d '"')
AWS_DEFAULT_REGION=us-east-2 aws iam create-role \
  --path /examples/ \
	--role-name log-business-hours-lambda \
	--assume-role-policy-document file://resources/log-policy.json

echo sleeping 10
sleep 10

lambda=$(AWS_DEFAULT_REGION=us-east-2 aws lambda create-function \
  --function-name business-hours \
	--runtime nodejs6.10 \
	--role $role \
	--handler index.index \
  --zip-file fileb://build/business-hours.zip \
    | jq '.FunctionArn' \
    | tr -d '"')

echo sleeping 5
sleep 5

api=$(aws apigateway create-rest-api \
  --name 'Shell Business Hours' \
  --region us-east-2 \
    | jq '.id' \
    | tr -d '"')

echo sleeping 5
sleep 5

resource=$(aws apigateway get-resources \
  --rest-api-id $api \
  --region us-east-2 \
    | jq '.items[0].id' \
    | tr -d '"')

echo sleeping 5
sleep 5

aws apigateway put-method \
  --rest-api-id $api \
  --resource-id $resource \
  --http-method GET \
  --authorization-type "NONE" \
  --region us-east-2

echo sleeping 5
sleep 5

aws apigateway put-integration \
  --rest-api-id $api \
  --resource-id $resource \
  --http-method GET \
  --type AWS \
  --integration-http-method GET \
  --uri arn:aws:apigateway:us-east-2:lambda:path/2015-03-31/functions/$lambda/invocations

echo sleeping 5
sleep 5

api=l271anov3c
aws apigateway create-deployment \
  --rest-api-id $api \
  --stage-name prod
