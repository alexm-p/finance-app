# schemas/transaction.py
# ─────────────────────────────────────────────────────
# Pydantic schemas define the SHAPE of data coming IN
# to your API (requests) and going OUT (responses).
#
# This is separate from models/ because your database
# shape and your API shape aren't always identical —
# for example, you never want to expose created_at or
# raw foreign keys to your Flutter app.
#
# Think of schemas as a contract between your backend
# and your Flutter frontend.
# ─────────────────────────────────────────────────────

from pydantic import BaseModel
from datetime import datetime
from typing import Optional


class TransactionCreate(BaseModel):
    """
    Shape of data Flutter sends when manually adding a transaction.
    Notice there's no 'id' or 'created_at' — the backend generates those.
    """
    amount:      float
    merchant:    str
    description: Optional[str] = None
    date:        datetime
    source:      str = "manual"
    category_id: Optional[int] = None


class TransactionResponse(BaseModel):
    """
    Shape of data sent BACK to Flutter.
    Includes id and created_at which the DB generated.
    Excludes sensitive internals you don't want exposed.
    """
    id:          int
    amount:      float
    merchant:    str
    description: Optional[str]
    date:        datetime
    source:      str
    category_id: Optional[int]
    created_at:  datetime

    model_config = {"from_attributes": True}
    # ↑ This tells Pydantic it can read from a SQLAlchemy object,
    # not just a plain dictionary. Without this, returning a
    # Transaction model from an endpoint would fail.


class TransactionSummary(BaseModel):
    """
    A lighter version used in list views where you don't need
    every field — keeps API responses small and fast.
    """
    id:       int
    amount:   float
    merchant: str
    date:     datetime

    model_config = {"from_attributes": True}
