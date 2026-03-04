# Coding Standards — Ignition 8.3

## Jython/Python Scripts
- Use type hints in docstrings (Jython does not support annotations)
- Functions longer than 20 lines should be broken down
- Logging via system.util.getLogger(), never print()
- Try/except on every DB or external API call
- Imports at the top of the script, sorted alphabetically

## Perspective Views
- Reusable components as embedded views
- Props with defined types and sensible defaults
- Styles via style classes, never inline when possible
- Descriptive component names: lbl_temperature, btn_confirm

## Named Queries
- Always parameterized (never concatenate SQL)
- Name parameters in snake_case
- Return: always specify columns, never SELECT *
- Comment at the top explaining the purpose

## Tags
- UDTs for repetitive equipment
- Alarms configured in the UDT, not on individual tags
- Names without spaces, use CamelCase or snake_case consistently
- Tag paths maximum 3 levels deep
