from urllib.parse import urljoin

import pytest
import requests


@pytest.mark.timeout(15)
class TestSwapi:
    @classmethod
    def setup_class(cls):
        cls.swapi_people = 'https://swapi.co/api/people/'
        cls.global_data = {}
        cls.character_insert_data = {'name': 'Stanley Tweedle',
                                     'height': '152',
                                     'mass': '72',
                                     'hair_color': 'Black',
                                     'skin_color': 'fair',
                                     'eye_color': 'brown',
                                     'birth_year': '19BBY',
                                     'gender': 'male',
                                     'homeworld': 'https://swapi.co/api/planets/25/',
                                     'films': [],
                                     'species': ['https://swapi.co/api/species/1/'],
                                     'vehicles': ['https://swapi.co/api/vehicles/13/', 'https://swapi.co/api/vehicles/28/'],
                                     'starships': ['https://swapi.co/api/starships/14/', 'https://swapi.co/api/starships/23/']}

    def test_character_count_and_links_to_next(self):
        resp = requests.get(self.swapi_people)
        assert resp.status_code == requests.codes.ok

        character_data = resp.json()
        assert 'next' in character_data
        assert character_data['next'] is not None

        assert 'count' in character_data
        assert character_data['count'] is not None

    def test_query_character_info(self):
        resp = requests.get(urljoin(self.swapi_people, '1'))
        assert resp.status_code == requests.codes.ok
        character_info = resp.json()

        assert character_info['name'] == 'Luke Skywalker'
        assert character_info['height'] == '172'

        self.global_data['character_info'] = character_info

    def test_character_update(self):
        assert 'character_info' in self.global_data
        assert self.global_data['character_info']

        character_info = self.global_data['character_info']

        assert character_info['name'] == 'Luke Skywalker'
        assert character_info['height'] == '172'

        character_info['name'] = 'R2-D2'
        character_info['height'] = '96'

        resp = requests.put(urljoin(self.swapi_people, '1'), data=character_info)
        assert resp.status_code == requests.codes.method_not_allowed

    def test_character_insert(self):
        resp = requests.post(self.swapi_people, data=self.character_insert_data)
        assert resp.status_code == requests.codes.method_not_allowed

    def test_get_multiple_characters(self):
        character_list = []
        next = urljoin(self.swapi_people, '?page=1')

        # Since all characters are divided into pages by ten we collect them all with while loop
        while next:
            resp = requests.get(next)
            assert resp.status_code == requests.codes.ok

            data = resp.json()
            results = data['results']
            assert len(results) > 0

            character_list += results
            next = data['next']

        # Remove duplicates with set function by character name
        character_names = set(i['name'] for i in character_list)

        assert len(character_list) == len(character_names)
