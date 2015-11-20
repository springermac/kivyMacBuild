#!/bin/bash

echo "----Checking for already running Virtual Environment----"
if [[ "$VIRTUAL_ENV" != "" ]]; then
    echo "Deactivitate the existing virtual enviroment before running this script."
    echo "This can be done with the \"deactivate\" command."
    exit 53 
fi

rm -rf venv

echo "----Checking for Pip----"
command -v pip 2>&1 >/dev/null
if [ $? != 0 ]; then
    echo "Pip not available, you should be prompted for install:"
    sudo easy_install pip
    if [ $? != 0 ]; then
        echo "FAILURE: Pip failed installing"
        WILL_FAIL=11
        FAIL_REASONS="$FAIL_REASONS\nFAILURE: Pip failed installing"
    fi
fi


echo "----Checking for virtualenv----"
command -v virtualenv 2>&1 >/dev/null
if [ $? != 0 ]; then
    echo "virtualenv not available, you should be prompted for install:"
    sudo pip install virtualenv
    if [ $? != 0 ]; then
        echo "FAILURE: virtualenv failed installing"
        WILL_FAIL=12
        FAIL_REASONS="$FAIL_REASONS\nFAILURE: virtualenv failed installing"
    fi
fi

echo "----Checking for and create a virtual environment----"
if [ ! -d "venv" ]; then
        virtualenv venv
    if [ $? != 0 ]; then
        echo "Virutal environment failed"
        exit
    fi
fi

source venv/bin/activate

if [[ "$VIRTUAL_ENV" == "" ]]; then
    echo "FAILURE: Virutal environment creation failed"
    exit 666
fi

echo "----Setting up virtual environment----"
SETUP_TMP="setup_tmp"
WILL_FAIL=0
FAIL_REASONS=""
export CFLAGS=-Qunused-arguments
export CPPFLAGS=-Qunused-arguments

echo "--------Setting up cython----"
python -c"import cython" 2>&1 >/dev/null
if [ $? != 0 ]; then
    echo "cython not available adding"
    pip install -U cython==0.21.2
    if [ $? != 0 ]; then
        echo "FAILURE: cython failed installing"
        WILL_FAIL=1
        FAIL_REASONS="$FAIL_REASONS\nFAILURE: cython failed installing"
    fi
fi

echo "--------Setting up pygame----"
python -c"import pygame" 2>&1 >/dev/null
if [ $? != 0 ]; then
    echo "pygame not available adding"
    pip install hg+http://bitbucket.org/pygame/pygame
    if [ $? != 0 ]; then
        echo "FAILURE: pygame failed installing"
        WILL_FAIL=1
        FAIL_REASONS="$FAIL_REASONS\nFAILURE: pygame failed installing"
    fi
fi

echo "--------Setting up kivy----"
python -c"import kivy" 2>&1 >/dev/null
if [ $? != 0 ]; then
    echo "kivy not available adding"
    git clone http://github.com/kivy/kivy
    cd kivy
    make
    if [ $? != 0 ]; then
        echo "FAILURE: kivy failed makeing"
        WILL_FAIL=1
        FAIL_REASONS="$FAIL_REASONS\nFAILURE: kivy failed making"
    fi
    make install
    if [ $? != 0 ]; then
        echo "FAILURE: kivy failed installing"
        WILL_FAIL=1
        FAIL_REASONS="$FAIL_REASONS\nFAILURE: kivy failed installing"
    fi
fi

echo "--------Setting up pyinstaller----"
python -c"import pyinstaller" 2>&1 >/dev/null
if [ $? != 0 ]; then
    echo "pyinstaller not available adding"
    pip install -U pyinstaller==3.0
    if [ $? != 0 ]; then
        echo "FAILURE: pyinstaller failed installing"
        WILL_FAIL=1
        FAIL_REASONS="$FAIL_REASONS\nFAILURE: pyinstaller failed installing"
    fi
fi

if [ $WILL_FAIL != 0 ]; then
    echo "-----------------------------------"
    echo "Enviroment setup failed. Summery:"
    echo -e $FAIL_REASONS
    exit $WILL_FAIL
fi

echo ""
echo "-----------------------------------"
echo "Enviroment setup complete and seemingly successful."
echo "You can start the enviroment with the command\"source venv/bin/activate\""
