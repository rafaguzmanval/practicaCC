
const sql = require("../bd.js");


function donacion(req,res){

    sql.query('SELECT * FROM CARTERA WHERE correo=? UNION SELECT * FROM CARTERA WHERE correo=?', [req.body.usuario1,req.body.usuario2],function(err,qry){

        if(err)
        {
            console.log(err)
            res.status(500).send(err);
        }
        else
        {
            if(qry.length == 2)
            {
                if(qry[0]['saldo'] >= req.body.dinero)
                {
                    sql.beginTransaction()

                    var saldoUsuario1 = parseFloat(qry[0]['saldo']) - parseFloat(req.body.dinero)

                    var saldoUsuario2 = parseFloat(qry[1]['saldo']) + parseFloat(req.body.dinero)

                    console.log("nuevos saldos " + saldoUsuario1 + "  " + saldoUsuario2)

                    sql.query('UPDATE CARTERA SET saldo=? WHERE correo=?',[saldoUsuario1,req.body.usuario1],function(err){
                        if(err)
                        {
                            console.log(err)
                            res.status(500).send(err);  
                            sql.rollback();
                        }
                    });

                    sql.query('UPDATE CARTERA SET saldo=? WHERE correo=?',[saldoUsuario2,req.body.usuario2],function(err){
                        if(err)
                        {
                            console.log(err)
                            res.status(500).send(err);  
                            sql.rollback();
                        }
                    });

                    sql.commit();
                    res.status(200).send("ok")
                }
                else
                {
                    res.status(200).send("NoMoney")
                }
            }
            else{

                res.status(200).send("Usuarios no válidos");
            }


        }


    })
}

module.exports = donacion