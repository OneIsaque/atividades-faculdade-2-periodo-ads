package amusicasalva;

public class Menina {
    private String nome;
    private String humor;

    public Menina(String nome) {
        this.nome = nome;
        this.humor = "Triste"; 
    }

    public void ouvir(Musica musica) {
        System.out.println(nome + " está ouvindo agora: " + musica.getTitulo());
        
        //se a música for alegre (BPM alto), ela fica feliz
        if (musica.getBpm() >= 100) {
            this.humor = "Feliz";
            System.out.println("Resultado: A música alegrou o coração de " + nome + "!");
        } else {
            System.out.println("Resultado: " + nome + " continua pensativa...");
        }
    }

    public String getHumor() {
        return humor;
    }

    public String getNome() {
        return nome;
    }
}