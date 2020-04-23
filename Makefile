.PHONY: web bootstrap_container terminal

web_image:
	docker build -t aptamer-web:latest .

bootstrap_image:
	docker build -f Dockerfile.db -t aptamer-db:latest .

batch_image:
	docker build -f Dockerfile.batch -t aptamer-batch:latest .

web:
	docker run -it --rm --env-file macdev.env -P aptamer-web:latest 

bootstrap_container:
	docker run --rm --env-file macdev.env aptamer-db:latest

batch_run:
	docker run --env-file macdev.env aptamer-batch:latest

terminal:
	docker run -it --rm --env-file macdev.env -P aptamer-web:latest /bin/bash

cert:
	mkdir -p ops/certs
	#docker run -it -v $(HOME)/.aws/credentials:/root/.aws/credentials -v $(PWD)/ops/terraform/certs:/etc/letsencrypt certbot/dns-route53 certonly -d icts-aptamer.aws.cloud.uiowa.edu -d "*.icts-aptamer.aws.cloud.uiowa.edu" --dns-route53 -m 'chris-ortman@uiowa.edu' --agree-tos --non-interactive --server https://acme-v02.api.letsencrypt.org/directory
	tar czf ops/certs.tar.gz ops/certs

upload_cert:
	@echo AWS CLI is broken
	exit 1
	tar xzf ops/certs.tar.gz
	aws acm import-certificate \
		--certificate file://ops/certs/live/icts-aptamer.aws.cloud.uiowa.edu/cert.pem \
		--certificate-chain file://ops/certs/live/icts-aptamer.aws.cloud.uiowa.edu/fullchain.pem \
		--private-key file://ops/certs/live/icts-aptamer.aws.cloud.uiowa.edu/privkey.pem
