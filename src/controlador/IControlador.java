
package controlador;

import java.awt.Component;
import java.awt.Container;
import java.lang.reflect.Field;

public interface IControlador {
    
    default Component getComponentByName(String name, Container frame) {
        for (Field field : frame.getClass().getDeclaredFields()) { 
            field.setAccessible(true); 
            if (name.equals(field.getName())) { 
                try {
                    return (Component) field.get(frame); 
                } catch (Exception e) {
                }
            }
        } 
        return null; 
    }
    
}
