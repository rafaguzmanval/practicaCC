
const multer = require('multer');
const sql = require("../bd.js");




//SOLO SE PODRÁ ACCEDER A LOS ELEMENTOS DEL POST MEDIANTE ESTA FUNCIÓN
var storage = multer.diskStorage({
	destination: function (req, file, callback){

		callback(null,'users/'+req.body.usuario+'/galeria');

	},
	filename: function(req,file,callback){

		var extension = '.jpg';
		if(req.body.tipo=="video")
		{
			extension = '.mp4'
		}


		callback(null,req.body.usuario + '-' + Date.now() + extension);
	}
})

function uploadFile(req,res) {


	var upload = multer({storage : storage}).single('picture')


	upload(req,res,function(err){


		if(err)
		{
			
				console.log("error al subir el archivo : " + err);
				res.status(500).send('Error al subir archivo ' + err);
				return;
			
			
		}
		else
		{
			console.log("nueva foto de " + req.ip + "  " + res);

			sql.beginTransaction(function(err){

		
				if(err)
				{
					req.status(500).send("Error al subir archivo: " + err);
				}
				else{
		
					//console.log(req.body.submit)
					var precio = "-1"
					var tipo = req.body.tipo

					if(req.body.precio != "null")
					{
						precio = req.body.precio;
						tipo = "producto"

					}
		
					sql.query("INSERT INTO PUBLICACIONES (path,tipo,nombre,descripcion) VALUES(?,?,?,?)",
					[req.file.path,tipo,req.file.filename,req.body.descripcion],
					(err) => {
		
						if(err)
						{
							
							sql.rollback(()=>{
								console.log("error " , err);
								res.status(500).send("error en 1 : " + err);
								return;
							});

						}
						else
						{
		
							console.log("Primera insercion exitosa, ahora se busca el id");
							sql.query("SELECT id FROM PUBLICACIONES WHERE nombre= ?",
							[req.file.filename],
							(err,res1,fields) => {
				
								if(err)
								{
									
									sql.rollback(()=>{
										console.log("error " , err);
										res.status(500).send("error en 2 : " + err);
										return;
									});

								}
								else
								{
									sql.query("INSERT INTO USUARIOPUBLICACION VALUES(?,?)",
									[req.body.usuario,res1[0].id],
									(err,res2,fields) => {
						
										if(err)
										{
											sql.rollback(()=>{
												console.log("error " , err);
												res.status(500).send("error en 3 : " + err);
												return;
											});

										}
										else
										{
											if(tipo == "imagen" || tipo =="video")
											{
												sql.commit();
												res.status(200).send({id: res1[0].id});
											}
											else
											{
												sql.query("INSERT INTO PRODUCTO VALUES(?,?,?,?)",
												[res1[0].id,req.body.categoria,req.body.descripcionProducto,precio],
												(err,res2,fields) => {
									
													if(err)
													{
														sql.rollback(()=>{
															console.log("error " , err);
															res.status(500).send("error en 3 : " + err);
															return;
														});
			
													}

													else{

														sql.commit();
														res.status(200).send({id: res1[0].id});
													}


												})


											}





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
		
		
			});
			
		}

	});
	



	

}


module.exports = uploadFile