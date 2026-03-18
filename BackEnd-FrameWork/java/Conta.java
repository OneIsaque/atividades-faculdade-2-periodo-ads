import java.text.NumberFormat;
import java.util.Locale;
import java.util.Scanner;
/** feito por isaque joão pereira -
 * github: OneIsaque
 * Contato email: isaquejjpereira022@gmail.com
 */
public class Conta{
    Scanner sc = new Scanner(System.in);
    
    private StringBuilder sb = new StringBuilder();
    
     NumberFormat brFormato = NumberFormat.getCurrencyInstance(new Locale("pt", "BR"));

    private double saldo;

    public double Sacar(double valor){
        
        if (valor > 0 && valor <= this.saldo){
            this.saldo = this.saldo - valor; 

            System.out.printf("Saque de R$: %.2f realizado com sucesso!\n", valor);

        } else {
            System.out.println("Saldo insuficiente ou valor inválido.");
        }
        
        
        return this.saldo;
    }

    public void contagemRegressiva(int segundos){
        
        for (int i = segundos; i >= 0; i--) {
            System.out.println("Saindo em... ["+ i +"] segundos.");
            Main.pararTela(1);
            Main.limparConsole();

        }
        
    }

    public Conta(double saldoInicial){
        this.saldo = saldoInicial;
    }

    public void depositar(double valor){
        getContaInfo();
        System.out.println("\n");


        
        if (valor > 0) {
            this.saldo += valor;
            System.out.println("Deposito de R$: " + brFormato.format(valor) + " realizado!");
        } else {
            System.out.println("Saldo insuficiente ou valor inválido.");
        }
    }

    public String getContaInfo(){
        sb = new StringBuilder();
        
        

        sb.append("--------------------").append("\n");
        sb.append("-----Info. Conta----").append("\n");
        sb.append("--------------------").append("\n");
        sb.append("--------------------").append("\n");
        sb.append("Saldo: ").append(brFormato.format(this.saldo)).append("\n");
        sb.append("--------------------").append("\n");
        
        return sb.toString();
    }

    public double getSaldo(){
        return this.saldo;
    }
   

    
}

