"""
This Module defines related functions for AWS Secrets Manager Resource
"""
import base64
import boto3
from botocore.exceptions import ClientError


def get_secret(secret_name: str) -> str:
    """
    This function returns a secret from Secrets Manager

    params:
        secret_name: The Secret Name
    """
    if not secret_name:
        raise ValueError('secret_name Not Provided')

    session = boto3.session.Session()
    client = session.client(service_name='secretsmanager')

    try:
        get_secret_value_response = client.get_secret_value(
            SecretId=secret_name
        )

    except (ClientError, ValueError) as exc:
        raise exc

    else:
        if 'SecretString' in get_secret_value_response:
            secret = get_secret_value_response['SecretString']
        else:
            secret = base64.b64decode(get_secret_value_response['SecretBinary'])

        return secret
