# models/transaction.py
from sqlalchemy import Column, Integer, Float, String, DateTime, ForeignKey
from datetime import datetime
from database import Base


class Transaction(Base):
    __tablename__ = "transactions"

    id          = Column(Integer, primary_key=True, index=True)
    amount      = Column(Float, nullable=False)
    merchant    = Column(String, nullable=False)
    description = Column(String, nullable=True)
    date        = Column(DateTime, nullable=False)
    source      = Column(String, nullable=False)
    scheduled_payment_id = Column(Integer, ForeignKey("scheduled_payments.id"), nullable=True)
    category_id = Column(Integer, nullable=True)
    created_at  = Column(DateTime, default=datetime.utcnow)

    def __repr__(self):
        return f"<Transaction {self.merchant} £{self.amount} on {self.date}>"