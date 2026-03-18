import java.util.Scanner;
import java.util.Locale;

public class Main {

/** feito por isaque joão pereira 
* github: OneIsaque
* Contato email: isaquejjpereira022@gmail.com
*/

  private void texto_inicial() {

    StringBuilder sb = new StringBuilder();
    sb.append("======================").append("\n");
    sb.append("  Banco Não Mastir").append("\n");
    sb.append("======================").append("\n").append("\n");
    sb.append("Escolha qual operação irá ser realizada:").append("\n").append("\n");
    sb.append("[1] - Depositar").append("\n");
    sb.append("[2] - Sacar").append("\n");
    sb.append("[3] - Consulta").append("\n");
    sb.append("[4] - Sair").append("\n").append("\n");

    String textoTitulo = sb.toString();
    System.out.println(textoTitulo);
  }

  public static void limparConsole() {
        System.out.print("\033[H\033[2J");
        System.out.flush();
    }

  public static void pararTela(int segundos){
    try{
        Thread.sleep(segundos * 1000);
    } catch (InterruptedException e){          
      Thread.currentThread().interrupt();
      System.err.println("Delay interrompido:" + e.getMessage());
    }
  }




  public static void main(String[] args) {
    Scanner sc = new Scanner(System.in);
    Main app = new Main();

    Conta cta = new Conta(0);

    
    while (true){
      app.texto_inicial();
      int opcao = sc.nextInt();
      sc.nextLine();

      cta.getContaInfo();


      switch (opcao) {
        case 1:
          limparConsole();
          
          System.out.println("Insira o valor para sacar:(00,00) ");
          double valorDeposito = sc.nextDouble();
          cta.depositar(valorDeposito);
          
          pararTela(2);
          limparConsole();
          
          break;
          case 2:
            limparConsole();

            System.out.println("Insira o valor de saque:(00,00) ");
            cta.Sacar(sc.nextDouble());
            pararTela(2);
            break;

          case 3:
              limparConsole();
              boolean voltar = false;
              
              for (boolean i = false; i != true; i = voltar){
                limparConsole();
                System.out.println(cta.getContaInfo());
                
                System.out.println("Aperte a tecla 's' para voltar.");
                String respostaVoltar = sc.nextLine();
                
                if (respostaVoltar.equalsIgnoreCase("s") || respostaVoltar.isEmpty()) { /*Em Java, nunca use == para comparar Strings. Use .equals() ou .equalsIgnoreCase(). */
                  voltar = true;
                }
              }
              limparConsole();
          break;

        case 4:
          limparConsole();
          cta.contagemRegressiva(3);
          

          sc.close();

          return;
        default:
          System.out.println("Opção Inválida!");
          pararTela(2);
          limparConsole();

        
      }

      

    }
    
    


  }
    

}
