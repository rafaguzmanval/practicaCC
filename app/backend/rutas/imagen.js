const sql = require("../bd.js");

function pedirImagen(req,res){

	//console.log(req.params.correo);


	sql.query("SELECT nombre FROM PUBLICACIONES WHERE id=?",[req.params.foto],function(error,qry){

		var path = process.cwd() + '/users/'+req.params.correo+'/galeria/'+qry[0]['nombre'];
		//res.status(200).sendFile(path);
		res.status(200).download(path);
	})



}

module.exports = pedirImagen;
