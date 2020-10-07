from dataclasses import dataclass, field

INSTALL = 'INSTALL'
DEV = 'DEV'


@dataclass
class Installer:
    name: str
    env: str = None
    channels: list = field(default_factory=list)


PIP = Installer(name='PIP')


@dataclass
class Dependency:
    name: str
    version: str = ''
    url: str = None
    scope: str = DEV
    installer: Installer = PIP
    desc: str = None


def get_install_required(libs):
    return _find_dep_for_scope(libs, INSTALL)


def get_test_required(libs):
    return _find_dep_for_scope(libs, DEV)


def _find_dep_for_scope(libs, scope):
    ret = []
    for lib in libs:
        if lib.name.lower() == 'python':
            continue
        if lib.scope == scope:
            # https://stackoverflow.com/a/54794506/7898913
            if lib.url:
                ret.append(f'{lib.name} @ {lib.url}')
            else:
                ret.append(f'{lib.name}{lib.version}')

    print(f'{scope} dependencies: {ret}')
    return ret


def get_python_requires(libs):
    for lib in libs:
        if lib.name.lower() == 'python':
            print('use python version: ', lib.version)
            return lib.version

    return None
