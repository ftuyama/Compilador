cd ..

echo Chamando Flex
flex Compilador/_Lab05.l

echo Chamando Yacc
yacc -v Compilador/_Lab05.y

echo Compilando arquivo
gcc y.tab.c main.c yyerror.c -o _Lab05 -lfl

echo Compilando programa

./_Lab05  < Compilador/_Lab05Prog.dat > Compilador/_Lab05ProgOutput.dat

	echo Testes - Declaracao de Variaveis
	./_Lab05 < Compilador/Bench/BenchDeclaracao.dat > Compilador/Bench/oBenchDeclaracao.dat

	echo Testes - Funcao Principal
	./_Lab05 < Compilador/Bench/BenchPrincipal.dat > Compilador/Bench/oBenchPrincipal.dat

	echo Testes - Variaveis Indexadas 
	./_Lab05 < Compilador/Bench/BenchIndexada.dat > Compilador/Bench/oBenchIndexada.dat

	echo Testes - Compatibilidade
	./_Lab05 < Compilador/Bench/BenchCompatibilidade.dat > Compilador/Bench/oBenchCompatibilidade.dat

	echo Testes - Comando Para
	./_Lab05 < Compilador/Bench/BenchPara.dat > Compilador/Bench/oBenchPara.dat

	echo Testes - CallFuncao
	./_Lab05 < Compilador/Bench/BenchCallFunc.dat > Compilador/Bench/oBenchCallFunc.dat

	echo Testes - RetornoFuncao
	./_Lab05 < Compilador/Bench/BenchRetornoFunc.dat > Compilador/Bench/oBenchRetornoFunc.dat

echo Completo