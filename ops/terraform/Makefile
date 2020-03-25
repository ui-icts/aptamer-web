set_terraform_vals:
	$(eval TARGET_ARN = $(shell terraform output service_group_target_arn))
	$(eval CLUSTER_NAME = $(shell terraform output service_cluster_name))

ecs-service.json: set_terraform_vals
	@echo DEBUG OUTPUT IS $(TARGET_ARN)
	jq '.cluster = "$(CLUSTER_NAME)" | .loadBalancers[0].targetGroupArn = "$(TARGET_ARN)"' ecs-service.json.tpl | tee ecs-service.json
