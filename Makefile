.PHONY: setup test run

setup:
	python -m venv venv
	. venv/bin/activate && pip install -r requirements.txt
	cd frontend && npm install

run-backend:
	cd backend && uvicorn app.main:app --reload --host 0.0.0.0 --port 8000

run-frontend:
	cd frontend && npm run dev

test:
	pytest backend/tests
	cd frontend && npm test

docker-up:
	docker-compose up -d

docker-down:
	docker-compose down
