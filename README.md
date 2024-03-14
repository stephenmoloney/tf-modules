# tf-modules

A collection of tofu modules that I wrote. Some of
these modules are superficial. Others form a meaningful
a group of tofu resources and datasources into
a logical and coherent grouping.

## Install Dependencies

Install whichever dependencies are missing for the CI process and using opentofu.
Installation instructions below are targetting ubuntu 22.04.

See `./ci/functions_init.sh` and `Makefile`.

If the required dependencies are already installed, this step
can be skipped.

```bash
sudo apt-get install -y build-essential
make install_deps
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
