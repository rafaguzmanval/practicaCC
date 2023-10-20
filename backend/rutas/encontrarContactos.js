const sql = require("../bd.js");

function encontrarContactos(req,res) {

    sql.query("SELECT * FROM PRESENTACION LEFT JOIN PREFERENCIAS ON PRESENTACION.usuario=PREFERENCIAS.usuario WHERE PRESENTACION.usuario=?",[req.params.usuario],function(err,qry){

        if(err)
        {
            console.log(err);
            res.status(500).send(err);
        }
        else
        {
            //console.log(qry)
            if(qry.length == 1)
            {
                
                var caracteristicas = qry[0];

                var interes = caracteristicas['interes'];

                var filtroSexo = "";

                var plural = "es";
                if(caracteristicas['sexo'] == "Hombre")
                {
                    plural = "s";
                }

                if(interes == "Hombres")
                {
                    filtroSexo = "AND sexo=" + "'Hombre' AND interes IN ('"+caracteristicas['sexo']+plural+"','Ambos')"
                }
                else if(interes == "Mujeres")
                {
                    filtroSexo = "AND sexo=" + "'Mujer' AND interes IN ('"+caracteristicas['sexo']+plural+"','Ambos')"
                }

                //onsole.log(filtroSexo);

                sql.query('SELECT * FROM PRESENTACION LEFT JOIN PREFERENCIAS ON PRESENTACION.usuario=PREFERENCIAS.usuario WHERE PRESENTACION.usuario<>? ' + filtroSexo ,[caracteristicas['usuario']],function(err,qry2){
                    if(err)
                    {
                        console.log(err);
                        res.status(500).send(err);
                    }
                    else
                    {
                        res.status(200).send(qry2);
                    }
                })


                
            }
            else
            {
                res.status(200).send("NO REGISTRADO");
            }
        }

    })



}

module.exports = encontrarContactos;