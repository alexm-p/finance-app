# main.py
# ─────────────────────────────────────────────────────
# This is the entry point for the entire backend.
# It should be as LEAN as possible — its only job is to
# create the app, register routers, and start the server.
#
# If you find yourself writing business logic here,
# it belongs in services/ or routers/ instead.
# ─────────────────────────────────────────────────────

from fastapi import FastAPI
from database import engine, Base

# Import all routers — each one handles a section of the API
from routers import transactions
# from routers import income       ← you'll add these as you build
# from routers import categories
# from routers import auth

# Create all database tables on startup.
# SQLAlchemy checks if each table exists first — safe to run every time.
Base.metadata.create_all(bind=engine)

app = FastAPI(
    title="Finance App API",
    description="Personal finance tracker backend",
    version="0.1.0"
)

# Register routers — this is how main.py knows about your endpoints.
# Each router brings its own prefix (/transactions, /income etc.)
app.include_router(transactions.router)
# app.include_router(income.router)
# app.include_router(categories.router)
# app.include_router(auth.router)


@app.get("/health")
def health_check():
    """
    Simple endpoint to confirm the server is running.
    Hit http://localhost:8000/health to verify everything is up.
    """
    return {"status": "ok"}
