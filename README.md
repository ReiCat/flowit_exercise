# Flowit test exercise

The tests are run on **Python 3.6.7**.<br>
Both user stories were tested using RobotFramework with SeleniumLibrary
and pytest testing framework.

## Installation


```sh
pip install -r requirements.txt
```

## Robot test start

* The provided in exercise website was tested using [geckodriver](https://github.com/mozilla/geckodriver/releases).

```sh
robot tests/robot/register_eshop_user.robot
```

## Pytest test start

```sh
pytest tests/test_swapi.py --html=pytest-report.html --self-contained-html
```
