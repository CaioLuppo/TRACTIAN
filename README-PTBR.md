# TRACTIAN - Desafio Mobile (Versão em inglês: <a href="./README.dart">clique aqui</a>)

## Sumário

- [Desafio 🐱‍👤](#desafio-)
- [Vídeo de Demonstração 🎥](#vídeo-de-demonstração-)
- [O que poderia ser melhorado 🤔](#o-que-poderia-ser-melhorado-)
- [O que eu aprendi 📚](#o-que-eu-aprendi-)
- [Meus Toques 🎨](#meus-toques-)
- [Agradecimentos! 🙏](#agradecimentos-)
<br>
## Desafio 🐱‍👤
O desafio consiste em criar um aplicativo mobile que consuma a API da Tractian e exiba os dados em uma estrutura de árvore amigável, permitindo que os resultados sejam filtrados por nome, estado (crítico) e tipo de sensor (energia).

## Vídeo de Demonstração 🎥
[![Vídeo de Demonstração](https://img.youtube.com/vi/lB086EoCvzg/0.jpg)](https://youtu.be/lB086EoCvzg)

## O que poderia ser melhorado 🤔
- Os dados poderiam ser armazenados em um banco de dados local para melhorar o uso offline, usando, por exemplo, SQFLite e Floor.
- A função recursiva que constrói a árvore poderia ser otimizada para evitar mal desempenho, ou até usar uma abordagem diferente para montar a árvore.
- Uma abordagem melhor usando isolates para a funcionalidade de busca, a fim de evitar **congelamentos ao filtrar** muitos dados como na **terceira unidade**.
- Mais filtros de busca, além dos solicitados no desafio.
- **(API)** - Em um cenário real, a API poderia ter uma estrutura melhor para evitar rework desnecessário de dados, como reordenar os dados na hora de montar a árvore.

## O que eu aprendi 📚
- Mais sobre os isolates do Flutter e como usá-los em cenários diferentes dos que eu já havia utilizado.
- Alternativas e formas de otimizar funções recursivas.

## Meus Toques 🎨
- **MVVM** - Para melhor organização e arquitetura.
- **Isolates** - Para melhor performance na funcionalidade de busca.
- **Provider** e **MobX** - Para gerenciamento de estado.
- **Dio** - Para requisições HTTP.
- **dio_cache_interceptor** - Para cachear/armazenar requisições HTTP.
- **Logger** - Para logs melhores e mais agradáveis.
- **flutter_svg** - Para suporte a SVG.
- **Mocktail** - Para testar os repositórios.

## Agradecimentos! 🙏
- **TRACTIAN** - Pela oportunidade de participar deste desafio e aprimorar minhas habilidades de programação com este projeto incrível!
