import os
import sys
import argparse
import json

# so "analyzer" is importable when running `python src\cli.py`
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
PARENT_DIR = SCRIPT_DIR  # 'src'
if PARENT_DIR not in sys.path:
    sys.path.append(PARENT_DIR)

from analyzer.features import analyze_file
from analyzer.risk import compute_risk


def main():
    parser = argparse.ArgumentParser(description="Smart Contract Risk Analyzer (local CLI)")
    parser.add_argument("--file", required=True, help="Solidity file to analyze")
    args = parser.parse_args()

    if not os.path.exists(args.file):
        print(f"File not found: {args.file}")
        sys.exit(1)

    source_hash, features = analyze_file(args.file)
    risk_score, risk_level = compute_risk(features)

    result = {
        "source_hash": source_hash,
        "features": features,
        "risk_score": risk_score,
        "risk_level": risk_level,
    }

    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
