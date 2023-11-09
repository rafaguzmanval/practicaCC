
test: INITServer tests KILLserver

INITServer:
	cd ../app/backend &&  nohup node app.js &
	 
tests: 
	cd ../app/frontend && flutter test test/test_unidad1.dart > test_result.txt  && flutter test test/test_unidad2.dart >> test_result.txt && flutter test test/test_unidad3.dart >> test_result.txt

KILLserver:
	pkill node