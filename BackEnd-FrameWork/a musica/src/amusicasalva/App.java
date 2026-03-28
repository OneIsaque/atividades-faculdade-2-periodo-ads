package amusicasalva;

public class App {
    public static void main(String[] args) {
        Menina ana = new Menina("Ana");
        Instrumento violao = new Instrumento("Piano", "Do-Ré-Mi suave");
        Musica musicaFeliz = new Musica("Psiu - Liniker", 120);
        Emocao alegria = new Emocao("Pura Alegria");

        System.out.println("Início da atividade: " + ana.getNome() + " está " + ana.getHumor());

        // ---
        violao.tocar();
        ana.ouvir(musicaFeliz);

        // ---
        if (ana.getHumor().equals("Feliz")) {
            alegria.manifestar();
        }
    }
}