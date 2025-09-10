package model;

import interfaces.Andador;
import interfaces.Voador;

public class Ave extends Animal implements Voador, Andador {
   private Raca raca = new Raca("Papacapin");

    public Ave(String nomeDoAnimal) {
        super(nomeDoAnimal);
    }

    public Raca getRaca() {
        return this.raca;
    }

    public void piar() {
        System.out.println(getNomeDoAnimal() + " está piando: Piu piu!");
    }
    
    @Override
    public void voar(){
        System.out.println(getNomeDoAnimal() + " está voando alto!");
    }

    @Override
    public void andar() {
        System.out.println(getNomeDoAnimal() + " está pulando.");
    }
}