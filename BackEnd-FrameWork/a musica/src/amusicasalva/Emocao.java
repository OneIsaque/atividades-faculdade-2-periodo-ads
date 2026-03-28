package amusicasalva;

public class Emocao {
    private String descricao;

    public Emocao(String descricao) {
        this.descricao = descricao;
    }

    public void manifestar() {
        System.out.println("Estado emocional alcançado: " + descricao);
    }
}
