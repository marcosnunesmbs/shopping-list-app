# Instruções para Docker - Shopping List App

Este documento contém instruções para construir e executar a aplicação Shopping List App usando Docker.

## Requisitos

- Docker instalado no seu sistema
- Acesso à internet para baixar as imagens base

## Construir a Imagem Docker

Para construir a imagem Docker, execute o seguinte comando no diretório raiz do projeto:

```bash
docker build -t shopping-list-app .
```

Isso irá construir uma imagem Docker com o nome `shopping-list-app`.

## Executar a Aplicação

Após a construção da imagem, você pode executar a aplicação com o seguinte comando:

```bash
docker run -p 8080:80 --name shopping-list-container shopping-list-app
```

Isso irá:
- Iniciar um contêiner chamado `shopping-list-container`
- Mapear a porta 8080 do seu computador para a porta 80 do contêiner
- Usar a imagem `shopping-list-app` que você construiu anteriormente

Agora você pode acessar a aplicação em seu navegador através do endereço:
```
http://localhost:8080
```

## Parar e Remover o Contêiner

Para parar o contêiner em execução:

```bash
docker stop shopping-list-container
```

Para remover o contêiner após parar:

```bash
docker rm shopping-list-container
```

## Desenvolvimento com Volume (Opcional)

Se você quiser desenvolver enquanto executa em um contêiner Docker, você pode usar um volume para montar seu código-fonte no contêiner:

```bash
docker run -p 8080:80 -v $(pwd):/app --name shopping-list-dev shopping-list-app
```

Note que este método é mais adequado para desenvolvimento e pode exigir configurações adicionais.
