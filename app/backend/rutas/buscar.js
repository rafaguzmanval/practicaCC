const sql = require("../bd.js");

function buscar(req,res){

	//console.log(req.params)

	if(req.params.modo == "perfiles")
	{
		sql.query("SELECT nombre,correo FROM USUARIOS WHERE nombre LIKE '"+req.params.nombre+"%'",
		(err,res1,fields) => {
	
			if(err)
			{
				console.log("error " , err);
				res.status(500).send("error " + err);
				return;
			}
	
			res.status(200).json({tipo:"perfil","res":res1});
			//console.log("nueva foto de " + req.ip + "  " + res1);
		 }
		)
	}
	else if(req.params.modo == "productos")
	{
		var filtroCategoria = "";
		var filtroBusqueda = "";

		if(req.params.nombre != "$")
		{
			filtroBusqueda = "WHERE PUBLICACIONES.descripcion LIKE '%"+req.params.nombre+"%'" ;
		}

		if(req.body.categoria != "Todo")
		{

			filtroCategoria = (req.params.nombre != "$"? "AND" : "WHERE") + " PRODUCTO.categoria='"+req.body.categoria+"'";
		}

		sql.query("SELECT PUBLICACIONES.id,USUARIOPUBLICACION.usuario,PUBLICACIONES.descripcion,PRODUCTO.precio FROM PUBLICACIONES "+
		"INNER JOIN PRODUCTO ON PUBLICACIONES.id=PRODUCTO.idPublicacion INNER JOIN USUARIOPUBLICACION ON PUBLICACIONES.id=USUARIOPUBLICACION.id " +
		 filtroBusqueda + filtroCategoria,
		(err,res1,fields) => {
	
			if(err)
			{
				console.log("error " , err);
				res.status(500).send("error " + err);
				return;
			}
	
			res.status(200).json({tipo:"producto","res":res1});
			//console.log("nueva foto de " + req.ip + "  " + res1);
		 }
		)
	}
	else{
		res.status(500).send("bad request");
	}


}

module.exports = buscar;