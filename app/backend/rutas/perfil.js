const sql = require("../bd.js");

function pedirPerfil(req,res){

	var fotoPerfil = process.cwd() + "/sources/anonimo.png";
	var seguidores = [];
	var usuario = req.params.correo;

	sql.query("SELECT nombre,foto FROM USUARIOS WHERE nombre=?",[usuario],function(err,result){
		if(err)
		{
			console.log("fallo al cargar foto " + err);
			res.status(500).send("fallo al cargar foto " + err);
		}
		else if(result.length == 1)
		{
			
			if(result[0]['foto'] == undefined)
			{
				//console.log(result[0]['foto']);
				//console.log("fallo");
				fotoPerfil = process.cwd() + "/sources/anonimo.png"
			}
			else
			{
				//console.log(result[0]['foto']);
				fotoPerfil = process.cwd() + "/users/"+ usuario +"/perfil.jpg"
			}

			usuario = result[0]['nombre']

			sql.query("SELECT usuario1 FROM SIGUE WHERE usuario2=?", [usuario] , function(err,result){
				if(err)
				{
					console.log("fall " + err);
					res.status(500).send("fallo " + err);
				}
				else
				{
					seguidores = result;
				}
			})
		
			sql.query("SELECT nombre,PUBLICACIONES.id,tipo,PRODUCTO.precio FROM PUBLICACIONES INNER JOIN USUARIOPUBLICACION ON PUBLICACIONES.id=USUARIOPUBLICACION.id LEFT JOIN PRODUCTO ON PUBLICACIONES.id=PRODUCTO.idPublicacion WHERE usuario=? ORDER BY id DESC",
			[req.params.correo],
			(err,res1,fields) => {
		
				if(err)
				{
					console.log("error " , err);
					res.status(500).send("error " + err);
					return;
				}
		
				//console.log(["fotico",res1]);
				res.status(200).send({"usuario": usuario,"fotoPerfil":fotoPerfil,'publicaciones':res1,'seguidores':seguidores});
			
				//console.log("nueva foto de " + req.ip + "  " + res1);
			 }
			)
		}
		else
		{
			res.status(500).send("WRONG");
		}



	})



}

module.exports = pedirPerfil