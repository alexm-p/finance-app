# routers/transactions.py
# ─────────────────────────────────────────────────────
# This file defines all the /transactions API endpoints.
# Routers are COORDINATORS — they receive requests, call
# the right service or query, and return a response.
#
# They should NOT contain business logic themselves.
# If an endpoint is doing heavy lifting, that logic
# belongs in services/ instead.
# ─────────────────────────────────────────────────────

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List

from database import get_db
from models.transaction import Transaction
from schemas.transaction import TransactionCreate, TransactionResponse, TransactionSummary
from services.categoriser import auto_categorise

# APIRouter is like a mini FastAPI app — it groups related
# endpoints together. main.py then registers this router
# with a prefix so all routes here start with /transactions.
router = APIRouter(prefix="/transactions", tags=["transactions"])


@router.get("/", response_model=List[TransactionSummary])
def get_transactions(skip: int = 0, limit: int = 50, db: Session = Depends(get_db)):
    """
    Returns a paginated list of transactions, newest first.
    skip + limit lets Flutter request pages of results.
    """
    return (
        db.query(Transaction)
        .order_by(Transaction.date.desc())
        .offset(skip)
        .limit(limit)
        .all()
    )


@router.get("/{transaction_id}", response_model=TransactionResponse)
def get_transaction(transaction_id: int, db: Session = Depends(get_db)):
    """
    Returns one transaction by ID.
    Raises a 404 if it doesn't exist — FastAPI turns this into
    a proper HTTP 404 response automatically.
    """
    transaction = db.query(Transaction).filter(Transaction.id == transaction_id).first()
    if not transaction:
        raise HTTPException(status_code=404, detail="Transaction not found")
    return transaction


@router.post("/", response_model=TransactionResponse, status_code=201)
def create_transaction(payload: TransactionCreate, db: Session = Depends(get_db)):
    """
    Manually add a transaction (e.g. cash purchase not in bank feed).
    Calls the categoriser service to guess the category automatically.
    """
    # Ask the categoriser service to suggest a category
    # based on the merchant name — keeps this logic out of the router
    category_id = auto_categorise(payload.merchant) if not payload.category_id else payload.category_id

    transaction = Transaction(**payload.model_dump(), category_id=category_id)
    db.add(transaction)
    db.commit()
    db.refresh(transaction)  # re-reads from DB so we get the generated id + created_at
    return transaction


@router.delete("/{transaction_id}", status_code=204)
def delete_transaction(transaction_id: int, db: Session = Depends(get_db)):
    """
    Deletes a transaction. Returns 204 No Content on success.
    """
    transaction = db.query(Transaction).filter(Transaction.id == transaction_id).first()
    if not transaction:
        raise HTTPException(status_code=404, detail="Transaction not found")
    db.delete(transaction)
    db.commit()
