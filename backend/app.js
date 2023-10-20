
const https = require('https');
const http = require('http');
const express = require('express');
const multer = require('multer');
const fs = require('fs');
const cookie_parser = require('cookie-parser')

const crypto = require('crypto');

const { Worker } = require("worker_threads");


const sql = require("./bd.js");
const { dirname } = require('path');
const { dir } = require('console');
const auth = require("./rutas/auth.js");
const ultimas = require("./rutas/ultimas.js");
const registro = require("./rutas/registro.js");
const subirArchivo = require("./rutas/subirArchivo.js");
const perfil = require("./rutas/perfil.js");
const getFotoPerfil = require("./rutas/fotoPerfil");
const cambiarFotoPerfil = require("./rutas/cambiarFotoPerfil.js");
const borrarPublicacion = require("./rutas/borrarPublicacion.js");
const getImagen = require('./rutas/imagen.js');
const buscar = require('./rutas/buscar.js');
const comentar = require('./rutas/comentar.js');
const publicacion = require('./rutas/publicacion.js');
const producto = require('./rutas/producto.js');
const categorias = require('./rutas/categorias.js');
const activacionCodigo = require('./rutas/activarCodigo.js');
const encontrarContactos = require('./rutas/encontrarContactos');
const registrarPerfilCitas = require('./rutas/registrarPerfilCitas');
const consultarCartera = require('./rutas/consultarCartera.js');
const donacion = require('./rutas/donacion.js')
const eliminarCuenta = require('./rutas/eliminarCuenta.js');
const autenticado = require('./rutas/autenticado.js');



const app = express();

const router1 = express.Router()
const routerRegistro = express.Router()

app.use(express.json());
app.use(express.urlencoded({extended:true}));
app.use(express.static(__dirname + '/public'));
app.use(express.static(__dirname + '/public/graficos'));
app.use(cookie_parser())
app.use(router1)
app.use(routerRegistro)




//Configuración HTTPS

const options = {
	key: fs.readFileSync("conf/photopop.key"),
	cert: fs.readFileSync("conf/photopop.crt"),
  };
  

const PORT = process.env.PORT || 4000;

 const server = https.createServer(options, app)
.listen(PORT, function (req, res) {
	console.log('Server is Started on',PORT);
});

const serverhttp  = http.createServer(app).listen(3000)





app.get('/',function(req,res){

	res.sendFile(__dirname + '/public/index.html');

})



app.get('/salavirtual',function(req,res){
	
	res.sendFile(__dirname + '/public/graficos/index.html');
})

app.get('/salavirtual/:documento',function(req,res){
	
	res.sendFile(__dirname + '/public/graficos/'+req.params.documento);
})

app.get('/node_modules*',function(req,res){
	
	res.sendFile(__dirname + req.path);
})

app.get('/home',function(req,res){
	console.log('casa')
	res.sendFile(__dirname + '/public/index.html');
})

app.get('/logout',function(req,res){

	console.log("cookies borrada");

	res.clearCookie('auth');
	res.status(200).send('ok');
	//res.sendFile(__dirname + '/public/index.html');
})

app.get('/:correo',function(req,res){
	res.sendFile(__dirname + '/public/index.html');
})


//app.post('/API/autenticado',autenticado)

app.post('/API/registro',registro)

app.post('/API/auth',auth);

app.post('/API/subir',autenticado,subirArchivo)

app.get('/API/categorias',categorias);

app.post('/API/ultimas',autenticado,ultimas);

app.post('/API/registrarPerfilCitas',autenticado,registrarPerfilCitas);

app.post('/API/eliminarCuenta',eliminarCuenta);

app.get('/API/encontrarContactos/:usuario',encontrarContactos);

app.get('/API/:correo',perfil);

app.get('/API/pedirFotoperfil/:correo',getFotoPerfil)

app.post('/API/buscar/:modo/:nombre',buscar);

