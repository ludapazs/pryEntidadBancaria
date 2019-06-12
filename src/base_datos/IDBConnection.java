
package base_datos;

import java.sql.Connection;
import java.sql.DriverManager;

public interface IDBConnection {
    
    final String URL = "jdbc:postgresql://localhost:5432/";
    final String DB = "bd_banco";
    final String USER = "postgres";
    final String PASSWORD = "123456789";
    
    default Connection conectarBD() {
        try {
            Class.forName("org.postgresql.Driver");
            return DriverManager.getConnection(URL + DB + "?charSet=UTF8", USER, PASSWORD);
        } catch (Exception e) {
            System.err.println("No se ha establecido la conexión con la base de datos");
            return null;
        }
    }
    
}
