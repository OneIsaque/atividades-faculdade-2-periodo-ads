class Nozinho {
    int data;     
    Nozinho no; 

    // construtor
    public Nozinho(int data) {
        this.data = data;
        this.no = null; 
    }
}

public class ExecutandoNozinho {
    public static void main(String[] args) {

        Nozinho n1 = new Nozinho( 230);
        Nozinho n2 = new Nozinho(450);

        n1.no = n2;

        System.out.println("Nó 1: " + n1.data);      
        System.out.println("Nó 2: " + n1.no.data);  
    }
}
