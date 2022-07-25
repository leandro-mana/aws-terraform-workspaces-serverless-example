"""
This Module has the definition for the Secret App

It consist on a AWS Lambda Handler that will return a Secret
based on API Parameter invocation.
"""
# import json
import logging
from boto3 import client
from aws_lambda_powertools.utilities.typing import LambdaContext


LOG = logging.getLogger()
LOG.setLevel(logging.INFO)
SECRETS_CLIENT = client('secretsmanager')


def __get_secrets(secret_id: str, secret_type='SecretString') -> str:
    """
    This internal function returns a secret from Secrets Manager

    params:
        secret_id: The Secret Name
        secret_type: The supported secret string
    """
    try:
        response = SECRETS_CLIENT.get_secret_value(SecretId=secret_id)
        secret = response.get(secret_type)
        if not secret:
            raise ValueError(f'SecretType: {secret_type} Not Found')

    except SECRETS_CLIENT.exceptions.ResourceNotFoundException as exc:
        raise ValueError('Resource Not Found Exception') from exc

    else:
        return secret


def lambda_handler(event: dict, context: LambdaContext) -> dict:
    """
    Lambda Handler definition that get Secrets Values

    Params:
        event: Lambda Event
        context: Lambda Context
    """
    LOG.info('## Context function_name: %s',
             context.function_name if context else 'no-context')

    LOG.info('## Event: %s', event)

    try:
        query_string_params = event.get('queryStringParameters')
        secret_name = query_string_params.get('Secret') if query_string_params else None
        if not secret_name:
            raise ValueError('No Secret Name Provided')

        secret = __get_secrets(secret_id=secret_name)

    except ValueError as error:
        LOG.error(error)
        err_msg = {
            'statusCode': 404,
            'headers': {
                'Content-Type': 'application/json',
            },
            'body': 'EXCEPTION RAISED'
        }

        return err_msg

    else:
        LOG.info('Message Sent to API-GW')
        msg = {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
            },
            'body': secret
        }

        return msg
