import re, hashlib
from pathlib import Path

def read_source(path): return Path(path).read_text()

def hash_source(src): return hashlib.sha256(src.encode()).hexdigest()

def extract_features_from_text(src):
    lines = src.splitlines(); n = len(lines)
    return {
        'n_lines': n,
        'n_payable': len(re.findall(r'payable', src)),
        'has_delegatecall': int('delegatecall' in src),
        'has_call_value': int('call.value' in src),
        'has_tx_origin': int('tx.origin' in src)
    }

def analyze_file(path):
    src = read_source(path)
    return hash_source(src), extract_features_from_text(src)
