echo "Cleaning..."
rm dist/*

echo "Copying resources..."
cp src/boolean/bool_operations.h dist/
cp src/symboltable/symbol_table.h dist/
cp src/symboltable/scope.h dist/

echo "Flex phase..."
flex -o dist/lex.yy.c src/lex/flex-calc.l

echo "Yacc phase..."
yacc -vd -o dist/y.tab.c src/yacc/yacc-calc.y

echo "Compiling..."
gcc -o dist/boolcompiler.out dist/y.tab.c -ly -ll
