
const sql = require("../bd.js");
const fs = require('fs');
const crypto = require('crypto');


function eliminarCuenta(req,res){

    //const correo = req.body.correo;
    var usuario = req.body.usuario
	var clave = req.body.clave;

    var token = req.body.token;

    token = req.cookies['auth'];

	if(token == undefined)
	{
		if(req.body.auth != undefined)
		{
			token = req.body.auth;
		}
        else
        {
            res.status(500).send("No se ha recibido token")
            return;
        }
    }


    var localizacion = crypto.createHash('sha256').update(token + "?$€" + req.ip + token).digest('base64');



    sql.query('SELECT AUTH.correo,token FROM AUTH LEFT JOIN USUARIOS ON AUTH.correo=USUARIOS.correo WHERE USUARIOS.nombre=? AND token=? AND loc=?'
    ,[usuario,token,localizacion],function(err,qry) {

        if(err)
        {
            console.log(err)
            res.status(500).send(err)
            sql.rollback();
            return;

        }

        if(qry.length > 1 )
        {
            console.log("ERROR GRAVE EN LA BASE DE DATOS: EXISTEN DOS USUARIOS IGUALES");
            res.status(500).send("No se pudo llevar a cabo la operación");
            sql.rollback();
            return;
        }else if(qry.length == 0)
        {
            res.status(401).send("No se pudo verificar la autenticidad");
            sql.rollback();
            return;
        }


        var correo = qry[0]['correo']

        var userID = crypto.createHash('sha256').update(correo + 67 + clave + correo + "photopop" + clave).digest('base64');

        sql.beginTransaction();

        sql.query('DELETE FROM CHAT WHERE usuario1=? OR usuario2=?', [req.body.usuario,req.body.usuario],function(err,qry2){

        if(err)
        {
            console.log(err)
            res.status(500).send(err)
            sql.rollback();
            return;

        }

        sql.query('DELETE FROM MENSAJES WHERE emisor=? OR receptor=?', [req.body.usuario,req.body.usuario],function(err,qry2){

            if(err)
            {
                console.log(err)
                res.status(500).send(err)
                sql.rollback();
                return;

            }

            //console.log("mensajes eliminados ")


                sql.query('DELETE FROM GUSTA WHERE usuario=?', [req.body.usuario],function(err,qry2){

                    if(err)
                    {
                        console.log(err)
                        res.status(500).send(err)
                        sql.rollback();
                        return;
        
                    }


                    sql.query('DELETE FROM COMENTARIOS WHERE usuario=?', [req.body.usuario],function(err,qry2){

                        if(err)
                        {
                            console.log(err)
                            res.status(500).send(err)
                            sql.rollback();
                            return;
            
                        }


                        sql.query('DELETE FROM PRESENTACION WHERE usuario=?', [req.body.usuario],function(err,qry2){

                            if(err)
                            {
                                console.log(err)
                                res.status(500).send(err)
                                sql.rollback();
                                return;
                
                            }


                            sql.query('DELETE FROM PREFERENCIAS WHERE usuario=?', [req.body.usuario],function(err,qry2){

                                if(err)
                                {
                                    console.log(err)
                                    res.status(500).send(err)
                                    sql.rollback();
                                    return;

                                }

                                sql.query('DELETE FROM USUARIOS WHERE nombre=?', [req.body.usuario],function(err,qry2){

                                    if(err)
                                    {
                                        console.log(err)
                                        res.status(500).send(err)
                                        sql.rollback();
                                        return;
                        
                                    }


                                    sql.query('DELETE FROM CARTERA WHERE correo=?', [req.body.usuario],function(err,qry2){

                                        if(err)
                                        {
                                            console.log(err)
                                            res.status(500).send(err)
                                            sql.rollback();
                                            return;

                                        }

                                        sql.query('DELETE FROM AUTH WHERE correo=?', [correo],function(err,qry2){

                                        })

                                        //console.log(userID)
                                        sql.query('DELETE FROM ANOM WHERE userID=?', [userID],function(err,qry2){

                                            if(err)
                                            {
                                                console.log(err)
                                                res.status(500).send(err)
                                                sql.rollback();
                                                return;
                                
                                            }

                                            console.log()
                                            var dir = process.cwd()+"/users/" + req.body.usuario;

                                            fs.rmdir(dir , {
                                                recursive: true,
                                              }, (error) => {
                                                if (error) {
                                                    console.log(err)
                                                    res.status(500).send(err)
                                                    sql.rollback();
                                                    return;
                                                }
                                                else {
                                                  console.log("Recursive: Directories Deleted!");
                                                
                                                }
                                              });

                                              sql.query('SELECT * FROM USUARIOPUBLICACION WHERE usuario=?',[req.body.usuario],function(err,qry){

                                                if(err)
                                                {
                                                    console.log(err)
                                                    res.status(500).send(err)
                                                    sql.rollback();
                                                    return;
                                                }
                                    

                                            // meto en un array las ids que se han conseguido
                                            var ids = qry.map(e => e['id'])
                                    
                                    
                                            if(ids.length)
                                            {
                                                sql.query('DELETE FROM USUARIOPUBLICACION WHERE id IN (?)', [ids],function(err,qry2){
                                    
                                                    if(err)
                                                    {
                                                        console.log(err)
                                                        res.status(500).send(err)
                                                        sql.rollback();
                                                        return;
                                        
                                                    }
                                    
                                                    console.log("Usuario publicacion eliminado ")
                                    
                                                    sql.query('DELETE FROM PUBLICACIONES WHERE id IN (?)', [ids],function(err,qry2){
                                        
                                                        if(err)
                                                        {
                                                            console.log(err)
                                                            res.status(500).send(err)
                                                            sql.rollback();
                                                            return;
                                            
                                                        }
                                    
                                    
                                                        console.log("publicaciones eliminadas ")
                                    
                                                        sql.query('DELETE FROM PRODUCTO WHERE idPublicacion IN (?)', [ids],function(err,qry2){
                                        
                                                            if(err)
                                                            {
                                                                console.log(err)
                                                                res.status(500).send(err)
                                                                sql.rollback();
                                                                return;
                                                
                                                            }

                                                            sql.commit();
                                                            console.log("usuario borrado " + req.body.usuario)
                                                            res.status(200).send("OK")
                                                
                                                        })
                                    
                                                    })
                                                })
                                        
                                    
                    
                                    
                                            }else
                                            {
                                                sql.commit();
                                                console.log("usuario borrado " + req.body.usuario)
                                                res.status(200).send("OK")
                                            }
                                    
                                        })
                                    

                                    
                                
                                        })

                                    })
                        
                                })

                            })
                
                        })
            
                    })
        
                })

        })


    })

})



}

module.exports = eliminarCuenta