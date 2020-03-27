.PHONY: web bootstrap_container terminal

web_image:
	docker build -t aptamer-web:latest .

bootstrap_image:
	docker build -f Dockerfile.db -t aptamer-db:latest .

web:
	docker run -it --rm --env-file macdev.env -P aptamer-web:latest 

bootstrap_container:
	docker run --rm --env-file macdev.env aptamer-db:latest

terminal:
	docker run -it --rm --env-file macdev.env -P aptamer-web:latest /bin/bash
