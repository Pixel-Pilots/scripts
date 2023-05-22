# scripts

## `scripts` is a collection of scripts that I use to make my life easier.

## Bash

### image-converter.sh

This script converts all images in a folder to another file format.
Usage example: `bash image-converter.sh --dir ~/test --out avif`
Defaults to current folder, and png -> webp

## Python

### remove-primary-keys.py

Converts a dictionary object into an array of objects, and removes the primary key from the object.
Usage example: `python3 remove-primary-keys.py -i /test/currencies.json -o output.json`
