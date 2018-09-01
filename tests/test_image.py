# pylint: disable=redefined-outer-name,missing-docstring
import subprocess
import pytest
import testinfra


# scope='session' uses the same container for all the tests;
# scope='function' uses a new container per test function.
@pytest.fixture(scope='session')
def host():
    # build local ./Dockerfile
    subprocess.check_call(['docker', 'build', '-t', 'fongshway/pipenv', '.'])
    # run a container
    docker_id = subprocess.check_output(
        ['docker', 'run', '-dt', 'fongshway/pipenv']).decode().strip()
    # return a testinfra connection to the container
    yield testinfra.get_host("docker://" + docker_id)
    # at the end of the test suite, destroy the container
    subprocess.check_call(['docker', 'rm', '-f', docker_id])


def test_pipenv_is_present(host):
    assert host.file("/usr/local/bin/pipenv").exists


def test_python_version(host):
    version = host.check_output("python3 --version").strip()
    assert version == "Python 3.6.5"
