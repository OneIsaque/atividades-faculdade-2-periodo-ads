let url = 'https://rickandmortyapi.com/api/character'

async function Nome() {
    let resposta = await fetch(url)
    let body = await resposta.json()
    let teste = document.getElementById('lista')

    for (let index = 0; index < body.results.length; index++) {
        let ite = document.createElement('li')
        filtragem = `${body.results[index].name} - ${body.results[index].species}`
        let texto = JSON.stringify(filtragem)
        
        ite.textContent = texto
        teste.appendChild(ite)
    }
}

Nome()