package amusicasalva;

public class Instrumento {
    private String nome;
    private String som;

    public Instrumento(String nome, String som) {
        this.nome = nome;
        this.som = som;
    }

    public void tocar() {
        System.out.println("O " + nome + " emite um som: " + som);
    }
}