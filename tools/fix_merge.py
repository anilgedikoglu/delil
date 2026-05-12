#!/usr/bin/env python3
"""Fix the bad merge: remove new cards from allCategories, insert them into allDeliller."""

DATA_PATH = r"C:\src\delil\lib\data\delil_data.dart"
GEN_PATH  = r"C:\src\delil\tools\new_cards_generated.dart"

# Read generated cards (skip first 3 lines: 2 comments + blank)
with open(GEN_PATH, encoding="utf-8") as f:
    gen_lines = f.readlines()

# The actual card content to insert (starting from the category comment)
new_cards_content = "".join(gen_lines[3:])

# Read current (messed up) file
with open(DATA_PATH, encoding="utf-8") as f:
    data = f.read()

# Find the closing ]; of allDeliller
# allDeliller starts with "const List<Delil> allDeliller = ["
# We need to find its closing ];
# Strategy: find "const List<Delil> allDeliller = [" and then find the matching "];

start_marker = "const List<Delil> allDeliller = ["
start_idx = data.find(start_marker)
if start_idx == -1:
    print("ERROR: Could not find allDeliller start")
    exit(1)

# From start_idx, find the first "];" after the list opens
# Count bracket depth to find the matching ]
# Actually, the list is at top level so the first "\n];" after the list should work
# But safer: find the position of allDeliller's ]; by looking for "\n];\n\nList<Delil>"
# or "\n];\n\nlist<Delil>"

# Look for the pattern: the ]; is followed by helper functions
# The helpers start with "\nList<Delil> getRecommended"
helper_marker = "\nList<Delil> getRecommended()"
helper_idx = data.find(helper_marker)
if helper_idx == -1:
    print("ERROR: Could not find getRecommended helper")
    exit(1)

# The ]; closing allDeliller should be just before helper_idx
# Let's find the ]; before helper_marker
pre_helper = data[:helper_idx]
alldeliller_close = pre_helper.rfind("\n];")
if alldeliller_close == -1:
    print("ERROR: Could not find allDeliller closing ];")
    exit(1)

print(f"allDeliller closes at char {alldeliller_close}")
print(f"Context: '{data[alldeliller_close-30:alldeliller_close+10]}'")

# Now find allCategories
allcat_marker = "\nList<String> get allCategories => ["
allcat_idx = data.find(allcat_marker)
if allcat_idx == -1:
    print("ERROR: Could not find allCategories")
    exit(1)

print(f"allCategories at char {allcat_idx}")

# The allCategories should look like:
# List<String> get allCategories => [
#   _felsefe, ..., _tarih,
#   // ─── MATEMATIKSEL... (wrongly inserted cards)
#   ...
# ];
# We need to cut it back to just the category strings

# Find the correct end of allCategories (the ]; after the category list)
# The categories are: _felsefe, ..., _tarih,
# Then comes the incorrectly inserted content, then ];
allcat_close = data.find("\n];", allcat_idx)
if allcat_close == -1:
    print("ERROR: Could not find allCategories closing ];")
    exit(1)

print(f"allCategories closes at char {allcat_close}")

# The correct allCategories content should be just the category strings
# Find the line with "_matematik, _biyoloji" to know where it ends
correct_allcat = "\nList<String> get allCategories => [\n  _felsefe, _bilim, _risale, _fitrat, _itiraz, _kainat,\n  _matematik, _biyoloji, _fizik, _astronomi, _estetik, _tarih,\n];"

# Rebuild the file:
# 1. Everything up to and including allDeliller close ];
# 2. Insert new cards before allDeliller ];
# 3. Helper functions (getRecommended, getByCategory)
# 4. Correct allCategories
# 5. search function

# Part 1: up to allDeliller's end content (before \n];)
part_before_alldeliller_close = data[:alldeliller_close]
# Part 3 onwards: everything from helper_idx to allcat_idx
part_helpers = data[helper_idx:allcat_idx]
# Part 5: search function (after allCategories closing ])
part_after_allcat = data[allcat_close + len("\n];"):]

new_data = (
    part_before_alldeliller_close
    + "\n"
    + new_cards_content.rstrip()
    + "\n\n];"
    + part_helpers
    + correct_allcat
    + part_after_allcat
)

with open(DATA_PATH, "w", encoding="utf-8") as f:
    f.write(new_data)

line_count = new_data.count("\n")
print(f"\nFixed! Total: {len(new_data)} chars, ~{line_count} lines")

# Verify structure
print("\nVerifying structure:")
for marker in ["const List<Delil> allDeliller = [",
               "List<Delil> getRecommended()",
               "List<String> get allCategories",
               "List<Delil> search("]:
    idx = new_data.find(marker)
    line = new_data[:idx].count("\n") + 1 if idx != -1 else -1
    print(f"  {marker[:40]:40s} -> line {line}")
