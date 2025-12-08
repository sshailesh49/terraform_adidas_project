import shutil
import os

# Ensure previous zip is gone
if os.path.exists('fpdf-layer.zip'):
    os.remove('fpdf-layer.zip')

# output_filename (without extension), format, root_dir, base_dir
# This will create fpdf-layer.zip containing 'python/...'
shutil.make_archive('fpdf-layer', 'zip', root_dir='.', base_dir='python')
print("Zip created successfully.")
