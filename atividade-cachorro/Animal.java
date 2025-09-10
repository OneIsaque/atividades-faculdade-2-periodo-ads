// =================== CLASSE PAI ===================
public abstract class Animal {
    private String nomeDoAnimal;

    public Animal(String nomeDoAnimal) {
        this.nomeDoAnimal = nomeDoAnimal;
    }

    public void comer() {
        System.out.println(nomeDoAnimal + " está comendo.");
    }

    // O método getter agora é a única forma de acessar o nome fora da classe.
    public String getNomeDoAnimal() {
        return this.nomeDoAnimal;
    }
}