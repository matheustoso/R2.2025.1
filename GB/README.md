## Instalação

Basta baixar o arquivo executável na release [GB](https://github.com/matheustoso/R2.2025.1/releases/tag/GB)

A distribuição para macOS funciona melhor em terminais mais modernos, como o iTerm2 ou o terminal do VSCode. Devido a limitações no terminal padrão do macOS, a lib Textual utilizada para a UI pode apresentar inconsistências visuais e de performance.

## Uso

Ao executar o arquivo baixado, será exibida uma interface gráfica no terminal. Nessa interface é possível adicionar transmissores com o botão verde "+" na região inferior do terminal.

Com transmissores adicionados, podemos simular transmissões ativando a switch do transmissor. Múltiplos transmissores podem transmitir ao mesmo tempo.

Para cada transmissor temos as seguintes informações, da esquerda para a direita:

- Label do transmissor (o número no quadrado azul)
- Estados do transmissor, dos quais:
  - Sensing: estado onde o transmissor está verificando se o canal está ocupado antes de transmitir
  - Transmitting: estado onde o tranmissor envia seus dados, e fica escutando o canal por um tempo baseado no tamanho do canal (quantia de transmissores) para detectar se houve alguma colisão
  - Backoff: estado após o transmissor detectar um colisão durante seu período de transmissão. Nesse estado o transmissor espera um tempo exponencial aleatório truncado.
- Timer do Backoff, inicializado como 0
- Switch para iniciar transmissão
- Visor do canal, que mostra o estado atual do canal para o transmissor:
  - Visor preto: canal vazio
  - Visor verde: canal com dados
  - Visor laranja: canal com sinal de jamming
  - Visor vermelho: canal com colisão
 
Quanto a temporização da simulação, defini o tempo de propagação entre transmissores de 1 segundo, ou seja, se temos 3 transmissores, um sinal leva 3 segundos para ir de uma ponta à outra do canal.

O tempo de escuta por colisões após a transmissão é o dobro do tamanho do canal em segundos, para garantir que o sinal de jamming de uma colisão no extremo oposto do canal chegue ao transmissor que originou a colisão durante esse período de escuta.

O tempo do backoff é definido pelo tempo de transmissão do canal, sendo: 

```
k = (2^n) - 1
t = randint(0, k) * tc
```

Onde n é a quantia de backoffs da transmissão, começando como 1 no primeiro backoff, função randint retorna um inteiro entre 0 e k, e tc é o tamanho do canal. 

Por exemplo, se temos 3 transmissores e estamos no segundo backoff, temos k = 3, assim a função randint vai gerar um dos seguintes números [0, 1, 2, 3], e esse número será multiplicado pelo tamanho do canal, que nesse caso é 3. Assim o transmissor pode esperar 0, 3, 6 ou 9 segundos no cenário de exemplo.


## Debug

Caso queira debugar o código será necessário clonar o repositório, instalar as dependências e executar o arquivo main.py.

### Dependências

- Python >= 3.13
- lib Textual: pip install textual
