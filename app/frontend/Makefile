
test: testsDocker

INITServer:
	cd ../app/backend &&  nohup node app.js &
	 
tests: 
	cd ../app/frontend && flutter test test/test_unidad1.dart > test_result.txt  && flutter test test/test_unidad2.dart >> test_result.txt && flutter test test/test_unidad3.dart >> test_result.txt

testsDocker:
	flutter pub upgrade
	flutter test test/test_unidad1.dart  && flutter test test/test_unidad2.dart && flutter test test/test_unidad3.dart


KILLserver:
	pkill node