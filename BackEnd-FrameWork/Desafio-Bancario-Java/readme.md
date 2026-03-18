# 🏦 Sistema Bancário Simples (Java Console)

Projeto educacional focado na prática de lógica de programação e Orientação a Objetos em Java. O sistema simula operações básicas de uma conta bancária através de uma interface de linha de comando (CLI).

---

## 🚀 Funcionalidades

- **Depósito:** Adiciona valor ao saldo da conta com validação de entrada.
- **Saque:** Retira valor do saldo, verificando se há fundos suficientes.
- **Consulta de Saldo:** Exibe o saldo atual formatado em Real (BRL).
- **Encerramento:** Finaliza o sistema com uma contagem regressiva de segurança.
- **Interface Amigável:** Menu interativo com limpeza de console e formatação de moeda.

## 🛠️ Tecnologias Utilizadas

- **Linguagem:** Java (JDK 11 ou superior recomendado)
- **Orientação a Objetos:** Classes, Objetos, Encapsulamento e Métodos.
- **Bibliotecas Nativas:**
  - `java.util.Scanner` (Entrada de dados)
  - `java.text.NumberFormat` (Formatação monetária)
  - `java.util.Locale` (Internacionalização pt-BR)
  - `java.lang.Thread` (Controle de tempo/pausas)

## 📂 Estrutura do Projeto

```
📁├── Desafio-Bancario-Java
│   ├── Main.java
│   └── Conta.java
│   └──README.md

```


## ▶️ Como Executar

1. **Pré-requisitos:** Certifique-se de ter o [Java Development Kit (JDK)](https://www.oracle.com/java/technologies/downloads/) instalado.
2. **Compilação:** No terminal, navegue até a pasta do projeto e compile os arquivos:
   ```bash
   javac Main.java Conta.java

3. **Execução:** Rode a aplicação principal:
   ```bash
   java Main

## 🎓 Conceitos Aplicados
- **Encapsulamento:** Proteção dos dados da conta (saldo) através de modificadores de acesso.

- **Tratamento de Exceções:** Uso de try-catch para interrupções de thread.
Formatação: Adaptação de valores numéricos para o padrão monetário brasileiro.

- **Fluxo de Controle:** Uso de laços while e switch-case para navegação no menu.

## 🔜 POssíveis Melhorias Futuras
- Integração com Banco de Dados (JDBC/MySQL) para persistência de dados.

- Implementação de múltiplas contas/usuários.

- Correção de compatibilidade de limpeza de console para Windows.

---
## 📬 Contato
- Autor: Isaque João Pereira
- GitHub: OneIsaque
- Email: isaquejjpereira022@gmail.com
