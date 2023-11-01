const sql = require("../bd.js");

function ultimas(req,res)
{
	//Se buscan todas las publicaciones de la gente a la que se sigue y las propias.

	if(req.body.permisos == 0)
	{
		sql.query(//"SELECT PUBLICACIONES.id,USUARIOS.nombre,USUARIOS.correo FROM USUARIOS INNER JOIN USUARIOPUBLICACION ON USUARIOS.correo=USUARIOPUBLICACION.correo INNER JOIN PUBLICACIONES ON USUARIOPUBLICACION.id=PUBLICACIONES.id ORDER BY PUBLICACIONES.id DESC"
		"SELECT PUBLICACIONES.id,PUBLICACIONES.tipo,PUBLICACIONES.descripcion,PRODUCTO.precio,USUARIOS.nombre FROM (SELECT usuario2 usuario FROM SIGUE WHERE usuario1=? UNION SELECT nombre usuario FROM USUARIOS WHERE nombre=?) USUARIOS2 INNER JOIN USUARIOPUBLICACION ON USUARIOS2.usuario=USUARIOPUBLICACION.usuario INNER JOIN PUBLICACIONES ON USUARIOPUBLICACION.id=PUBLICACIONES.id INNER JOIN USUARIOS ON USUARIOS.nombre=USUARIOS2.usuario LEFT JOIN PRODUCTO ON PUBLICACIONES.id=PRODUCTO.idPublicacion ORDER BY PUBLICACIONES.id DESC"
		,[req.body.usuario,req.body.usuario],
			function(error,qry)
			{
				if(error)
				{
					console.log("Error al servir publicaciones: " + error)
					res.status(500).send("Error al servir publicaciones: " + error)
				}
	
				//console.log(qry);
	
				res.status(200).send(qry);
			}
		)
	}
	else
	{
		sql.query(
		"SELECT PUBLICACIONES.id,PUBLICACIONES.tipo,PUBLICACIONES.descripcion,PUBLICACIONES.denuncias,USUARIOPUBLICACION.usuario nombre FROM PUBLICACIONES LEFT JOIN USUARIOPUBLICACION ON USUARIOPUBLICACION.id=PUBLICACIONES.id WHERE denuncias>0 ORDER BY denuncias DESC"
		,[],
			function(error,qry)
			{
				if(error)
				{
					console.log("Error al servir publicaciones denunciadas : " + error)
					res.status(500).send("Error al servir publicaciones denunciadas: " + error)
				}
	
				//console.log(qry);
	
				res.status(200).send(qry);
			}
		)
	}


}

module.exports = ultimas;