from typing import Dict, Tuple

def compute_risk(features: Dict[str, float]) -> Tuple[int, str]:
    """
    Turn extracted features into a heuristic risk score (0–100)
    and a risk level: Low / Medium / High.
    """

    score = 0

    # Very high-risk patterns
    if features.get("has_delegatecall", 0):
        score += 50  # was 40
    if features.get("has_tx_origin", 0):
        score += 40  # was 25
    if features.get("has_call_value", 0):
        score += 30

    # Structural heuristics
    n_payable = features.get("n_payable", 0)
    n_lines = features.get("n_lines", 0)

    # Many payable functions = more attack surface
    if n_payable > 3:
        score += 25  # was 10
    elif n_payable > 0:
        score += 5

    # Very large contracts → more complexity, slightly riskier
    if n_lines > 300:
        score += 15
    elif n_lines > 100:
        score += 5

    # Clamp to [0, 100]
    score = max(0, min(100, score))

    # 🎚 New thresholds
    # 0-20: Low, 21-60: Medium, 61+: High
    if score <= 20:
        level = "Low"
    elif score <= 60:
        level = "Medium"
    else:
        level = "High"

    return score, level
