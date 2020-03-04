.PHONY: server

image:
	docker build -t aptamer-web:latest .

server:
	docker run -it --rm --env-file macdev.env -P aptamer-web:latest 

terminal:
	docker run -it --rm --env-file macdev.env -P aptamer-web:latest /bin/bash
