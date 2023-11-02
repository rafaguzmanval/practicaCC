const sql = require("../bd.js");


function pedirFotoperfil(req,res){
	sql.query("SELECT foto FROM USUARIOS WHERE nombre=?",[req.params.correo],function(err,result){
		if(err || result.length == 0)
		{
			//console.log("correo " + req.params.correo);
			//console.log("fallo al cargar foto " + err);
			res.status(500).send("fallo al cargar foto: perfil inexistente");
		}
		else
		{

			if(result[0]['foto'] == undefined)
			{ 
				//console.log("foto de perfil no encontrada");
				res.status(200).sendFile(process.cwd() +'/sources/anonimo.png');
			}
			else
			{
				//console.log(result[0]['foto']);
				res.status(200).sendFile(process.cwd() + '/users/' + req.params.correo +"/perfil.jpg");
			}
		}
	})
}

module.exports = pedirFotoperfil;
