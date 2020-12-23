#!/usr/bin/env bash

die() { printf $'Error: %s\n' "$*" >&2; exit 1; }

root=$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)
build=${root:?}/build
venv=${root:?}/venv
spack=${root:?}/spack
decaf=${build:?}/Decaf
diy=${build:?}/Diy
qhull=${build:?}/QHull
tess=${build:?}/Tess
henson=${build:?}/Henson
python=$(which python3.6)

[ -f ${root:?}/env.sh ] && . ${root:?}/env.sh

go-spack() {
    if ! [ -d ${spack:?} ]; then
        git clone https://github.com/spack/spack.git ${spack:?} >&2 || die "Could not clone spack"
    fi

    exec ./spack/bin/spack "$@"
}


go-venv() {
    : ${SPACK_ENV:?I need to be run in a Spack environment}
    ! [ "${python#${SPACK_ENV:?}}" = "${python:?}" ] || die "Expected ${python} to start with ${SPACK_ENV}"
    if ! ${python:?} -c 'import virtualenv' &>/dev/null; then
        if ! ${python:?} -c 'import pip' &>/dev/null; then
            if ! ${python:?} -c 'import ensurepip' &>/dev/null; then
                die "Cannot import ensurepip"
            fi
            ${python:?} -m ensurepip || die "Cannot ensurepip"
        fi
        ${python:?} -m pip install --user virtualenv || die "Cannot install virtualenv"
    fi
    if ! [ -d ${venv:?} ]; then
        ${python:?} -m virtualenv -p ${python:?} ${venv:?} || die "Cannot setup virtualenv"
    fi
    ${venv:?}/bin/pip install -r requirements.txt || die "Cannot pip install requirements.txt"
}

go-cmake() {
    : ${SPACK_ENV:?I need to be run in a Spack environment}
    : ${VIRTUAL_ENV:?I need to be run in a Python virtualenv}
	cmake -H"${root:?}" -B"${build:?}" \
		-DCMAKE_CXX_COMPILER=mpicxx \
		-DCMAKE_C_COMPILER=gcc \
		"$@"
}

go-make() {
    : ${SPACK_ENV:?I need to be run in a Spack environment}
    : ${VIRTUAL_ENV:?I need to be run in a Python virtualenv}
	make -C "${build:?}" \
		VERBOSE=1 \
		"$@"
}

go-exec() {
    : ${SPACK_ENV:?I need to be run in a Spack environment}
    : ${VIRTUAL_ENV:?I need to be run in a Python virtualenv}
	export LD_LIBRARY_PATH=${henson:?}/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH:?}}
	export LD_LIBRARY_PATH=${decaf:?}/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH:?}}
	export LD_LIBRARY_PATH=${qhull:?}/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH:?}}
	export LD_LIBRARY_PATH=${tess:?}/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH:?}}
	exec "$@"
}

go-"$@"
