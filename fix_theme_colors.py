#!/usr/bin/env python3
"""
Script to fix hardcoded colors in Flutter files to use theme-aware colors
"""

import re
import os

# Files to process
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
    """Fix colors in a single file"""
    if not os.path.exists(file_path):
        print(f"File not found: {file_path}")
        return False

    with open(file_path, 'r') as f:
        content = f.read()

    original_content = content

    # Add import if not present and file uses AppColors
    if 'AppColors' in content and 'theme_extensions.dart' not in content:
        # Find where to insert import (after app_colors import)
        if "import '../../../../app/theme/app_colors.dart';" in content:
            content = content.replace(
                "import '../../../../app/theme/app_colors.dart';",
                "import '../../../../app/theme/app_colors.dart';\nimport '../../../../app/theme/theme_extensions.dart';"
            )
        elif "import '../../../app/theme/app_colors.dart';" in content:
            content = content.replace(
                "import '../../../app/theme/app_colors.dart';",
                "import '../../../app/theme/app_colors.dart';\nimport '../../../app/theme/theme_extensions.dart';"
            )

    # Replace backgroundColor: AppColors.background
    content = content.replace(
        'backgroundColor: AppColors.background',
        '// backgroundColor: context.backgroundColor // Using theme default'
    )

    # Replace specific const color usages with non-const theme-aware ones
    lines = content.split('\n')
    new_lines = []
    for line in lines:
        new_line = line
        # Handle cases where color is in a const TextStyle
        if 'color: AppColors.textPrimary' in line and 'const' not in line:
            new_line = line.replace('color: AppColors.textPrimary', 'color: context.textPrimary')
        elif 'color: AppColors.textSecondary' in line and 'const' not in line:
            new_line = line.replace('color: AppColors.textSecondary', 'color: context.textSecondary')
        elif 'fillColor: AppColors.inputFill' in line:
            new_line = line.replace('fillColor: AppColors.inputFill', 'fillColor: context.inputFillColor')

        new_lines.append(new_line)

    content = '\n'.join(new_lines)

    if content != original_content:
        with open(file_path, 'w') as f:
            f.write(content)
        print(f"✓ Fixed: {file_path}")
        return True
    else:
        print(f"- No changes: {file_path}")
        return False

def main():
    """Main function"""
    print("Fixing theme colors in Flutter files...")
    print("=" * 60)

    fixed_count = 0
    for file_path in files_to_fix:
        if fix_file(file_path):
            fixed_count += 1

    print("=" * 60)
    print(f"Fixed {fixed_count}/{len(files_to_fix)} files")
    print("\nPlease review the changes and test the app!")

if __name__ == '__main__':
    main()
