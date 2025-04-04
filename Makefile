## Run templ generate
tmpl:
	templ generate

run:
	go build -o ./tmp/gotth ./main.go && ./tmp/gotth

twc:
	twc -i ./static/css/index.css -o ./static/css/style.css

gun:
	$(MAKE) tmpl
	$(MAKE) twc
	$(MAKE) run
