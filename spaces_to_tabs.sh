#!/bin/bash

for f in `find . -name '*.rb'` ; do
  sed -i -e 's/\t/  /g' $f
done
