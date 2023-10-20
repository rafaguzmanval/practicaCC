

class RespuestaHTTP{

  int status;
  String body;

  RespuestaHTTP(this.status,this.body);


  @override
  String toString(){
    return "Status: $status , Body: $body";
  }

}