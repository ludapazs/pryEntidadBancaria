
package modelo;

import java.util.Date;

public class Movimiento {
    
    private int id;
    private Movimiento movimientoAsociado;
    private Canal canal;
    private TipoMovimiento tipoMovimiento;
    private Cuenta cuenta;
    private Cuenta cuentaDestino;
    private Cuota cuota;
    private Empleado empleado;
    private ServicioBrindado servicioBrindado;
    private float monto;
    private Date fecha;
    private String cci;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Movimiento getMovimientoAsociado() {
        return movimientoAsociado;
    }

    public void setMovimientoAsociado(Movimiento movimientoAsociado) {
        this.movimientoAsociado = movimientoAsociado;
    }

    public Canal getCanal() {
        return canal;
    }

    public void setCanal(Canal canal) {
        this.canal = canal;
    }

    public TipoMovimiento getTipoMovimiento() {
        return tipoMovimiento;
    }

    public void setTipoMovimiento(TipoMovimiento tipoMovimiento) {
        this.tipoMovimiento = tipoMovimiento;
    }

    public Cuenta getCuenta() {
        return cuenta;
    }

    public void setCuenta(Cuenta cuenta) {
        this.cuenta = cuenta;
    }

    public Cuenta getCuentaDestino() {
        return cuentaDestino;
    }

    public void setCuentaDestino(Cuenta cuentaDestino) {
        this.cuentaDestino = cuentaDestino;
    }

    public Cuota getCuota() {
        return cuota;
    }

    public void setCuota(Cuota cuota) {
        this.cuota = cuota;
    }

    public Empleado getEmpleado() {
        return empleado;
    }

    public void setEmpleado(Empleado empleado) {
        this.empleado = empleado;
    }

    public ServicioBrindado getServicioBrindado() {
        return servicioBrindado;
    }

    public void setServicioBrindado(ServicioBrindado servicioBrindado) {
        this.servicioBrindado = servicioBrindado;
    }

    public float getMonto() {
        return monto;
    }

    public void setMonto(float monto) {
        this.monto = monto;
    }

    public Date getFecha() {
        return fecha;
    }

    public void setFecha(Date fecha) {
        this.fecha = fecha;
    }

    public String getCci() {
        return cci;
    }

    public void setCci(String cci) {
        this.cci = cci;
    }
    
}
