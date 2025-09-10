package app;

import model.Raca;
import model.Ave;
import model.Cachorro;  

public class Main {
    public static void main(String[] args) {
        // --- Testando o Cachorro ---
        Raca viraLata = new Raca("Vira-lata");
        Cachorro meuCachorro = new Cachorro("Pretinho", viraLata);

        System.out.println("=====| Animais: Cachorro e Ave| =====\n");
        
        System.out.println("\n--- Informações de " + meuCachorro.getNomeDoAnimal() + " ---\n");
        System.out.println("Nome do cachorro: " + meuCachorro.getNomeDoAnimal());
        System.out.println("Raça do cachorro: " + meuCachorro.getRaca().getNomeDaRaca());
        
        System.out.println("\n ----- Ações do Cachorro ----- \n");
        
        meuCachorro.comer();
        meuCachorro.latir();
        meuCachorro.andar();

        System.out.println("\n----------------------------------\n");

        // --- Testando a Ave ---
        Ave meuPassaro = new Ave("Piu-Piu");

        System.out.println("--- Informações de " + meuPassaro.getNomeDoAnimal() + " ---\n");
        System.out.println("Nome da ave: " + meuPassaro.getNomeDoAnimal());
        System.out.println("Raça da ave: " + meuPassaro.getRaca().getNomeDaRaca());
        
        System.out.println("\n ----- Ações da Ave ----- \n");

        meuPassaro.comer();
        meuPassaro.piar();
        meuPassaro.andar();
        meuPassaro.voar();

        System.out.println("\n----------------------------------\n");
    }
}