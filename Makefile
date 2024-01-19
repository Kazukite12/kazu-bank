postgres:
	docker run --name postgres16 -p 5431:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=Ujang123 -d postgres:16-alpine

createdb:
	docker exec -it postgres16  createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it postgres16 dropdb simple_bank

migrateup:
	migrate -path db/migration -database "postgresql://root:Ujang123@localhost:5431/simple_bank?sslmode=disable" --verbose up 

migrateup1:
	migrate -path db/migration -database "postgresql://root:Ujang123@localhost:5431/simple_bank?sslmode=disable" --verbose up 1

migrateup2:
	migrate -path db/migration -database "postgresql://root:Ujang123@localhost:5431/simple_bank?sslmode=disable" --verbose up 2

migratedown:
	migrate -path db/migration -database "postgresql://root:Ujang123@localhost:5431/simple_bank?sslmode=disable" --verbose down

migratedown1:
	migrate -path db/migration -database "postgresql://root:Ujang123@localhost:5431/simple_bank?sslmode=disable" --verbose down 1

migratedown2:
	migrate -path db/migration -database "postgresql://root:Ujang123@localhost:5431/simple_bank?sslmode=disable" --verbose down 2

sqlc:
	docker run --rm -v "E:\simple-bank:/src" -w /src sqlc/sqlc generate

test:
	go test -v -cover ./...

server:
	go run main.go

mock:
	mockgen -package mockdb -destination db/mock/store.go github.com/Kazukite12/simple-bank/db/sqlc Store

proto:
	protoc --proto_path=proto --go_out=pb --go_opt=paths=source_relative \
    --go-grpc_out=pb --go-grpc_opt=paths=source_relative \
	--grpc-gateway_out=pb --grpc-gateway_opt paths=source_relative \
    proto/*.proto

.PHONY: postgres createdb dropdb migrateup migratedown sqlc test server mock migratedown1 migrateup1 proto migratedown2 migrateup2
