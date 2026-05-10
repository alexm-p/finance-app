# services/categoriser.py
# ─────────────────────────────────────────────────────
# This service contains the business logic for automatically
# assigning a category to a transaction based on the merchant name.
#
# Services are where the REAL WORK happens. By keeping this
# separate from the router, you can:
#   - Test it independently without spinning up a web server
#   - Reuse it in multiple places (manual entry AND bank sync)
#   - Swap out the logic later (e.g. replace with ML model)
#     without touching any endpoints
# ─────────────────────────────────────────────────────

from typing import Optional

# Maps category IDs (matching your categories table) to
# lists of keywords to look for in merchant names.
# Keyword matching is case-insensitive.
CATEGORY_RULES: dict[int, list[str]] = {
    1: ["tesco", "sainsbury", "asda", "lidl", "aldi", "morrisons", "waitrose", "co-op"],  # Groceries
    2: ["netflix", "spotify", "amazon prime", "disney", "apple music", "youtube"],        # Subscriptions
    3: ["mcdonalds", "kfc", "burger king", "nando", "deliveroo", "uber eats", "just eat"],# Eating Out
    4: ["uber", "bolt", "trainline", "tfl", "national rail", "bus"],                      # Transport
    5: ["bp", "shell", "esso", "texaco", "gulf"],                                         # Fuel
    6: ["boots", "superdrug", "lloyds pharmacy", "chemist"],                              # Health
    7: ["amazon", "ebay", "argos", "currys", "asos", "primark"],                         # Shopping
}


def auto_categorise(merchant: str) -> Optional[int]:
    """
    Takes a merchant name string and returns the best matching
    category ID, or None if no match is found.

    Example:
        auto_categorise("TESCO STORES 1234")  →  1  (Groceries)
        auto_categorise("Some unknown shop")  →  None
    """
    merchant_lower = merchant.lower()

    for category_id, keywords in CATEGORY_RULES.items():
        if any(keyword in merchant_lower for keyword in keywords):
            return category_id

    return None  # uncategorised — the user can assign manually in the app


def get_category_confidence(merchant: str) -> tuple[Optional[int], float]:
    """
    Extended version that also returns a confidence score (0.0 - 1.0).
    Useful later if you want to show "we think this is Groceries — correct?"
    in the Flutter UI rather than silently auto-assigning.

    Currently simple keyword = 1.0 confidence.
    Could be replaced with an ML model returning real probabilities.
    """
    category_id = auto_categorise(merchant)
    confidence = 1.0 if category_id is not None else 0.0
    return category_id, confidence
