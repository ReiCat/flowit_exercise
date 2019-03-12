import random

from faker import Faker

__all__ = ['get_random_number', 'get_first_name', 'get_last_name',
           'get_email', 'get_password', 'get_company', 'get_address',
           'get_city', 'get_zipcode']


fake = Faker()


def get_random_number(max):
    return random.randint(1, int(max))


def get_first_name():
    return fake.first_name()


def get_last_name():
    return fake.first_name()


def get_email():
    return fake.email()


def get_password():
    return fake.password()


def get_company():
    return fake.company()


def get_address():
    return fake.address()


def get_city():
    return fake.city()


def get_zipcode():
    return fake.zipcode()