app.get('/API/imagen/:correo/:foto',getImagen);

app.post('/API/borrar',autenticado,borrarPublicacion);

app.post('/API/donacion',donacion);

app.post('/API/fotoPerfil',cambiarFotoPerfil);

app.post('/API/comentar',comentar);

app.post('/API/consultarCartera',consultarCartera);

app.get('/API/publicacion/:id',publicacion);

app.get('/API/producto/:id',producto);

app.post('/API/encontrarChat',function(req,res){

    sql.query('SELECT idChat FROM CHAT WHERE (usuario1=? AND usuario2=?) OR (usuario1=? AND usuario2=?)', [req.body.user1,req.body.user2,req.body.user2,req.body.user1],function(err,qry){
        if(err)
        {
            console.log(err);
            res.status(500).send(err);
        }
        else
        {
			res.status(200).json(qry)

		}
	}
	);



})

app.post('/API/token',function(req,res){

	//console.log("confirmando token : " + req.cookies['auth'])
	 token = req.cookies['auth'];

	if(token == undefined)
	{
		if(req.body.auth != undefined)
		{
			token = req.body.auth;
		}
		else
		{
			console.log("error : el ususario no se identifica")
			res.status(200).send("WRONG");
			return;
		}
	}

	//console.log("token " + token);

	var localizacion = crypto.createHash('sha256').update(token + "?$€" + req.ip + token).digest('base64');
	console.log(localizacion)

	sql.query('SELECT AUTH.correo correo,USUARIOS.nombre nombre, USUARIOS.permisos FROM AUTH LEFT JOIN USUARIOS ON AUTH.correo=USUARIOS.correo WHERE token=? AND loc=?',[token,localizacion],function(err,qry){

		if(err)
		{
			res.status(500).send("error : " + err)
		}

		if(qry.length != 0)
		{
			res.status(200).send(qry[0])
		}
		else
		{
			res.status(200).send("WRONG");
		}

	})

})

app.post('/API/activarCodigo',activacionCodigo)

app.post('/API/denunciar',function(req,res) {


		sql.query("SELECT denuncias FROM PUBLICACIONES WHERE id=?",[req.body.id], function(err,qry) {

			if(err)
			{
				console.log("error " + err);
				res.status(500).send("error : " + err)
				return;
			}

			var denuncias = parseInt(qry[0]['denuncias']) + 1;

			sql.query("UPDATE PUBLICACIONES SET denuncias=? WHERE id=?", [denuncias,req.body.id], function(err,qry){

				if(err)
				{
					console.log("error " + err);
					res.status(500).send("error : " + err)
					return;
				}
				

				res.status(200).send("OK");

			})
		})


})

app.get('/:correo/:id',function(req,res){
	console.log("hola")
	res.sendFile(__dirname + '/public/index.html');
});


/*app.get('*',function(req,res){
	res.sendFile(__dirname + req.params);
})*/


var usuarios = new Map();

var jugadores = new Map();

const io = require('socket.io')(server);
const iohttp = require('socket.io')(serverhttp);


