import mysql.connector
import secrets

try:

    cnx = mysql.connector.connect(user='instafoto', password='claveUser1¿',
                                host='127.0.0.1',
                                database='INSTAFOTO')

    cursor = cnx.cursor()

    inserciones = []
    for i in range(0,10):
        inserciones.append((secrets.token_hex(8).upper(),100)) 



    cursor.executemany("INSERT INTO CODIGOSMONETARIOS (codigo,cantidad) VALUES(%s,%s)",inserciones)

    cnx.commit()

    print(cursor.rowcount, "record inserted.")

except mysql.connector.Error as error:
    print("Failed to insert into MySQL table {}".format(error))

finally:
    if cnx.is_connected():
        cursor.close()
        cnx.close()
        print("MySQL connection is closed")