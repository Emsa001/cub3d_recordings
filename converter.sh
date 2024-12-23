#!/bin/bash

# Loop through all .mp4 files in the current directory
for file in *.mp4; do
    # Extract the filename without the extension
    filename="${file%.*}"
    
    # Generate a custom palette for better GIF quality
    ffmpeg -i "$file" -vf "fps=20,scale=800:-1:flags=lanczos,palettegen" "${filename}_palette.png"
    
    # Use the palette to create the GIF
    ffmpeg -i "$file" -i "${filename}_palette.png" -lavfi "fps=20,scale=800:-1:flags=lanczos [x]; [x][1:v] paletteuse" "${filename}.gif"
    
    # Remove the temporary palette file
    rm -f "${filename}_palette.png"
    
    echo "Converted $file to ${filename}.gif"
done

echo "All .mp4 files have been converted to .gif!"