# Oque é um Nó em Java?

Em resumo um nó *(Node)* é uma estrutura básica, como um pequeno organizador, que usamos para *construir estruturas mais complexas*, tipo listas, árvores e grafos. Imagine um nó como uma caixinha que guarda dados e ligações. 

Nas **listas encadeadas**, cada nó sabe quem é o próximo da fila. Nas **árvores**, um nó pode ter vários filhos, e nos grafos, ele pode se ligar a vários outros nós, criando várias conexões.

##### 📌Exemplo:

👉E m uma **árvore genealógica**. Cada pessoa (nó) pode ter filhos (referências para outros nós). Essa estrutura mostra como os nós se conectam em diferentes níveis.

```
class Node {
    String nome;
    Node esquerdo;
    Node direito;

    Node(String nome) {
        this.nome = nome;
        this.esquerdo = null;
        this.direito = null;
    }
}

Node raiz = new Node("Avô");
raiz.esquerdo = new Node("Filho 1");
raiz.direito = new Node("Filho 2");

```


<br>
<br>

---
# Atividade realizada:

🌐 Clique para [Atividade realizada](/ExecutandoNozinho.java).

---

<br>



