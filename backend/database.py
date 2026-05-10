# database.py
# ─────────────────────────────────────────────────────
# This file is responsible for ONE thing: setting up the
# database connection. Every other file that needs to talk
# to the database imports from here — nothing else needs
# to know HOW the connection works, just that it exists.
# ─────────────────────────────────────────────────────

from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
import os
from dotenv import load_dotenv

load_dotenv()  # reads your .env file so DATABASE_URL is available

DATABASE_URL = os.getenv("DATABASE_URL", "sqlite:///./finance.db")

# The engine is the actual connection to the database file.
# check_same_thread=False is required for SQLite + FastAPI
# because FastAPI handles requests across multiple threads.
engine = create_engine(
    DATABASE_URL,
    connect_args={"check_same_thread": False}
)

# SessionLocal is a factory — calling SessionLocal() gives you
# a new database session. Think of a session as one conversation
# with the database: open it, do your work, close it.
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Base is the parent class all your database models inherit from.
# SQLAlchemy uses it to track which classes map to which tables.
Base = declarative_base()


def get_db():
    """
    Dependency injected into every endpoint that needs DB access.
    Opens a session, yields it to the endpoint, then always closes
    it afterwards — even if an error occurs (that's what try/finally does).

    Usage in a router:
        db: Session = Depends(get_db)
    """
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
