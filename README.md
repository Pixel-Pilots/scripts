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

### github-ssh-toggle.sh

If you, like me, need to change the default github ssh-keys when jumping between projects, this script is for you.

Maybe you have a config file that looks something like this

```bash
Host github-personal
    HostName github.com
    IdentityFile ~/.ssh/id_github
    IdentitiesOnly yes

Host github.com github-work
    HostName github.com
    IdentityFile ~/.ssh/id_github-work
    IdentitiesOnly yes
```

and need to toggle which one has the github.com host alias.

#### Prerequisites

1. Add a `.env` file containing the states you want to toggle between, examples provided in `.env.example`
2. Remove the current github key setup from the config file

#### Running

1. `chmod +x github-ssh-toggle.sh` (Only needed once after cloning)
2. `sh github-ssh-toggle.sh`

After running you should see a newly created backup file in your `~/.ssh` folder. And your config file should now be updated at the bottom with something like this:

```bash
# --- managed by github-ssh-toggle !! ALWAYS KEEP THIS BLOCK IN THE BOTTOM OF THE FILE !! ---
Host github.com
    HostName github.com
    IdentityFile ~/.ssh/id_github
    IdentitiesOnly yes

Host github-work
    HostName github.com
    IdentityFile ~/.ssh/id_github-work
    IdentitiesOnly yes
```

Everytime you run the script, the config will be toggled between the 2 states defined in your `.env` file.

!!! IMPORTANT that you keep this content in the bottom of the config file at all times, and that you keep the comment `# --- managed by github-ssh-toggle !! ALWAYS KEEP THIS BLOCK IN THE BOTTOM OF THE FILE !! ---` for the script to use. Otherwise you might lose content.

## Python

### remove-primary-keys.py

Converts a dictionary object into an array of objects, and removes the primary key from the object.
Usage example: `python3 remove-primary-keys.py -i /test/currencies.json -o output.json`

## License

[MIT](LICENSE)
