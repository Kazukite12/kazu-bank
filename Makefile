postgres:
	docker run --name postgres16 -p 5431:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=Ujang123 -d postgres:16-alpine

createdb:
	docker exec -it postgres16  createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it postgres16 dropdb simple_bank

migrateup:
	migrate -path db/migration -database "postgresql://root:Ujang123@localhost:5431/simple_bank?sslmode=disable" --verbose up 

migratedown:
	migrate -path db/migration -database "postgresql://root:Ujang123@localhost:5431/simple_bank?sslmode=disable" --verbose down

sqlc:
	docker run --rm -v "E:\simple-bank:/src" -w /src sqlc/sqlc generate

test:
	go test -v -cover ./...

.PHONY: postgres createdb dropdb migrateup migratedown sqlc
