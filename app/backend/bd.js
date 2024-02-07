let mysql = require('mysql2');

// Archivo de conexion con la base de datos

let connection = mysql.createConnection({
    connectionLimit : 100,
    host: 'db',
    user: 'root',
    password: 'example',
    database: 'INSTAFOTO'
}
)


connection.connect(error => {
    if(error) throw error;
    console.log("Conexión a la Bd completada");
})

module.exports = connection;

