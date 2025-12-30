#!/usr/bin/env python3
"""
Script to fix const errors by removing const keyword where context is used
"""

import os
import re

files_to_fix = [
    'lib/features/splash/presentation/pages/splash_page.dart',
    'lib/features/auth/presentation/pages/signup_page.dart',
    'lib/features/dashboard/presentation/pages/found_screen.dart',
    'lib/features/dashboard/presentation/pages/profile_screen.dart',
    'lib/features/dashboard/presentation/pages/home_screen.dart',
    'lib/features/item/presentation/pages/my_items_page.dart',
    'lib/features/item/presentation/pages/item_detail_page.dart',
    'lib/features/item/presentation/pages/report_item_page.dart',
    'lib/features/onboarding/presentation/pages/onboarding_page.dart',
]

def fix_file(file_path):
    """Remove const keyword from widgets using context"""
    if not os.path.exists(file_path):
        return False

    with open(file_path, 'r') as f:
        lines = f.readlines()

    modified = False
    new_lines = []

    for i, line in enumerate(lines):
        new_line = line

        # If line contains context. and has const, remove const
        if 'context.' in line and 'const ' in line:
            # Remove const keyword
            new_line = re.sub(r'\bconst\s+', '', line, count=1)
            if new_line != line:
                modified = True
                print(f"  Line {i+1}: Removed const")

        new_lines.append(new_line)

    if modified:
        with open(file_path, 'w') as f:
            f.writelines(new_lines)
        return True
    return False

def main():
    print("Fixing const errors...")
    print("=" * 60)

    fixed_count = 0
    for file_path in files_to_fix:
        print(f"\nProcessing: {file_path}")
        if fix_file(file_path):
            fixed_count += 1
            print("  ✓ Fixed")
        else:
            print("  - No changes needed")

    print("\n" + "=" * 60)
    print(f"Fixed {fixed_count}/{len(files_to_fix)} files")

if __name__ == '__main__':
    main()
