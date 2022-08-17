"""
This Module has the definition for the Secret App

It consist on a AWS Lambda Handler that will return a Secret
based on API Parameter invocation.
"""
import logging
from botocore.exceptions import ClientError
from aws_lambda_powertools.utilities.typing import LambdaContext
from utils.secrets_manager import get_secret


LOG = logging.getLogger()
LOG.setLevel(logging.INFO)


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

        secret = get_secret(secret_name=secret_name)

    except (ClientError, ValueError) as error:
        LOG.error(error)
        err_msg = {
            'statusCode': 404,
            'headers': {
                'Content-Type': 'application/json',
            },
            'body': f'EXCEPTION RAISED: {error}'
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
