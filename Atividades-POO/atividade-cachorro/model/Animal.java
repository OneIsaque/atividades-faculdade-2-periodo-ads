package model;


// ========= CLASSE PAI 
public abstract class Animal {
    private String nomeDoAnimal;

    public Animal(String nomeDoAnimal) {
        this.nomeDoAnimal = nomeDoAnimal;
    }
    
    public String getNomeDoAnimal() {
        return this.nomeDoAnimal;
    }
    
    public void comer() {
        System.out.println(nomeDoAnimal + " está comendo.");
    }
}