#!/bin/bash

# Loop through all .mp4 files in the current directory
for file in *.mp4; do
    # Extract the filename without the extension
    filename="${file%.*}"
    
    # Step 1: Generate a custom palette for better GIF quality
    ffmpeg -i "$file" -vf "fps=15,scale=800:-1:flags=lanczos,palettegen" "${filename}_palette.png"
    
    # Step 2: Use the palette to create a GIF, limiting colors and dithering
    ffmpeg -i "$file" -i "${filename}_palette.png" -lavfi "fps=15,scale=800:-1:flags=lanczos,paletteuse=dither=bayer:bayer_scale=3" "${filename}.gif"
    
    # Step 3: Optimize the GIF using gifsicle (optional but highly recommended)
    gifsicle --optimize=3 --colors 128 "${filename}.gif" > "${filename}_optimized.gif"
    
    # Replace the original GIF with the optimized one
    mv "${filename}_optimized.gif" "${filename}.gif"
    
    # Remove the temporary palette file
    rm -f "${filename}_palette.png"
    
    echo "Converted and optimized $file to ${filename}.gif"
done

echo "All .mp4 files have been converted to optimized .gif!"