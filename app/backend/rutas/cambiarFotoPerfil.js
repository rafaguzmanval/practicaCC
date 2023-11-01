const sql = require("../bd.js");
const multer = require('multer');

var storage2 = multer.diskStorage({
	destination: function (req, file, callback){

		callback(null,'users/'+req.body.usuario);

	},
	filename: function(req,file,callback){

		callback(null, 'perfil.jpg');
	}
})

function cambiarFotoPerfil(req,res)
{

	var upload = multer({storage : storage2}).single('picture')

	upload(req,res,function(err){

		if(err)
		{
			console.log("Fallo al cambiar foto " + err);
			res.status(500).send("Fallo al cambiar foto " + err);
			return;
		}
		if(req.body.foto != "")
		{
			sql.query("UPDATE USUARIOS SET foto=? WHERE nombre=?",
			[req.file.path,req.body.usuario],
			function(err)
			{
				if(err)
				{
					console.log("Fallo al cambiar foto en base de datos " + err);
					res.status(500).send("Fallo al cambiar foto en base de datos" + err);
					return;
				}
				else
				{
					//console.log(req.body.correo + " se ha cambiado la foto de perfil");
					res.status(200).send("OK");
				}
			}
			
			)
		}
	});

}

module.exports = cambiarFotoPerfil;