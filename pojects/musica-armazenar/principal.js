const { MongoClient, ObjectId } = require("mongodb");

const url = "mongodb://localhost:27017";
const dbName = "meu_banco_musicas";

async function conectar() {
    const client = new MongoClient(url);
    await client.connect();
    console.log("✅ Conectado ao MongoDB");
    return client;
}

// estrutura do documento de musica no MongoDB-----
// {
//   "titulo": "Imagine",
//   "artista": "John Lennon",
//   "album": "Imagine",
//   "ano": 1971,
//   "genero": ["Rock", "Soft Rock"],
//   "duracao_segundos": 183,
//   "tags": ["clássico", "anos 70"]
// }

//-------------------------------

// Execução principal

// Adicionar música
async function adicionarMusica(musica) {
    const client = await conectar();
    const db = client.db(dbName);
    await db.collection("musicas").insertOne(musica);
    console.log("🎵 Música adicionada!");
    await client.close();
}

// Editar música por ID
async function editarMusica(id, novosDados) {
    const client = await conectar();
    const db = client.db(dbName);
    await db.collection("musicas").updateOne(
        { _id: new ObjectId(id) },
        { $set: novosDados }
    );
    console.log("✏️ Música editada!");
    await client.close();
}

// Excluir música por ID
async function excluirMusica(id) {
    const client = await conectar();
    const db = client.db(dbName);
    await db.collection("musicas").deleteOne({ _id: new ObjectId(id) });
    console.log("🗑️ Música excluída!");
    await client.close();
}

// Listar todas as músicas
async function listarMusicas() {
    const client = await conectar();
    const db = client.db(dbName);
    const musicas = await db.collection("musicas").find().toArray();
    console.log("📀 Lista de músicas:");
    console.table(musicas);
    await client.close();
}

// ===== EXEMPLOS DE USO =====
(async () => {
    // 1️⃣ Adicionar música
    await adicionarMusica({
        titulo: "Imagine",
        artista: "John Lennon",
        ano: 1971,
        genero: "Rock"
    });

    // 2️⃣ Listar músicas
    await listarMusicas();

    // 3️⃣ Editar música (substitua pelo ID real mostrado na listagem)
    // await editarMusica("ID_AQUI", { genero: "Soft Rock" });

    // 4️⃣ Excluir música (substitua pelo ID real mostrado na listagem)
    // await excluirMusica("ID_AQUI");
})();