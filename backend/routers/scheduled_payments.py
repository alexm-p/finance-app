# routers/scheduled_payments.py
# ─────────────────────────────────────────────────────
# This file defines all the /scheduled_payments API endpoints.
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
from models.scheduled_payment import ScheduledPayment
from schemas.scheduled_payment import ScheduledPaymentCreate, ScheduledPaymentUpdate, ScheduledPaymentSummary
from services.categoriser import auto_categorise

# APIRouter is like a mini FastAPI app — it groups related
# endpoints together. main.py then registers this router
# with a prefix so all routes here start with /scheduled_payments.
router = APIRouter(prefix="/scheduled_payments", tags=["scheduled_payments"])


@router.get("/", response_model=List[ScheduledPaymentSummary])
def get_scheduled_payments(skip: int = 0, limit: int = 50, db: Session = Depends(get_db)):
    """
    Returns a paginated list of scheduled payments, newest first.
    skip + limit lets Flutter request pages of results.
    """
    return (
        db.query(ScheduledPayment)
        .order_by(ScheduledPayment.next_due.desc())
        .offset(skip)
        .limit(limit)
        .all()
    )


@router.get("/{scheduled_payment_id}", response_model=ScheduledPaymentSummary)
def get_scheduled_payment(scheduled_payment_id: int, db: Session = Depends(get_db)):
    """
    Returns one scheduled payment by ID.
    Raises a 404 if it doesn't exist — FastAPI turns this into
    a proper HTTP 404 response automatically.
    """
    scheduled_payment = db.query(ScheduledPayment).filter(ScheduledPayment.id == scheduled_payment_id).first()
    if not scheduled_payment:
        raise HTTPException(status_code=404, detail="Scheduled payment not found")
    return scheduled_payment


@router.post("/", response_model=ScheduledPaymentSummary, status_code=201)
def create_scheduled_payment(payload: ScheduledPaymentCreate, db: Session = Depends(get_db)):
    data = payload.model_dump()
    if not data.get("category_id"):
        data["category_id"] = auto_categorise(data["merchant"])
    
    scheduled_payment = ScheduledPayment(**data)
    db.add(scheduled_payment)
    db.commit()
    db.refresh(scheduled_payment)
    return scheduled_payment

@router.put("/{scheduled_payment_id}", response_model=ScheduledPaymentSummary)
def update_scheduled_payment(scheduled_payment_id: int, payload: ScheduledPaymentUpdate, db: Session = Depends(get_db)):
    scheduled_payment = db.query(ScheduledPayment).filter(ScheduledPayment.id == scheduled_payment_id).first()
    if not scheduled_payment:
        raise HTTPException(status_code=404, detail="Scheduled payment not found")
    
    for key, value in payload.model_dump().items():
        setattr(scheduled_payment, key, value)
    
    db.commit()
    db.refresh(scheduled_payment)
    return scheduled_payment


@router.delete("/{scheduled_payment_id}", status_code=204)
def delete_scheduled_payment(scheduled_payment_id: int, db: Session = Depends(get_db)):
    """
    Deletes a scheduled payment. Returns 204 No Content on success.
    """
    scheduled_payment = db.query(ScheduledPayment).filter(ScheduledPayment.id == scheduled_payment_id).first()
    if not scheduled_payment:
        raise HTTPException(status_code=404, detail="Scheduled payment not found")
    db.delete(scheduled_payment)
    db.commit()
