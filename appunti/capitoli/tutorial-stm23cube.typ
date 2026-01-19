#set page("a4")
#set text(lang: "it")


= Tutorial STM32CubeIDE

== Tutorial ep. 3
*Obiettivi*: Attivare il led verde connesso al pin PA5 tramite l'utilizzo delle librerie _HAL_ (Hardware Abstraction Layer).

Schematico Nucleo Board @fig:schematico-led-verde-tutorial-3, dove si individua che il led verde è collegato a PA5:
#figure(
  image("../image/tutorial-stmcubeide/tutorial-3/schematico-led-verde.png", width: 70% ),
  caption: [Schematico vicino al led verde.]
) <fig:schematico-led-verde-tutorial-3>


=== Passo 1: Setup del progetto 
Creazione del progetto: dentro la schermatda di "_information center_" cliccare *create/import STM32 project* e selezionare *STM32CubeIDE empty project*, successivamente appare la schermata di selezione del MCU (il microcontrollore).

Da datasheet l'MCU è: _STM32F411RET6_ (Cercare senza ultimo numero e si trova). È possibile anche cercare tramite la board ad esempio: _NUCLEO-F411RE_.

Al passo successivo dare il nome del progetto e cliccare fine.

*PROBLEMA* con questo procedimento non crea il file _.ioc_. È da creare il progetto con ST32CubeMX, selezionare la board, la toolchain (in questo caso STM32CubeIDE), dare il nome al progetto e generare il codice. Poi comparirà una schermata che chiede se si vuole aprire il progetto e si aprirà dentro _ST32CubeIDE_.

Durante la configurazione si è impostato il pin PA5 come *GPIO OUTPUT* e rinominato con LED_GREEN. E abilitato il *serial wire* (per le interfacce di debug) in system core $->$ sys $->$ debug: _Serial Wire_.

=== Passo 2: Coding
*Quando si scrive codice è necessario scriverlo all'interno dei blocci commentati delimitati da $mono("/*USER CODE START*/")$ e $mono("/*USER CODE END/*")$ se il codice viene scritto al di fuori di questi blocchi con le auto-generazioni poi verrà eliminato.*

Per scriver il codice relatico all'accensione del led si scrive dentro il while all'interno del file: $mono("Core/Src/main.c")$ il seguente codice:

$mono("HAL_GPIO_TogglePin(LED_GREEN_GPIO_Port, LED_GREEN_Pin);
HAL_Delay(500);")$

=== Passo 3: Lancio dell'applicazione
Per lanciare l'applicazione, si deve eseguire la build, con il tasto "_martello_" e successivamente si può lanciare l'applicazione con il tasto per il debug.


== Tutorial ep.4
*Obiettivi*: Controllare il LED tramite il pulsante tramite le External Interrupt (EXTI). Inoltre si configura  l'*Interrupt Controller* NVIC, @fig:schematico-pulsante-user-tutorial-4.

#figure(
  image("../image/tutorial-stmcubeide/tutorial-4/schematico-pulsante-user.png", width: 70% ),
  caption: [Schematico pulsante user.]
) <fig:schematico-pulsante-user-tutorial-4>

Dopo la creazione del progetto configurare il pin PC13, relativo al bottone, come GPIO_EXTI. successivamente dentro _System core $->$ GPIO_ selezionare PC13 e impostarlo come _External interrupt mode with falling edge trigger detection_. Inoltre abilitare nell'interrupt controller NVIC le interrupt delle *EXTI line*. 

Dichiarare una variabile #math.mono("uint8_t flag=0") mettere la logica nel ciclo while, ovvero se il flag è 1 allora esegue il toggle del pin e resetta a 0 il flag. Successivamente è necessario gesire l'interrupt generato dalla pressione del pulsante per farlo:
- Aprire il file: #math.mono("stm32f4xx_it.c") $->$ trovare la funzione relativa alle *EXTI* $->$ aprire la dichiarazione della funzione dell'handler $->$ copiare la definizione del *callback* $->$ copiarla nel #math.mono("main.c") nella sezione relativa al codice utente $->$ implementarla, in questo caso porre il flag a 1. 
