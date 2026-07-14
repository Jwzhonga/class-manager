"""Debug Excel parsing"""
import sys
sys.path.insert(0, '.')
from app import app, db, Schedule, ScheduleImage, DAY_NAMES, MAX_PERIOD
import openpyxl, re

file_path = 'static/uploads/schedule_excel_20260713101351_3450.xlsx'

# Read all rows
wb = openpyxl.load_workbook(file_path, read_only=True, data_only=True)
print(f'Sheets: {wb.sheetnames}')
ws = wb['24新能源班']
print(f'Sheet: 24新能源班, rows={ws.max_row}, cols={ws.max_column}')

print('\n=== ALL CELLS ===')
for r, row in enumerate(ws.iter_rows(values_only=True), 1):
    vals = [str(c).strip() if c is not None else '' for c in row]
    print(f'R{r}: {vals}')

wb.close()
