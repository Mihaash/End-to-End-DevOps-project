# eKart Backend (Flask)

This directory contains the Flask based backend for the eKart application.
It provides REST APIs for authentication, product catalog, cart, and orders.

## Quick Start (local)
```bash
cd backend
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
flask --app app run --host 0.0.0.0 --port 8000
```

The API will be available at `http://localhost:8000`.

## Structure
- `app/` – Flask application package.
  - `__init__.py` – creates the Flask app, registers blueprints.
  - `config.py` – configuration loading (environment variables).
  - `models.py` – SQLAlchemy models.
  - `auth.py` – authentication routes.
  - `products.py` – product routes.
  - `cart.py` – cart routes.
  - `orders.py` – order routes.
- `requirements.txt` – Python dependencies.
- `Dockerfile` – container image for production.
- `run.sh` – optional entrypoint script.
