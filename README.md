# scripts

## `scripts` is a collection of scripts that I use to make my life easier.

## Bash

### image-converter.sh

This script converts all images in a folder to another file format.
Usage example: `bash image-converter.sh --dir ~/test --in png --out webp`
Defaults to current folder, and png -> webp

#### Install

First you need to install squoosh by running
```bash
npm i -g @squoosh/cli
```

#### Node version
If you encounter an error with INVALID URL.
Try using node 16.

```bash
nvm use 16
```

### check-package-manager.sh

This script will check which package manager is used in the current folder/project and return it.
Best used combined with an alias, like `alias pm='bash ~/scripts/check-package-manager.sh'` in your `.bashrc` or `.zshrc`.

Usage example: `bash check-package-manager.sh`
Output: `yarn` || `npm` || `pnpm` || `No package manager found`

## Python

### remove-primary-keys.py

Converts a dictionary object into an array of objects, and removes the primary key from the object.
Usage example: `python3 remove-primary-keys.py -i /test/currencies.json -o output.json`

## License

[MIT](LICENSE)
