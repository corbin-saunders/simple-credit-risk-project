import pandas as pd
import sqlite3

df = pd.read_csv('data/loan.csv', low_memory=False)

conn = sqlite3.connect('data/loans.db')
df.to_sql('loans', conn, if_exists='replace', index=False)
conn.close()

print("Done — loans.db created with", len(df), "rows and", len(df.columns), "columns")