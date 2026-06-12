from database import Base
from sqlalchemy import Boolean, Column, Integer, Float, String, DateTime
from sqlalchemy.orm import relationship


class ScheduledPayment(Base):
    __tablename__ = "scheduled_payments"

    id          = Column(Integer, primary_key=True, index=True)
    name        = Column(String, nullable=False)
    amount      = Column(Float, nullable=False) # positive for income, negative for expenses
    frequency   = Column(String, nullable=False)  # e.g. "weekly", "monthly"
    next_due    = Column(DateTime, nullable=False)
    category_id = Column(Integer, nullable=True)
    merchant    = Column(String, nullable=True)  # optional, for categorisation
    is_active   = Column(Boolean, default=True)  # 1 for active, 0 for inactive

    def __repr__(self):
        return f"<ScheduledPayment {self.name} £{self.amount} on {self.next_due}>"