# models/transaction.py
# ─────────────────────────────────────────────────────
# This file defines what the 'transactions' table looks
# like in the database. It's a pure description of structure
# — no business logic, no API handling, just columns.
#
# SQLAlchemy reads this class and creates/manages the actual
# SQL table from it. You never write CREATE TABLE yourself.
# ─────────────────────────────────────────────────────

from sqlalchemy import Column, Integer, Float, String, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from datetime import datetime

# Base comes from database.py — this is what links this model
# to the database engine you configured there.
from database import Base


class Transaction(Base):
    __tablename__ = "transactions"

    id          = Column(Integer, primary_key=True, index=True)
    amount      = Column(Float, nullable=False)       # negative = expense
    merchant    = Column(String, nullable=False)      # e.g. "Tesco", "Netflix"
    description = Column(String, nullable=True)       # optional extra detail
    date        = Column(DateTime, nullable=False)    # when it actually happened
    source      = Column(String, nullable=False)      # "lloyds", "manual"
    created_at  = Column(DateTime, default=datetime.utcnow)  # when we recorded it

    # Foreign key links to the categories table.
    # nullable=True means uncategorised transactions are allowed.
    category_id = Column(Integer, ForeignKey("categories.id"), nullable=True)

    # relationship() lets you do transaction.category to get the full
    # Category object, rather than just the raw integer ID.
    category = relationship("Category", back_populates="transactions")

    def __repr__(self):
        return f"<Transaction {self.merchant} £{self.amount} on {self.date}>"
