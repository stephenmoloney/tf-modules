# az-resource-groups example

The general steps to deploy the module are outlined below.

## Create the azure storage container as terraform backend

The first step is to create a opentofu backend. There are many
providers of object storage solutions that can act as a storage
backend. Initialize the backend.

To use Azure Blob Storage, checkout either of the resources linked:

- <../../docs/creating_az_tf_backend.md>
- <https://stephenmoloney.com/blog/creating-an-opentofu-backend/>

```bash
make init_az_backend
```

## Plan the resources

```bash
make plan
```

## Create the resources

```bash
make apply
```
