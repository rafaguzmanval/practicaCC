const sql = require("../bd.js");

function registrarPerfilCitas(req,res) {


    sql.query("SELECT * FROM PRESENTACION WHERE usuario=?",[req.body.usuario],function(err,qry){
        if(err)
        {
            console.log(err)
            res.status(500).send(err)
        }
        else
        {
            if(qry.length == 1)
            {

                sql.query("UPDATE PRESENTACION SET descripcion=?,sexo=?,edad=?,longitud=?,latitud=? WHERE usuario=?",[req.body.descripcion,req.body.sexo,req.body.edad,req.body.longitud,req.body.latitud,req.body.usuario],function(err,qry2){

                    if(err)
                    {
                        console.log(err);
                        res.status(500).send(err);
                    }
                    else
                    {
                        sql.query("UPDATE PREFERENCIAS SET relacion=?,interes=?,edadMinima=?,edadMaxima=?,distancia=? WHERE usuario=?",[req.body.relacion,req.body.interes,req.body.edadMinima,req.body.edadMaxima,req.body.distancia,req.body.usuario],function(err,qry3){
            
                            if(err)
                            {
                                console.log(err);
                                res.status(500).send(err);
                            }
                            else
                            {
                    
                                res.status(200).send("ok");
                    
                            }
                    
                        })
            
            
                    }
            
                })
            }
            else
            {
                sql.query("INSERT INTO PRESENTACION VALUES(?,?,?,?,?,?)",[req.body.usuario,req.body.descripcion,req.body.sexo,req.body.edad,req.body.longitud,req.body.latitud],function(err,qry2){

                    if(err)
                    {
                        console.log(err);
                        res.status(500).send(err);
                    }
                    else
                    {
                        sql.query("INSERT INTO PREFERENCIAS VALUES(?,?,?,?,?,?)",[req.body.relacion,req.body.interes,req.body.usuario,req.body.edadMinima,req.body.edadMaxima,req.body.distancia],function(err,qry3){
            
                            if(err)
                            {
                                console.log(err);
                                res.status(500).send(err);
                            }
                            else
                            {
                    
                                res.status(200).send("ok");
                    
                            }
                    
                        })
            
            
                    }
            
                })
            }
        }
    })





}


module.exports = registrarPerfilCitas;