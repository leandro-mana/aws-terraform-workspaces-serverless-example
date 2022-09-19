"""
WIP
"""
import logging
from botocore.exceptions import ClientError
from aws_lambda_powertools.utilities.typing import LambdaContext
from utils.secrets_manager import get_secret


LOG = logging.getLogger()
LOG.setLevel(logging.INFO)


def lambda_handler(event: dict, context: LambdaContext) -> dict:
    """
    Lambda Handler definition

    Params:
        event: Lambda Event
        context: Lambda Context
    """
    LOG.info('## Context function_name: %s',
             context.function_name if context else 'no-context')

    LOG.info('## Event: %s', event)

    return
