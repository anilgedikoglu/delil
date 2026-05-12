#!/usr/bin/env python3
"""Merge new_cards_generated.dart entries into delil_data.dart allDeliller list."""

DATA_PATH = r"C:\src\delil\lib\data\delil_data.dart"
GEN_PATH  = r"C:\src\delil\tools\new_cards_generated.dart"

# Read delil_data.dart
with open(DATA_PATH, encoding="utf-8") as f:
    data = f.read()

# Read generated cards (skip first 3 lines: 2 comments + blank)
with open(GEN_PATH, encoding="utf-8") as f:
    lines = f.readlines()

# Skip first 3 lines (comments + blank line)
new_cards_content = "".join(lines[3:])

# Insert before the closing ]; of allDeliller
# rfind gets the LAST occurrence which is the allDeliller closing ];
insertion_point = data.rfind("\n];")
if insertion_point == -1:
    print("ERROR: could not find closing ];")
    exit(1)

new_data = data[:insertion_point] + "\n" + new_cards_content.rstrip() + "\n" + data[insertion_point:]
with open(DATA_PATH, "w", encoding="utf-8") as f:
    f.write(new_data)

line_count = new_data.count("\n")
print(f"Done! Inserted {len(lines)-3} lines of new cards.")
print(f"Total file: {len(new_data)} chars, ~{line_count} lines")
