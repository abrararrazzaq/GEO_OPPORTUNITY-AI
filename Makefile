.PHONY: migrate seed dev-api dev-web test e2e lint
migrate:
	cd backend && alembic upgrade head
seed:
	cd backend && python -m app.seed.generate
dev-api:
	cd backend && uvicorn app.main:app --reload --port 8000
dev-web:
	cd frontend && npm run dev
test:
	cd backend && python -m pytest -q -p no:cacheprovider
e2e:
	cd frontend && npm run e2e
lint:
	cd backend && ruff check app tests
	cd frontend && npm run typecheck
