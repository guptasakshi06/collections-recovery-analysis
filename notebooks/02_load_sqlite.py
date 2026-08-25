import sqlite3
from pathlib import Path
import pandas as pd

BASE_DIR = Path(__file__).resolve().parent.parent
PROCESSED_DIR = BASE_DIR / "data" / "processed"
DB_PATH = BASE_DIR / "sql" / "collections_analysis.db"

FILES = {
    "borrowers": "borrowers_clean.csv",
    "accounts": "accounts_clean.csv",
    "payments": "payments_clean.csv",
    "calls": "calls_clean.csv",
    "call_attempts": "call_attempts_clean.csv",
    "promises_to_pay": "promises_to_pay_clean.csv",
    "daily_targeting": "daily_targeting_clean.csv",
    "campaigns": "campaigns_clean.csv",
    "field_visits": "field_visits_clean.csv",
    "complaints": "complaints_clean.csv",
    "whatsapp_events": "whatsapp_events_clean.csv",
    "sms_events": "sms_events_clean.csv",
    "account_status_history": "account_status_history_clean.csv",
    "agent_sessions": "agent_sessions_clean.csv",
    "agents": "agents_clean.csv",
    "vendor_telephony": "vendor_telephony_clean.csv",
    "call_dispositions": "call_dispositions_clean.csv",
}

conn = sqlite3.connect(DB_PATH)

for table_name, filename in FILES.items():
    file_path = PROCESSED_DIR / filename

    print(f"Loading {table_name}...")

    df = pd.read_csv(file_path)

    df.to_sql(
        table_name,
        conn,
        if_exists="replace",
        index=False
    )

    print(f"  {len(df):,} rows loaded")

conn.close()

print("\nDatabase created:")
print(DB_PATH)
