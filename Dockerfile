# Estágio de construção
FROM node:18-alpine as build

# Definir diretório de trabalho
WORKDIR /app

# Copiar arquivos de configuração do projeto
COPY package*.json ./
COPY vite.config.js ./
COPY tailwind.config.js ./
COPY jsconfig.json ./

# Instalar dependências
RUN npm ci

# Copiar o restante dos arquivos do projeto
COPY . .

# Construir a aplicação para produção
RUN npm run build

# Estágio de produção
FROM nginx:stable-alpine

# Copiar arquivos da aplicação buildada
COPY --from=build /app/dist /usr/share/nginx/html

# Copiar configuração personalizada do nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expor a porta 80
EXPOSE 80

# Iniciar o nginx no modo foreground para que o contêiner não encerre
CMD ["nginx", "-g", "daemon off;"]