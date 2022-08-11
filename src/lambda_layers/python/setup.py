"""
Setup to install in local virtual environment, directory structure
for AWS Lambda, as per documentation:
    - https://docs.aws.amazon.com/lambda/latest/dg/configuration-layers.html
"""
from setuptools import find_packages, setup


setup(
    name='utils',
    version='1.0.0',
    packages=find_packages()
)
