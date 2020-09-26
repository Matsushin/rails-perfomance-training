init:
	make build
	docker-compose run web bundle exec rails db:create
	docker-compose run web bundle exec rails db:migrate
	docker-compose run web bundle exec rails db:seed
build:
	docker-compose build
	make install
install:
	docker-compose run web bundle install
	docker-compose run web yarn install
up:
	docker-compose up
down:
	docker-compose down
stop:
	docker-compose stop
restart:
	docker-compose up
	docker-compose stop