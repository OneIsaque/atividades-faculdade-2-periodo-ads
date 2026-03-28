package amusicasalva;

public class Musica {
    private String titulo;
    private int bpm; 

    public Musica(String titulo, int bpm) {
        this.titulo = titulo;
        this.bpm = bpm;
    }

    public String getTitulo() {
        return titulo;
    }

    public int getBpm() {
        return bpm;
    }
}
