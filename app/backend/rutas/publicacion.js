const sql = require("../bd.js");


function publicacion(req,res){

    sql.query('SELECT * FROM COMENTARIOS WHERE idPublicacion = ? ORDER BY tiempo DESC', [req.params.id],function(err,qry){
        if(err)
        {
            console.log(err);
            res.status(500).send(err);
        }
        else
        {

            sql.query('SELECT COUNT(*) FROM GUSTA WHERE idPublicacion=?',[req.params.id],function(err,qry1){

                if(err)
                {
                    console.log(err);
                    res.status(500).send(err);
                }
                else
                {


                    sql.query('SELECT PUBLICACIONES.descripcion,tipo,PRODUCTO.precio FROM PUBLICACIONES LEFT JOIN PRODUCTO ON PUBLICACIONES.id=PRODUCTO.idPublicacion WHERE id=?',[req.params.id],function(err,qry2){

                        if(err)
                        {
                            console.log(err);
                            res.status(500).send(err);
                        }
                        else
                        {

                            
                            res.status(200).json({"descripcion" : qry2[0]['descripcion'],"tipo" : qry2[0]['tipo'],"precio" : qry2[0]['precio'],'comentarios' : qry,'likes': qry1[0]['COUNT(*)']});

                        }
                    })
                }
        

               
        
        
            })
        }
    })






}

module.exports = publicacion