import os
import logging

from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.orm import DeclarativeBase
from werkzeug.middleware.proxy_fix import ProxyFix
from flask_login import LoginManager


# Configure logging
logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)

class Base(DeclarativeBase):
    pass


db = SQLAlchemy(model_class=Base)
# create the app
app = Flask(__name__)
app.secret_key = os.environ.get("SESSION_SECRET", "dev_secret_key")
app.wsgi_app = ProxyFix(app.wsgi_app, x_proto=1, x_host=1)  # needed for url_for to generate with https

# configure the database
app.config["SQLALCHEMY_DATABASE_URI"] = os.environ.get("DATABASE_URL", "postgresql://aidb_hjgx_user:VoaXvL958Y9oUqQIjUjOA79qybGYXmOf@dpg-d09nb249c44c73e1k55g-a.oregon-postgres.render.com/aidb_hjgx")
app.config["SQLALCHEMY_ENGINE_OPTIONS"] = {
    "pool_recycle": 300,
    "pool_pre_ping": True,
}
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

# File upload configuration
app.config["MAX_CONTENT_LENGTH"] = 16 * 1024 * 1024  # 16MB max upload
app.config["UPLOAD_FOLDER"] = os.path.join(os.path.dirname(os.path.abspath(__file__)), "uploads")
app.config["TMP_FOLDER"] = os.path.join(os.path.dirname(os.path.abspath(__file__)), "tmp")

# Create necessary directories
os.makedirs(app.config["UPLOAD_FOLDER"], exist_ok=True)
os.makedirs(app.config["TMP_FOLDER"], exist_ok=True)

# initialize the app with the extension
db.init_app(app)

# Initialize Flask-Login
login_manager = LoginManager()
login_manager.login_view = 'auth.login'
login_manager.init_app(app)

# Import the user model after initializing the db
from models import User

@login_manager.user_loader
def load_user(user_id):
    # Return the user object based on the user ID
    return User.query.get(int(user_id))

# Create tables
with app.app_context():
    # Make sure to import all models here
    import models  # noqa: F401
    logger.info("Creating database tables...")
    db.create_all()
    logger.info("Database tables created successfully.")

# Register blueprints
from auth import auth_bp
from chat import chat_bp
from training import training_bp


app.register_blueprint(auth_bp)
app.register_blueprint(chat_bp)
app.register_blueprint(training_bp)

# Main route
@app.route('/')
def index():
    from flask import render_template
    return render_template('index.html')
