. ./localStack.ps1

function cf-localstack-yaml {
    Param(
        [ValidateSet("survey-stack")]
        [Parameter(Position=0,mandatory=$true)]
        [string]$stackName
    )

    aws --debug cloudformation deploy --stack-name $stackName --template-file C:/R/survey-service/service/ci/revel-health-survey-service.yaml --endpoint-url $cfUri --region $region
}

function cf-localstac-json {
    Param(
        [ValidateSet("survey-stack")]
        [Parameter(Position=0,mandatory=$true)]
        [string]$stackName
    )

    aws --debug cloudformation deploy --stack-name $stackName --template-file C:/R/survey-service/service/ci/revel-health-survey-service.json --endpoint-url $cfUri --region $region
}

function st-list {
    aws cloudformation list-stacks --endpoint-url $cfUri --region $region
}

function st-resources {
    Param(
        [ValidateSet("survey-stack")]
        [Parameter(Position=0,mandatory=$true)]
        [string]$stackName
    )
    aws cloudformation list-stack-resources --stack-name $stackName --endpoint-url $cfUri --region $region

}

function queue-list {
    aws sqs list-queues --endpoint-url $sqsUri --region us-east-2
}

function topic-list {
    aws sns list-topics --endpoint-url $snsUri --region us-east-2
}

function topic-list-sub {
    Param(
        [Parameter(Position=0,mandatory=$true)]
        [string]$topicArn
    )

    aws --debug sns list-subscriptions-by-topic --topic-arn $topicArn --endpoint-url $snsUri --region $region
}