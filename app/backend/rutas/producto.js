const sql = require("../bd.js");


function producto(req,res){

    sql.query('SELECT * FROM PRODUCTOS WHERE idPublicacion = ?', [req.params.id],function(err,qry){
        if(err)
        {
            console.log(err);
            res.status(500).send(err);
        }
        else
        {

            res.status(200).send(qry[0]);

        }
    })






}

module.exports = producto