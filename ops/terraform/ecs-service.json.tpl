{
    "cluster": "my-cluster",
    "serviceName": "my-service",
    "taskDefinition": "sinatra-hi",
    "loadBalancers": [
        {
            "targetGroupArn": "FILL-IN-YOUR-TARGET-GROUP",
            "containerName": "web",
            "containerPort": 4567
        }
    ],
    "desiredCount": 1,
    "launchType": "EC2"
}
