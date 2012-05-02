#!/bin/sh

find app/ lib/ spec/ | grep -e '\.rb$' -e '\.js$' -e '\.scss$' -e '\.erb$' | xargs wc -l
