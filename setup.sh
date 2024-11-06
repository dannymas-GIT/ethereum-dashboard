# Create directories
mkdir -p .devcontainer
mkdir -p .github/workflows
mkdir -p backend/app/api/v1
mkdir -p backend/app/core
mkdir -p backend/app/models
mkdir -p backend/app/schemas
mkdir -p backend/app/services
mkdir -p backend/tests
mkdir -p frontend/src/components
mkdir -p frontend/src/services
mkdir -p frontend/src/utils
mkdir -p docker
mkdir -p docs

# Create .gitignore
cat > .gitignore << 'EOL'
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg
MANIFEST
.env

# Node
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*
.next
out/
build
dist/

# IDEs
.idea/
.vscode/
*.swp
*.swo

# Virtual Environment
venv/
env/
ENV/

# Docker
.docker/

# Local development
*.log
.DS_Store
EOL

# Create README.md
cat > README.md << 'EOL'
# Ethereum Dashboard

A dashboard for monitoring and analyzing Ethereum blockchain data.

## Setup

### Prerequisites
- Docker and Docker Compose
- Python 3.11+
- Node.js 16+

### Development
1. Clone the repository
2. Run `make setup` to install dependencies
3. Run `make docker-up` to start services
4. Visit `http://localhost:3000` for the frontend

## Architecture
- Frontend: React with TypeScript
- Backend: FastAPI
- Database: PostgreSQL
- Cache: Redis
- Blockchain: Web3.py

## Documentation
See the `/docs` directory for detailed documentation.
EOL

# Create docker-compose.yml
cat > docker-compose.yml << 'EOL'
version: '3.8'

services:
  backend:
    build:
      context: .
      dockerfile: docker/Dockerfile
      target: development
    volumes:
      - ./backend:/app/backend
    ports:
      - "8000:8000"
    environment:
      - PYTHONPATH=/app
    command: uvicorn backend.app.main:app --reload --host 0.0.0.0 --port 8000

  frontend:
    build:
      context: ./frontend
      dockerfile: ../docker/Dockerfile.frontend
    volumes:
      - ./frontend:/app
      - /app/node_modules
    ports:
      - "3000:3000"
    depends_on:
      - backend

  redis:
    image: redis:alpine
    ports:
      - "6379:6379"
EOL

# Create pyproject.toml
cat > pyproject.toml << 'EOL'
[tool.poetry]
name = "ethereum-dashboard"
version = "0.1.0"
description = "Ethereum Dashboard Application"
authors = ["Your Name <your.email@example.com>"]

[tool.poetry.dependencies]
python = "^3.11"
fastapi = "^0.68.0"
uvicorn = "^0.15.0"
web3 = "^6.0.0"
redis = "^4.0.0"
sqlalchemy = "^1.4.0"
alembic = "^1.7.0"
python-dotenv = "^0.19.0"
pydantic = "^1.8.2"

[tool.poetry.dev-dependencies]
pytest = "^6.2.5"
black = "^21.9b0"
isort = "^5.9.3"
flake8 = "^3.9.2"
mypy = "^0.910"
pre-commit = "^2.15.0"
EOL

# Create requirements.txt
cat > requirements.txt << 'EOL'
fastapi>=0.68.0,<0.69.0
uvicorn>=0.15.0,<0.16.0
web3>=6.0.0
redis>=4.0.0
sqlalchemy>=1.4.0
alembic>=1.7.0
python-dotenv>=0.19.0
pydantic>=1.8.2
pytest>=6.2.5
black>=21.9b0
isort>=5.9.3
flake8>=3.9.2
mypy>=0.910
pre-commit>=2.15.0
EOL

# Create Makefile
cat > Makefile << 'EOL'
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
EOL

# Create initial Python files
touch backend/app/__init__.py

# Create main.py
cat > backend/app/main.py << 'EOL'
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(
    title="Ethereum Dashboard",
    description="API for Ethereum Dashboard",
    version="1.0.0"
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/health")
async def health_check():
    return {"status": "healthy"}
EOL

# Create devcontainer.json
mkdir -p .devcontainer
cat > .devcontainer/devcontainer.json << 'EOL'
{
    "name": "Ethereum Dashboard Dev",
    "build": {
        "dockerfile": "Dockerfile",
        "context": ".."
    },
    "customizations": {
        "vscode": {
            "extensions": [
                "ms-python.python",
                "ms-python.vscode-pylance",
                "dbaeumer.vscode-eslint",
                "esbenp.prettier-vscode",
                "bradlc.vscode-tailwindcss",
                "mikestead.dotenv"
            ]
        }
    },
    "forwardPorts": [3000, 8000],
    "postCreateCommand": "pip install -r requirements.txt && pre-commit install",
    "remoteUser": "vscode"
}
EOL

# Create Dockerfile for dev container
cat > .devcontainer/Dockerfile << 'EOL'
FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y \
    curl \
    git \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -ms /bin/bash vscode
USER vscode

WORKDIR /workspace
EOL

# Create initial GitHub Actions workflow
mkdir -p .github/workflows
cat > .github/workflows/ci.yml << 'EOL'
name: CI

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - name: Set up Python
      uses: actions/setup-python@v2
      with:
        python-version: '3.11'
    - name: Install dependencies
      run: |
        python -m pip install --upgrade pip
        pip install -r requirements.txt
    - name: Run tests
      run: |
        pytest backend/tests
EOL

# Initialize git and create first commit
git init
git add .
git commit -m "Initial project structure"

echo "Project structure created successfully!"
echo "Next steps:"
echo "1. Create a repository on GitHub"
echo "2. Add remote: git remote add origin <your-github-repo-url>"
echo "3. Push to GitHub: git push -u origin main"