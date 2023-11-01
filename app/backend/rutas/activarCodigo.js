const sql = require("../bd.js");


//Función para activar un código monetario para un usuario y otorgarle dinero
function activacion(req,res)
{
	sql.query("SELECT * FROM CODIGOSMONETARIOS WHERE codigo=?",[req.body.codigo],function(err,qry){
		if(err)
		{
			console.log(err)
			res.status(500).send("error  " + err)
		}

		console.log("se esta intentando activar un codigo " + qry)
		//console.log(qry.length + "  " + qry.)
		//console.log(qry)

		if(qry.length == 1 && qry[0]['usuario'] == null)
		{
			//console.log("codigo libre");

			sql.beginTransaction();

			sql.query("UPDATE CODIGOSMONETARIOS SET usuario=? WHERE codigo=?",[req.body.usuario,req.body.codigo],function(err,qry2){
				if(err)
				{
					console.log(err)
					sql.rollback();
					res.status(500).send("error  " + err)
				}

				//console.log(qry[0]['cantidad'])


				sql.query("SELECT saldo FROM CARTERA WHERE correo=?",[req.body.usuario],function(err,qry3){
					if(err)
					{
						console.log(err)
						sql.rollback();
						res.status(500).send("error  " + err)
					}
					//console.log("resultado saldo " + qry3[0]['saldo']);

					sql.query("UPDATE CARTERA SET saldo=? WHERE correo=?",[qry[0]['cantidad'] + qry3[0]['saldo'],req.body.usuario],function(err,qry4){
						if(err)
						{
							console.log(err)
							sql.rollback();
							res.status(500).send("error  " + err)
						}

		
					})

				})
				




			})






			sql.commit();
			res.status(200).send("canjeo correcto");

		}
		else
		{
			res.status(501).send("ERROR: CODIGO INEXISTENTE");
		}

	})


}


module.exports = activacion