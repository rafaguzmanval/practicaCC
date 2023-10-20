const sql = require("../bd.js");
const fs = require('fs');

function borrarPublicacion(req,res)
{

		
	sql.query("SELECT path FROM PUBLICACIONES WHERE id =" + req.body.id,
	[req.body.id],
	(err,r) => {

		if(err)
		{
			console.log("error " , err);
			res.status(500).send("error al borrar archivo");
			return;
		}
	
		

				sql.beginTransaction(function(err){
					if(err)
					{
						console.log("Fallo en la transacción de borrado de "+req.body.id+": " + err )
						res.status.send("Fallo " + err);
					}

					//PRIMERA OPERACIÓN DE BORRADO
					sql.query("DELETE FROM PUBLICACIONES WHERE id =" + req.body.id,
					[req.body.id],
					(err,res1) => {
				
						if(err)
						{
							sql.rollback(() => {
								console.log("error " , err);
								res.status(500).send("error al borrar de la base de datos 2");
								return;
							});
						}
						else // SEGUNDA OPERACIÓN DE BORRADO, TABLA DE RELACIÓN
						{
							sql.query("DELETE FROM USUARIOPUBLICACION WHERE id = ?" , [req.body.id],
							(err,res1) => {
						
								if(err)
								{
									sql.rollback(() => {
										console.log("error " , err);
										res.status(500).send("error al borrar de la base de datos 2");
										return;
									});
		
								}
								else
								{

									sql.query("DELETE FROM COMENTARIOS WHERE idPublicacion = ?" , [req.body.id],
									(err,res1) => {
								
										if(err)
										{
											sql.rollback(() => {
												console.log("error " , err);
												res.status(500).send("error al borrar de la base de datos 2");
												return;
											});
				
										}
										else
										{

											sql.query("DELETE FROM GUSTA WHERE idPublicacion = ?" , [req.body.id],
											(err,res1) => {
										
												if(err)
												{
													sql.rollback(() => {
														console.log("error " , err);
														res.status(500).send("error al borrar de la base de datos 2");
														return;
													});
						
												}
												else
												{
											//console.log("2 borrada foto de " + req.ip + "  " + res1);
											//console.log("imagen "+ req.body.id +" de "+ req.ip +" eliminada");
				
											fs.unlink(r[0].path, (err => {
												if(err){console.log("Fallo al eliminar el archivo en el sistema: " + err)}
												res.status(200).send("OK");

												sql.query("DELETE FROM PRODUCTO WHERE idPublicacion = ?" , [req.body.id]);

												sql.commit();
											}));
											}
										}
											)
										}
									}
									)

									
		
								}
							 }
						
						
							)
						}
					
					 }
					)




				})

			}


	 
	)

	


}

module.exports = borrarPublicacion;