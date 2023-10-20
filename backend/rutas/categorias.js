const sql = require("../bd.js");


function categorias(req,res){

    sql.query('SELECT * FROM CATEGORIAS',function(err,qry){
        if(err)
        {
            console.log(err);
            res.status(500).send(err);
        }
        else
        {

            res.status(200).send(qry);

        }
    })






}

module.exports = categorias