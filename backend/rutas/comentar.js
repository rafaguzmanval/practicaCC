const sql = require("../bd.js");


function comentar(req,res){

    var tiempo = Date.now();


    sql.query('INSERT INTO COMENTARIOS (contenido,tipo,tiempo,idPublicacion,usuario) Values(?,\'texto\',?,?,?)',[req.body.contenido,tiempo,req.body.publicacion,req.body.usuario],function(err,qry){


        if(err)
        {
            console.log(err);
            res.status(500).send('error ' + err);
        }

        //console.log('nuevo comentario en ' + req.body.publicacion)

        res.status(200).send('ok');

    })

}

module.exports = comentar;