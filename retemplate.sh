#!/bin/bash

for i in *.template; do
   untmpName=${i/.template/}
   echo retemplating $untmpName
   cp $untmpName $i
done