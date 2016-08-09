#!/bin/sh

cd /

echo "Finding source files..."
find $HOME/Code \( \
   -name '*.py' \
-o -name '*.java' \
-o -iname '*.[CH]' \
-o -name '*.cpp' \
-o -name '*.cc' \
-o -name '*.hpp' \
\) -printf '"%p"\n' > $HOME/Code/cscope.files
echo "Done!"

cd - > /dev/null

cd $HOME/Code

echo "Building database..."
cscope -b -q
# -b: just build
# -q: create inverted index
echo "Done!"

cd - > /dev/null
