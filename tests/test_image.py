import pytest
import subprocess
import testinfra


# scope='session' uses the same container for all the tests;
# scope='function' uses a new container per test function.
@pytest.fixture(scope='session')
def host(request):
    # build local ./Dockerfile
    subprocess.check_call(['docker', 'build', '-t', 'fongshway/pipenv-test', '.'])
    # run a container
    docker_id = subprocess.check_output(
        ['docker', 'run', '-d', 'fongshway/pipenv-test']).decode().strip()
    # return a testinfra connection to the container
    yield testinfra.get_host("docker://" + docker_id)
    # at the end of the test suite, destroy the container
    subprocess.check_call(['docker', 'rm', '-f', docker_id])


def test_pipenv_is_present(host):
    assert host.file("/usr/bin/vcsh").exists
