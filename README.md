# youtube-transcript

## venv

[Install packages in a virtual environment using pip and venv - Python Packaging User Guide](https://packaging.python.org/en/latest/guides/installing-using-pip-and-virtual-environments/)

```sh
python3 -m venv .venv
```

```sh
source .venv/bin/activate
```

```sh
deactivate
```

## YouTube Data API

```sh
pip install --upgrade google-api-python-client
pip install --upgrade google-auth-oauthlib google-auth-httplib2
```

## google-api-python-client

```sh
pip install --upgrade google-api-python-client
```

## Run

```bash
pip install -r requirements.txt
```

Run locally

```bash
python3 lambda/lambda_function.py
```

## Terraform

https://developer.hashicorp.com/terraform/tutorials/aws-get-started

```bash
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
```

terraform.tfvars

```hcl
aws_region =
aws_account_id =
terraform_state_bucket =
youtube_data_api_v3_key =
youtube_playlist_id =
```

To make access keys more secure;

- https://docs.aws.amazon.com/prescriptive-guidance/latest/terraform-aws-provider-best-practices/security.html
- https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services

Create an S3 bucket to store terraform.tfstate. To run `terraform init` locally, use `-backend-config`.

```
$ terraform init -migrate-state \
                 -backend-config="bucket={{BUKCET NAME}}" \
                 -backend-config="key=terraform.tfstate" \
                 -backend-config="region={{AWS_REGION}}"
```

```bash
terraform plan
terraform validate
terraform apply
```

If AWS_SESSION_TOKEN is set, unset it before running terraform init to avoid errors.

```
$ unset AWS_SESSION_TOKEN
```