function funcionesSocketIO(client) {
	{
	
		var usuario = "";
		console.log("Connected " + client.request.connection.remoteAddress);
	
		client.on('auth', function(nuevoUsuario){
			console.log('nuevo cliente ' + nuevoUsuario);
			client.join(nuevoUsuario);
			usuarios.set(nuevoUsuario,"");
			usuario = nuevoUsuario;
		})
	
		client.on('nuevoJugador',function(color){
			console.log(client.id + " quiere meterse en la sala virtual con color " + color)
	
	
			io.to("salavirtual").emit("nuevoJugador",client.id,color);
	
	
			client.join("salavirtual");
	
			var envioJugadores = []
	
			jugadores.forEach((key,value) => {
				envioJugadores.push([value,key.posicion ,key.color]);
			})
	
			client.emit("cargarSala",envioJugadores)
	
			jugadores.set(client.id,{posicion:[0,0,0] ,andar : false, girarDerecha : false, girarIzquierda : false, saludar:false, color : color})
			//console.log(nombresJugadores);

	
	
		})
	
		client.on('dejarSala',function(){
	
			//console.log(client.id + " ha dejado la salda virtual")
			//console.log(jugadores)
			client.leave("salavirtual")
			io.to("salavirtual").emit("dejarSala",client.id);
			jugadores.delete(client.id)
		})
	
		client.on('movimiento',function(pos,tipoMovimiento){
	
	
			var propiedades = {posicion:pos ,andar : tipoMovimiento=="andar", girarDerecha : tipoMovimiento=="girarDerecha", girarIzquierda : tipoMovimiento=="girarIzquierda",saludar : tipoMovimiento == "saludar",color : jugadores.get(client.id).color}
	
			jugadores.set(client.id, propiedades)
	
			io.to('salavirtual').emit('movimiento',client.id,pos,propiedades)
	
		})
	
		client.on('follow',function(user1,user2){
			console.log( user1 + " quiere seguir a " + user2)
	
			sql.query("INSERT INTO SIGUE VALUES(?,?)",[user1,user2],function(err,res){
					if(err)
					{
						console.log("error " + err)
					}
	
					io.to(user2).emit('notificacion',user1 + ' te sigue');
					client.emit('follow',['ok',user2]);
			});
		})
	
		client.on('unfollow',function(user1,user2){
			console.log( user1 + " deja de seguir a " + user2)
	
			sql.query("DELETE FROM SIGUE WHERE usuario1=? AND usuario2=?",[user1,user2],function(err,res){
					if(err)
					{
						console.log("error " + err)
					}
					
					client.emit('unfollow',['ok',user2]);
			});
		})
	
	
		client.on('mensaje',function(idChat,tipo,msg,user1,user2,tiempo){
			//console.log( user1 + " manda mensaje a " + user2)
			var d = new Date(0);
			//console.log(tiempo);
			d.setUTCMilliseconds(tiempo);
			//console.log(msg + " " + d);
	
			console.log("nuevo mensaje");
	
			if(idChat == -1)
			{
				
				sql.beginTransaction( async function(err){
					
					if(err){console.log(err); return;}
	
					
						
						sql.promise().query("INSERT INTO CHAT (usuario1,usuario2,ultimoMensaje) VALUES(?,?,?)",[user1,user2,msg.substring(0,20)]).then( (res) => {
							//console.log(res[0].insertId);
	
							sql.query("INSERT INTO MENSAJES VALUES(?,?,?,?,?,?)",[res[0].insertId,tipo,msg,user1,user2,tiempo],function(err,res1){
								if(err)
								{
									sql.rollback();
									console.log("error " + err)
									return;
								}
		
								io.to(user2).emit('mensajeEntrante',res[0].insertId,tipo,msg,user1,user2,tiempo);
		
								client.emit('mensaje',res[0].insertId);
								sql.commit();
							});
	
	
						  })
						  .catch(console.log)
		
					})
	
				
	
			}
			else{
			sql.query("INSERT INTO MENSAJES VALUES(?,?,?,?,?,?)",[idChat,tipo,msg,user1,user2,tiempo],function(err,res){
					if(err)
					{
						console.log("error " + err)
						return;
					}
	
					sql.query("UPDATE CHAT SET ultimoMensaje=? WHERE idChat=?",[msg.substring(0,20),idChat],function(err,res2){
						if(err)
						{
							console.log("error " + err)
							return;
						}
	
						io.to(user2).emit('mensajeEntrante',idChat,tipo,msg,user1,user2,tiempo);
	
						client.emit('mensaje','ok',idChat);
	
					})
	
	
			});
			}
			
	
		})
	
		client.on('cargaMensajes',function(idChat){
	
			//console.log(idChat+ " envio de mensajes ");
	
			sql.query("SELECT * FROM MENSAJES WHERE idChat=? ",[idChat],function(err,res){
				if(err)
				{
					console.log("error " + err)
					return;
				}else
				{
				
					//console.log(res);
					client.emit("cargaMensajes", res);
				}
	
	
	
			})
	
	
		});
	
	
		client.on('chats',function(correo){
			
			sql.query("(SELECT usuario1 user,idChat,ultimoMensaje FROM CHAT WHERE usuario2=?) UNION (SELECT usuario2 user,idChat,ultimoMensaje FROM CHAT WHERE usuario1=?)",[correo,correo],function(err,res){
					if(err)
					{
						console.log("error " + err)
					}
					else{
	
					//console.log(correo);
					//console.log("enviando chats: " + res[0]);
					client.emit('chats',res);
	
					}
	
			});
		})
	
		client.on("oferta",function(oferta,llamador,receptor){
	
			if(usuarios.has(receptor))
			{
				usuarios.set(llamador,oferta);
				io.to(receptor).emit('llamada',llamador,oferta);
				console.log("nueva oferta ! " + receptor +"\n");
			}
			else
			{
				client.emit('cancelarLlamada');
			}
	
	
	
		});
	
		client.on("cancelarLlamada",function(interlocutor1,interlocutor2){
	
			io.to(interlocutor2).emit('cancelarLlamada',interlocutor1);
		})
	
		
	
		client.on("pedirOferta",function(){
			client.emit("pedirOferta",ofert,llamador);
		})
	
		client.on("respuesta",function(resp,user){
	
			//console.log("nueva respuesta ! " + user);
			io.to(user).emit('respuesta',resp);
	
		});
	
		client.on('candidato',function(candidato,user){
	
			//console.log("candidato elegido: " + candidato)
	
			io.to(user).emit('candidato',candidato);
		})
	
		client.on('pedirCandidato',function(user,user2){
	
			io.to(user).emit('pedirCandidato',user2);
		})
	
	
		function infoPublicacion(id,user)
		{
			sql.query('SELECT COUNT(*) FROM GUSTA WHERE idPublicacion=?',[id],function(err,qry1){
	
				if(err)
				{
					client.emit("error");
				}
	
			sql.query('SELECT COUNT(*) FROM GUSTA WHERE idPublicacion=? AND usuario=?',[id,user],function(err,qry2){
	
				if(err)
				{
					client.emit("error");
				}
	
				//console.log(qry1[0]['COUNT(*)'] + " " + qry2[0]['COUNT(*)']);
				client.emit('infoPublicacion',qry1[0]['COUNT(*)'],qry2[0]['COUNT(*)'] == 1);
	
			})
	
	
		})
		}
		
	
		client.on('infoPublicacion',function(id,correo){
			infoPublicacion(id,correo)
		})
	
		client.on('gustaFoto',function(id,correo,esGustar){
	
			if(esGustar)
			{
				sql.query('INSERT INTO GUSTA VALUES(?,?)',[correo,id],function(err,qry){
					if(err)
					{
						client.emit('error');
					}
					else
					{
						//console.log("nuevo me gusta de " + correo + "  a " + id)
						infoPublicacion(id,correo);
					}
				})
			}
			else
			{
				sql.query('DELETE FROM GUSTA WHERE usuario=? AND idPublicacion=?',[correo,id],function(err,qry){
					if(err)
					{
						client.emit('error');
					}
					else
					{
						infoPublicacion(id,correo);
					}
				})
			}
	
	
		})
	
	
	
		client.on('disconnect',function(){
			console.log(client.request.connection.remoteAddress + " se desconecta");
	
			if(jugadores.has(client.id))
			{
				io.to("salavirtual").emit("dejarSala",client.id);
				jugadores.delete(client.id)
			}
	
	
			usuarios.delete(usuario)
	
	
		})
	
	
	
	}
}

io.on('connection',funcionesSocketIO)

iohttp.on('connection',funcionesSocketIO)

