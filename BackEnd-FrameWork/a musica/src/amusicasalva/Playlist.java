package amusicasalva;

import java.util.ArrayList;
import java.util.List;

// junta as músicas - uma playlist, né: ._.

public class Playlist {
    private String nome;
    private List<Musica> musicas;

    public Playlist(String nome) {
        this.nome = nome;
        this.musicas = new ArrayList<>();
    }

    public void adicionar(Musica m) {
        musicas.add(m);
    }

    public List<Musica> getMusicas() {
        return musicas;
    }
}