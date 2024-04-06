# multicloud-iam example

The general steps to deploy the module are outlined below.

## Create the azure storage container as terraform backend

The first step is to create a opentofu backend. There are many
providers of object storage solutions that can act as a storage
backend. Initialize the backend.

To use Azure Blob Storage, checkout either of the resources linked:

- [creating_az_tf_backend.md](../../docs/creating_az_tf_backend.md)
- <https://stephenmoloney.com/blog/creating-an-opentofu-backend/>

```bash
make init_az_backend
```

## Set the terraform variables

The variables in `terraform.auto.tfvars.json` need to be set.
The file `terraform.auto.tfvars.enc.json` can be used as a template.
In fact, the entire configuration is determined by filling in the
`terraform.auto.tfvars.json` file and it's a good example of the
benefits of terraform. `terraform.auto.tfvars.json` must always be
ignored by source control (git).

## Plan the resources

```bash
make plan
```

## Create the resources

```bash
make apply
```
