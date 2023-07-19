DB_URL=postgresql://root:secret@localhost:5432/hamed_bank?sslmode=disable

postgres:
	sudo docker run --name hamed-postgres --network bank-network -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres

createdb:
	sudo docker exec -it hamed-postgres createdb --username=root --owner=root hamed_bank

dropdb:
	sudo docker exec -it hamed-postgres dropdb hamed_bank

migrateup:
	migrate -path db/migration -database "$(DB_URL)" -verbose up 

migrateup1:
	migrate -path db/migration -database "$(DB_URL)" -verbose up 1

migratedown:
	migrate -path db/migration -database "$(DB_URL)" -verbose down

migratedown1:
	migrate -path db/migration -database "$(DB_URL)" -verbose down 1

dbdocs:
	dbdocs build db/db.dbml

dbschema:
	dbml2sql --postgres -o doc/schema.sql doc/db.dbml

sqlc:
	sqlc generate

test:
	go test -v -cover ./...

server:
	go run main.go

mock:
	mockgen -package mockdb -destination db/mock/store.go github.com/HamedBlue1381/go-postgres-gRPC/db/bankmodel Store

.PHONY: postgres createdb dropdb migratedown migrateup migratedown1 migrateup1 dbdocs dbschema sqlc server mock 