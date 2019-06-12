
package modelo;

public class MovimientoFrecuente {
    
    private int id;
    private Cliente cliente;
    private TipoMovimiento tipoMovimiento;
    private Cuenta cuenta;
    private Cuenta cuentaDestino;
    private Cuota cuota;
    private ServicioBrindado servicioBrindado;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Cliente getCliente() {
        return cliente;
    }

    public void setCliente(Cliente cliente) {
        this.cliente = cliente;
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

    public ServicioBrindado getServicioBrindado() {
        return servicioBrindado;
    }

    public void setServicioBrindado(ServicioBrindado servicioBrindado) {
        this.servicioBrindado = servicioBrindado;
    }
    
}
