const sql = require("../bd.js");

function consultarCartera(req,res){

    sql.query('SELECT saldo FROM CARTERA WHERE correo = ?',[req.body.usuario],function(err,qry2){

        if(err)
        {
            console.log(err);
            res.status(500).send(err);
        }
        else
        {
            //console.log(qry2)
            res.status(200).send(qry2[0]);
        }

    });


}

module.exports = consultarCartera