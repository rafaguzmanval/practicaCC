const sql = require("../bd.js");
const crypto = require('crypto');
const clientes = require('../sesion.js');
const argon2 = require("argon2")
//const worker = require('node:worker_threads');

async function auth(req,res) {



	const correo = req.body.correo;
	var clave = req.body.clave;


	var userID = crypto.createHash('sha256').update(correo + 67 + clave + correo + "photopop" + clave).digest('base64');

	//console.log(userID)


	var respuesta = 0;

	if(typeof correo != "string" || typeof clave != "string"){
		res.status(500).send("Parametros invalidos")
		return;
	}

	if(correo && clave)
	{

		try{
		var claveSha512 = crypto.createHash('sha512').update(clave).digest('base64');

		//console.log('clave sha256'claveSha512);

	    await sql.promise().query("SELECT CAST(AES_DECRYPT(UNHEX(hash),?) AS CHAR(1000)) hash FROM ANOM WHERE userID=?",[claveSha512,userID]).then(async (qry)  => {

		
			//console.log(qry[0])
			respuesta = qry[0].length
			if(respuesta==1)
			{
				var hash = qry[0][0].hash

				//console.log(hash);



				var claveAES = claveSha512.substring(0,10);
				

				var validacion = await argon2.verify(hash,userID + clave)


				if(validacion)
				{
				sql.query("SELECT correo,nombre,permisos FROM USUARIOS where correo = ?",
				[correo],
				(err,res1,fields) => {
		
					if(err)
					{
						console.log("error " , err);
						res.status(500).send("error " + err);
						return;
					}
			
				
					respuesta = res1.length;
					//console.log(respuesta);
	
					sql.query("DELETE FROM AUTH WHERE correo=?",[correo],function(err){
	
						if(err)
						{
							console.log(err);
						}
		
						var combinacion = "pop" + correo + clave + Date.now();
						var token = crypto.createHash('sha256').update(combinacion).digest('base64');
						
						res.cookie('auth',token,{
							httpOnly: true,
							secure:true
						},
						);
		
						var localizacion = crypto.createHash('sha256').update(token + "?$€" + req.ip + token).digest('base64');

						sql.query("INSERT INTO AUTH VALUES(?,?,?)",[correo,token,localizacion],function(err){
							res.status(200).send({respuesta : respuesta, auth: token, nombre: res1[0]['nombre'], permisos : res1[0]['permisos']});
						})
					});
		
			 
				 });
	
				}
				else
				{
					res.status(400).send({respuesta : "WRONG", auth: ""});
				}
	
	
			}
			else
			{
				res.status(400).send({respuesta : "WRONG", auth: ""});
			}

		})
	}catch(e){
		console.log(e)
		res.status(500).send(e);
	}

	}




}

module.exports = auth;