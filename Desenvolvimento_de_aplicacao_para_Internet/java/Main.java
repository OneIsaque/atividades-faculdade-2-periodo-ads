import java.util.Scanner;

public class Main {

  

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

  static void limparConsole() {
        System.out.print("\033[H\033[2J");
        System.out.flush();
    }

  static void pararTela(int segundos){
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

    
    
    while (true){
      app.texto_inicial();
      
      int opcao = sc.nextInt();
      sc.nextLine();

      


      switch (opcao) {
        case 1:

          System.err.println("Depositar");
          pararTela(2);
          limparConsole();

          break;

        case 2:
          /* Chama a função */
        case 3:
        case 4:
          System.out.println("Saindo...");
          sc.close();

          pararTela(2);
          limparConsole();
          return;
        default:
          System.out.println("Opção Inválida!");
          pararTela(2);
          limparConsole();

        
      }

      System.out.println("Você digitou: ");

    }
    
    


  }
    

}
