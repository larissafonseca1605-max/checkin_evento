# Check-in de Evento

Aplicativo desenvolvido em Flutter para gerar ingressos com QR Code e registrar a presença de participantes em um evento.

## Integrante

- Larissa Martins

## Funcionalidades

- Cadastro do nome e e-mail do participante.
- Geração de ingresso com QR Code.
- Leitura do QR Code utilizando a câmera do dispositivo.
- Validação dos dados do ingresso.
- Confirmação do check-in do participante.
- Identificação de check-ins duplicados.
- Identificação de QR Codes inválidos.
- Listagem dos participantes presentes e contagem dos check-ins confirmados.

## Tecnologias utilizadas

- Flutter
- Dart
- `qr_flutter`: geração dos QR Codes.
- `mobile_scanner`: leitura dos QR Codes pela câmera.

## Formato do QR Code

O conteúdo do QR Code segue o formato:

`CHECKIN|nome|email`

Os dados são separados pelo caractere `|`. O método `split()` é utilizado para separar as informações e permitir a validação do ingresso.

## Como executar o projeto

1. Instale o Flutter e configure o ambiente de desenvolvimento.
2. Clone este repositório.
3. Abra a pasta do projeto no Android Studio ou em outro editor compatível com Flutter.
4. Execute:

   ```bash
   flutter pub get
   ```

5. Conecte um dispositivo Android com a depuração USB habilitada ou inicie um emulador.
6. Execute:

   ```bash
   flutter run
   ```

A leitura de QR Codes exige acesso à câmera do dispositivo.

## Capturas de tela

### Ingresso gerado
![Ingresso gerado](screenshots/ingresso.png)

### Leitura do QR Code
![Leitura do QR Code](screenshots/leitura.png)

### Check-in confirmado
![Check-in confirmado](screenshots/checkin_confirmado.png)

## Observações

A lista de participantes é mantida apenas em memória durante a execução do aplicativo. Os dados não são armazenados permanentemente, e o projeto não utiliza banco de dados nem API externa.

Este projeto foi desenvolvido como atividade acadêmica para praticar gerenciamento de estado no Flutter, geração e leitura de QR Codes e validação de check-in.
