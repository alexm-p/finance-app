# main.py
# ─────────────────────────────────────────────────────
# This is the entry point for the entire backend.
# It should be as LEAN as possible — its only job is to
# create the app, register routers, and start the server.
#
# If you find yourself writing business logic here,
# it belongs in services/ or routers/ instead.
# ─────────────────────────────────────────────────────

from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
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

 
@app.options("/{rest_of_path:path}")

async def preflight_handler(request: Request, rest_of_path: str):

    return JSONResponse(

        content={},

        headers={

            "Access-Control-Allow-Origin": "*",

            "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",

            "Access-Control-Allow-Headers": "*",

        }

    )
 

# Register routers — this is how main.py knows about your endpoints.
# Each router brings its own prefix (/transactions, /income etc.)
# app.include_router(income.router)
# app.include_router(categories.router)
# app.include_router(auth.router)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=False,
    allow_methods=["GET", "POST", "PUT", "DELETE", "OPTIONS"],
    allow_headers=["*"],
)

app.include_router(transactions.router)


@app.get("/health")
def health_check():
    """
    Simple endpoint to confirm the server is running.
    Hit http://localhost:8000/health to verify everything is up.
    """
    return {"status": "ok"}
