from pydantic import BaseModel
from datetime import datetime

class ScheduledPaymentCreate(BaseModel):
    name: str
    amount: float
    frequency: str
    next_due: datetime
    category_id: int | None
    is_active: bool = True


class ScheduledPaymentUpdate(BaseModel):
    name: str | None
    amount: float | None
    frequency: str | None
    next_due: datetime | None
    category_id: int | None
    is_active: bool | None

    model_config = {"from_attributes": True}


class ScheduledPaymentSummary(BaseModel):
    id: int
    name: str
    amount: float
    frequency: str
    next_due: datetime
    category_id: int | None
    is_active: bool

    model_config = {"from_attributes": True}
