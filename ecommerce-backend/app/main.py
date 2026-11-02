from fastapi import FastAPI

from app.core.config import settings
from app.api import users, products, cart, orders, payments

app = FastAPI(title="E-Commerce Backend", version="0.1.0")

# Include routers
app.include_router(users.router, prefix="/api/users", tags=["users"])
app.include_router(products.router, prefix="/api/products", tags=["products"])
app.include_router(cart.router, prefix="/api/cart", tags=["cart"])
app.include_router(orders.router, prefix="/api/orders", tags=["orders"])
app.include_router(payments.router, prefix="/api/payments", tags=["payments"])

# Root health check
@app.get("/health")
def health_check():
    return {"status": "ok"}
