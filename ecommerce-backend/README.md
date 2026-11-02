# E-Commerce Backend

This repository contains the **Python FastAPI** backend for an e‑commerce platform. It provides RESTful APIs for product catalog, user management, shopping cart, order processing, and Stripe payment integration. The application uses **MySQL** as the relational database and is containerized with Docker.

## Features
- FastAPI with automatic OpenAPI documentation (`/docs`)
- JWT‑based authentication (access & refresh tokens)
- SQLAlchemy ORM with Alembic migrations
- Docker & Docker‑Compose for local development
- GitHub Actions CI pipeline (lint, test, build Docker image)
