const sql = require("../bd.js");
const crypto = require('crypto');


//const { parentPort } = require("worker_threads");

function autenticado(req,res,next) {


    var token = req.cookies['auth'];

    if(token == undefined)
	{
		if(req.body.auth != undefined)
		{
			token = req.body.auth;


		}
		else if(req.get('auth') != undefined)
		{

            token = req.get('auth');
		}
	}

	var localizacion = crypto.createHash('sha256').update(token + "?$€" + req.ip + token).digest('base64');
    sql.query('SELECT * FROM AUTH WHERE token=? AND loc=?',[token,localizacion],function(err,qry){

		if(err)
		{
            //resp = 500;
			res.status(500).send("error : " + err)
		}

		if(qry.length == 1)
		{
			//res.status(200).send("OK");
			//resp = 200;
            next();
		}
		else
		{
            //resp = 401;
			res.status(401).send("No se ha podido autenticar al usuario");
        }
	})


}

module.exports = autenticado;