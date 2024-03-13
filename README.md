# tf-modules

A collection of tofu modules that I wrote. Some of
these modules are superficial. Others form a meaningful
a group of tofu resources and datasources into
a logical and coherent grouping.

## Install Dependencies

Install whichever dependencies are missing for the CI process and using opentofu.
Installation instructions below are targetting ubuntu 22.04.

```bash
# Install asdf to install npm modules
wget -q https://raw.githubusercontent.com/stephenmoloney/localbox/master/bin/install/asdf.sh
chmod +x ./asdf.sh && ./asdf.sh
export ASDF_DIR="${HOME}/.asdf" && source "${HOME}/.asdf/asdf.sh"
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf install nodejs 16.14.2
asdf global nodejs 16.14.2
asdf plugin add yarn
asdf install yarn 1.22.18
asdf global yarn 1.22.18

# Install npm modules
yarn install --frozen-lockfile --ignore-optional

# Install opentofu
asdf plugin add opentofu https://github.com/virtualroot/asdf-opentofu.git
asdf install opentofu latest
asdf global opentofu latest
```

## CI Tasks

| Command       | Description         |
| ------------- | ------------------- |
| `make format` | Format the codebase |
| `make lint`   | Lint the codebase   |

## Examples using the modules

See `./examples`

## Licence

[MIT](https://choosealicense.com/licenses/mit/)
