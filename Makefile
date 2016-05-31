default: build

build:
	docker build --rm -t techiaith/metashare .

run:
	docker run -it --name=metashare --restart=always -p 5030:80 techiaith/metashare bash
