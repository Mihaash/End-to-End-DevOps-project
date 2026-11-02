from flask import Flask
from .config import Config
from .auth import auth_bp
from .products import products_bp
from .cart import cart_bp
from .orders import orders_bp
from .database import db

def create_app():
    app = Flask(__name__)
    app.config.from_object(Config)
    db.init_app(app)

    # Register blueprints
    app.register_blueprint(auth_bp, url_prefix='/api/auth')
    app.register_blueprint(products_bp, url_prefix='/api/products')
    app.register_blueprint(cart_bp, url_prefix='/api/cart')
    app.register_blueprint(orders_bp, url_prefix='/api/orders')

    @app.route('/')
    def health():
        return {"status": "ok"}

    return app
