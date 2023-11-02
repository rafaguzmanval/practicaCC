const sql = require("../bd.js");
const crypto = require('crypto');

//const { parentPort } = require("worker_threads");

const fs = require("fs-extra");
const argon2 = require("argon2")

function registro(req,res){

  try{

  sql.query("SELECT * FROM USUARIOS WHERE nombre=? OR correo=? OR telefono=?" ,[req.body.nombre,req.body.correo,req.body.telefono], async (err,qry) => {

    if(err)
    {
      console.log(err)
      return err;
      //res.status(500).send(err)
    }
    else
    {
      if(qry.length == 1)
      {
        res.status(400).send("Ese usuario ya existe");
      }else
      {


        var clave = req.body.clave;
        var correo = req.body.correo;

        console.time('tiempo')
        
        //antiguo modo
        var claveHash = '123'
        var claveSha512 = crypto.createHash('sha512').update(req.body.clave).digest("base64");

        console.log("creando scrypt");



        console.log(claveSha512);

        var userID = crypto.createHash('sha256').update(correo + 67 + clave + correo + "photopop" + clave).digest('base64');


        try{
          claveHash = await argon2.hash(userID + clave, {
            type: argon2.argon2i,
            timeCost : 100,
            hashLength : 100,
          }
          );
        }catch(e) {


          res.status(500).send("Error al registrar");
          console.log(e)
          return;
        }

        console.timeEnd('tiempo')

    
        sql.query("INSERT INTO ANOM (userID,hash) VALUES(?,HEX(AES_ENCRYPT(?,?)))" ,[userID,claveHash,claveSha512])
      
        sql.query("INSERT INTO USUARIOS VALUES(?,?,?,NULL,0)",
        [req.body.nombre,req.body.correo,req.body.telefono],
        (err,res1,fields) => {
      
          if(err)
          {
            console.log("error " , err);
            res.status(500).send("Registro incorrecto " + err);
            return;
          }
          else{
      
            sql.query("INSERT INTO CARTERA VALUES(?,0)",[req.body.nombre],function(err,qry){
      
              if(err)
              {
                console.log("error " , err);
                res.status(500).send("Registro incorrecto " + err);
                return;
              }
              else{
      
                const dirExists = (dir) => {
                  if (fs.existsSync(dir)) {
                    return "Directory exists";
                  } else {
                    return "Directory do not exist";
                  }
                };
      
      
                    var dir = process.cwd() + "/users/" + req.body.nombre + "/galeria";
      
                    console.log(dir);
                
                    const before = dirExists(dir);
                    console.log(`Before function call ${before}`);
                      
                    // Function call
                    fs.ensureDirSync(dir);
                      
                    // Checking after
                    //  calling function
                    const after = dirExists(dir);
                    console.log(`After function call ${after}`);


      
                res.status(200).send("Registro correcto");
              }
      
            })
      
      
            }
            
      
         });
      }
    }

  })

  }
  catch(e){
    res.status(500).send("Registro fallido " + err);
    console.log(e)
  }

	


}

module.exports = registro;
