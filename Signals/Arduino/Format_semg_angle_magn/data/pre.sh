#!/bin/bash

for f in *.txt
do
    mv "$f" "raw_$f"
done
