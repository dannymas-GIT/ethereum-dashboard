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
