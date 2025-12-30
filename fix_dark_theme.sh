#!/bin/bash

# Script to fix dark theme colors across all Dart files

# Find all Dart files in features directory
find lib/features -name "*.dart" -type f | while read file; do
    echo "Processing: $file"

    # Add import for theme extensions if not present and file contains AppColors
    if grep -q "AppColors\." "$file" && ! grep -q "theme_extensions.dart" "$file"; then
        # Find the import section and add our import
        sed -i '' "/^import.*app_colors.dart/a\\
import '../../../../app/theme/theme_extensions.dart';\\
" "$file" 2>/dev/null || \
        sed -i '' "/^import.*app_colors.dart/a\\
import '../../../app/theme/theme_extensions.dart';\\
" "$file" 2>/dev/null || \
        sed -i '' "/^import.*app_colors.dart/a\\
import '../../app/theme/theme_extensions.dart';\\
" "$file" 2>/dev/null
    fi
done

echo "Done! Please review the changes."
