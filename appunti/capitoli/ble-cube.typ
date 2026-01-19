#set page("a4")
#set text(lang: "it")
#set par(justify: true, first-line-indent: (amount: 0.5em, all: true))
#set heading(numbering: "1.1.")

// Import dei pacchetti
#import "@preview/subpar:0.2.2" // Sottofigure (subfigure)



= BLE

//preso da stm32 wiki

Bluetooth è una tecnologia per la comunicazione comunicazione wireless *low-power*, *short-range*, *WPAN* (wireless personal area network). Essa è principalmente divisa in due categorie:

// preso da: https://www.analog.com/en/resources/technical-articles/understanding-architecture-bluetooth-low-energy-stack.html

- _Bluetooth Classic_: Rappresenta una prima versione del bluetooth con maggiore _trough-put_ di dati, con 79 diversi canali in cui su 32 si può effettuare il _discovery_#footnote("Con _discovery_ si intende il processo di ricerca di altri dispositivi bluetooth
").
- _Bluetooth Low Energy_ o _BLE_: Utilizzato per comunicazioni poco frequenti, come dati di sensori, presenta 40 canali e può fare _discovery_ su 3 di essi.
#v(1em)
Una tipica applicazione consiste in due dispositivi: periferica (_peripheral_) e il centrale (_central_). Per stabilire la connessione il _central_ esegue uno _scan_ per ricercare _peripheral_ disponibili, nel mentre la _peripheral_ si pone nello stato di _advertising_.

Una volta stabilita la connessione i due dispositivi possono iniziare la comunicazione.

== Bluetooth in STM32WB //preso da: an5289-how-to-build-wireless-applications-with-stm32wb-mcus-stmicroelectronics.pdf

L'architettura del BLE in STM32WB è composta da due CPU:
- La prima, CPU1 (ARM M4), è per il nomale utilizzo della board.
- La seconda, CPU2 (ARM M0+), è utilizzata per le trasmissioni wireless, come: BLE, Thread e MAC 802_15_4.

La comunicazione tra le due CPU è fatto via "mailbox". Tutte le periferie condivise da entrambe le CPU sono protette da dei semafori a livello hardware, _HSEM_, @fig:ble-in-stm32-hsem.

La memoria Flash utilizzata dai due core è la stessa, essa è divisa ed è protetta da accessi. In particolare solo la CPU1 può accedere alla area di memoria della CPU1, lo stesso vale per la CPU2 e la sua area di memoria.

#figure(
  image("../image/ble/ble-in-stm32wb/semafori-ble.png", width: 50%),
  caption: [_HSEM_ per il BLE.],
) <fig:ble-in-stm32-hsem>

=== Sequencer
Il _sequencer_ ha il compito di eseguire le funzioni registrate una dopo l'altra, supporta fino a 32 funzioni, è possibile eseguire le funzioni su richiesta e disabilitare l'esecuzioni.

Fornisce quindi un semplice background per schedulare le funzioni. Implementa in modo sicuro la modalità in _low-power-mode_ quando il sequencer non ha nessun task da eseguire
I passi principali per utilizzarlo sono:
// + Impostare il numero massimo di funzioni supportate definendo il valore per `UTIL_SEQ_CONF_TASK_NBR`
+ Creare aggiungere un nuovo elemento negli enumerativi: `CFG_Task_Id_With_HCI_Cmd_t` all'interno del file `app_conf.h`. Per task che non fanno parte del BLE è necessario creare nuovi elementi dentro: `CFG_Task_Id_With_NO_HCI_Cmd_t`;
+ Registrare la funzione al sequencer: `UTIL_SEQ_RegTask()` , come secondo parametro `UTIL_SEQ_RFU`;
+ Avviare il sequencer: `UTIL_SEQ_Run()` (SE NON GIÀ FATTO);
+ Chiamare la funzione `UTIL_SEQ_SetTask()` quando serve che una funzione venga eseguita.

Per Ulteriori informazioni consultare: AN5289

A @fig:ble-in-stm32-sequencer-fun sono presenti le diverse funzioni.

#figure(
  image("../image/ble/ble-in-stm32wb/sequencer-fun.png", width: 50%),
  caption: [Funzioni per il _sequencer_.],
) <fig:ble-in-stm32-sequencer-fun>


=== Timer Server
Fornisce la possibilità di creare diversi timer in condivisione con l'RTC wake-up timer. È possibile creare dei timer in _sigle shot_ oppure in _repeated mode_, metterli in pausa, eliminarli e ravviarli con diversi timeout con un valore compreso tra $1$ e $2^32 - 1$ ticks. Quando un timer termina notifica l'utente e si riavvia (se impostato come _repeated_).

Fare attenzione che se l'operazione all'interno della funzione di _callback_ è richiede del tempo, è meglio eseguire la funzione dal *sequencer*

Per utilizzare il timer è necessario:
+ Creare il timer con `HW_TS_Create(CFG_TIM_PROC_ID_ISR , ...)`, e verificare il valore di ritorno che indica se è stato creato correttamente
+ (NON È VERO SU PUÒ UTILIZZARE QUELLA GIÀ DEFINITA) Ridefinire la funzione `HW_TS_RTC_Int_AppNot(...)`
+ Avviare il timer `HW_TS_Start(...)`

*Problematiche riscontrate:*
- MCU si bloccava in un loop continuo senza mai uscire -> Verificare se è attivo il WakeUp e l'RTC wake-up NVIC in CubeMX.
- La quando viene chiamata la funzione `HW_TS_RTC_Int_AppNot(...)` richiama la funzione handler che è un puntatore nullo (0x0) -> Fare attenzione che si utilizza sempre lo stesso ID quando viene creato il timer quando viene avviato, in particolare quando viene creato il timer tramite `HW_TS_Create(...)`, `pTimerId` è un puntatore all'*ID*.

Per fare un timer da $X$ secondi utilizzare la seguente formula: $(X dot 10^6)/"CFG_TS_TICK_VAL"$

Per Ulteriori informazioni consultare: AN5289 Sezione 4.5


=== Low Power Manager
Fornisce un'interfaccia per un massimo di 32 utenti e permette di eseguire computazioni nella modalità a più basso consumo disponibile al sistema. Le features disponibili sono:
- Stop mode e Off mode (standby e shutdown);
- Esecuzione e selezione della modalità low-power;
- Funzioni di callback quando si entra o si esce dalle modalità low-power

Il low-power mode per la CPU2 è fatto in modo automatico, in particolare il firmware imposta in modo autonomo la configurazione migliore di low-power mode.


=== FUOTA (Firmware Update On-The-Air) // INFO da How to build-ble-application. inotre c'è video su yt:
//https://youtu.be/4eLB5Qb6DC0?si=GZVmfXwklsgcJXp-

Il FUOTA è una applicazione _standalone_ che permette di scaricare: un nuovo CPU2 wireless stack, applicazioni per la CPU1 oppure file binari di configurazione.

Richiede che i primi sei settori della memoria flash dell'applicazione non vengano mai eliminati, poiché sarà li dove l'applicazione FUOTA sarà installata, @fig:ble-mem-cpu.

#figure(
  image("../image/ble/ble-in-stm32wb/flash-mem-cpus.png", width: 35%),
  caption: [Divisione della memoria tra le due CPU.],
) <fig:ble-mem-cpu>

Come detto in precedenza, le due CPU condividono lo stesso banco di memoria, la quale è divisa da una barriera di sicurezza. La sezione per la CPU1 parte dal basso con la memoria per OTA a seguire fino alla barriera c'è l'applicazione dell'utente. Dopo la barriera è presente la zona di memoria per la CPU2.

L'applicazione OTA, è semplicemente un servizio BLE che espone 3 caratteristiche:
+ _Base Address_ (WRITE): serve per indicare l'indirizzo base dove effettuare il flash dei dati.
+ _OTA raw data_ (WRITE): caratteristica per il trasferimento del binario, e.g. applicazione o file di configurazione.
+ _file upload confimation_ (INDICATION): caratteristica per che indica al che il trasferimento è andato a buon fine.
Ci son dei passi necessari che si fare nella _User Application_ per integrare l'OTA:
+ Nell'applicazione BLE è necessario inserire una caratteristica: _OTA Reboot request_
+ Il secondo passo consiste nel cambiare l'advertising.
*Primo passo*: facendo un esempio con l'applicazione _Heart Rate_, @fig:ble-heart-rate, per integrare il servizio OTA in questa applicazione è necessario aggiungere la caratteristica _OTA reboot request_. Quindi quando il client scrive su questa caratteristica richiede di effettuare il reboot per avviare l'applicazione OTA, è possibile anche definire l'area di memoria di partenza nella quale effettuare la modifica.

*Secondo passo*: Nella modalità advertising è possibile impostare una _feature mask_, la quale fornisce informazioni su quale _features_ implementa quel dispositivo. In particolare la maschera ha a disposizione 32 bit (4 byte) ogni bit ha un valore specifico, @fig:ble-feature-mask. Quindi ponendo il bit 13 a uno, si indicherà che l'applciazione BLE ha la possibilità di eseguire l'OTA reboot.

#figure(
  image("../image/ble/ble-in-stm32wb/esempio-ble-heart-rate.png", width: 90%),
  caption: [Esempio BLE heart rate.],
) <fig:ble-heart-rate>

#figure(
  image("../image/ble/ble-in-stm32wb/feature-mask.png", width: 75%),
  caption: [Valori per il _feature mask_.],
) <fig:ble-feature-mask>

All'avvio, la CPU1 cerca se c'è una richiesta dell'OTA di installazione di una nuova applicazione, se non è presente viene bypassata e si avvia l'applicazione d'utente

Di seguito vengono descritti i seguenti passi per l'aggiornamento della CPU1:
+ Una volta eseguita la connessione GAP, il dispositivo remoto GATT esegue una scansione dei servizi e delle caratteristiche.
+ Con l'obiettivo di eseguire lo switch all'applicazione FUOTA, il dispositivo remoto scrive la richiesta di _Reboot_ sulla caratteristica con le relative informazioni riguardanti le modalita di _boot_ e i settori da eliminare.
+ Il dispositivo si disconnette per ravviare sull'applicazione che permette di eseguire la FUOTA.
+ I settori dell'applicazione vengono eliminati seguendo le istruzioni date precedentemente, inoltre l'applicazione FUOTA GATT si avvia ponendosi in _advertising mode_.
+ La connessione viene stabilita con il dispositivo in ricerca del servizio FUOTA
+ La caratteristica di indirizzo base è utilizzata per iniziare il nuovo caricamento binario.
+ Tutti i dati vengono trasferiti tramite la caratteristica _raw data_ e programmati direttamente nella memoria flash.
+ La fine del trasferimento è confermata dalla caratteristica base di indirizzo.
+ La conferma della ricezione del file indicata dalla caratteristica di conferma del file.
+ A questo punto l'applicazione FUOTA esegue una verifica di integrità del binario e ravvia per avviare la nuova applicazione caricata.
+ Se l'integrità dell'applicazione non è assicurata, il settore dell'applicazione vine eliminato per ravviare nuovamente l'applicazione FUOTA.

A figura @fig:ble-in-stm32-esempio-fuota è riportato un esempio dei passi per eseguire il FUOTA.

#figure(
  image("../image/ble/ble-in-stm32wb/esempio-fuota.png", width: 90%),
  caption: [Esempio FUOTA.],
) <fig:ble-in-stm32-esempio-fuota>

== Attivazione BLE STM32  // Video tutorial stm32 WB series: "laboratorio 12"
Per abilitare il middleware del bluetooth è necessario attivare diverse funzionalità necessarie per far funzionare il BLE:
+ Per prima cosa andare dentro *RCC* (Resets and Clock), e attivare *HSE* (High Speed External crystal da $32"MHz"$) e *LSE* (Low Speed External crystal $32'768"Hz"$). Il primo clock è utilizzato per generare il di _carrier_ nel livello fisico del BLE, mentre il secondo è utilizzato per sincronizzare i diversi processi.
+ In secondo si deve attivare il *HSEM*, @sec:ble-HSEM.
+ Successivamente andare dentro *IPCC* (_inter processor communication controller_, @sec:ble-IPCC) attivarlo e nelle impostazioni per *NVIC* attivare anche:
  - _IPCC RX occupied interrupt_
  - _IPCC TX free interrupt_
+ Attivare il *RTC*, @sec:ble-RTC, porre il _wake-up_ come "Internal WakeUp" e successivamente spuntare nella sezione *NVIC* l'interrupt.

+ Infine è necessario attivare la *RF*, @sec:ble-RF (dentro _Connectivity_)

Ora è possibile cercare dentro "_Middleware and Software Pack_" il middleware: "STM32_WPAN" e spuntare il BLE.
In questo caso dentro le impostazioni del BLE è attivata l'opzione "_Custom P2P server_" per questo tutorial, dato che si vuole avere un controllo maggiore del BLE, lo si disattiva; mentre verrà attivando il "_Custom Template_".

#v(1em)
*Controllo del _Advertising_*: È possibile controllare il contenuto del pacchetto per l'_advertising_ nella sezione relativa. ad esempio si può modificare il nome del dispositivo modificando la variabile: `AD_TYPE_COMPLETE_LOCAL_NAME`

#v(1em)
*Creazione di un servizio*: Per la creazione di un servizio andare nella sezione *GATT* (Generic Attribute Profile), e porre il numero di servizi che si vogliono creare.
Successivamente indicare il nome del servizio, è possibile dare due nomi: _long name_ e _short name_.
Fatto ciò si creerà un nuovo _tab_ con il nome del servizio, è possibile definire il UUID (_universally unique identifier_). Definire il nome della caratteristica e impostare la, o le, proprietà della caratteristica (`write`, `read`, `notify`, ecc.) in questo esempio si imposta la proprietà di `write`. Inoltre si possono attivare o disattivare gli eventi a cui non si è interessati, in questo caso si tiene attivo solo l'evento: `GATT_NOTIFY_ATTRIBUTE_WRITE`

#v(1em)
Le ultime modifiche da fare riguardano il clock (sezione _Clock Configuration_), in particolare impostare:
- *RTC* su *LSE*
- *RF* _WakeUp Clock_ su *LSE*


#v(1em)
Per informazioni dettagliate visionare questo link: #link("https://wiki.st.com/stm32mcu/wiki/Connectivity:STM32WB_BLE_STM32CubeMX", text("STM32 P2P SERVER"))

=== Funzionalità/Periferiche utilizzate
Di seguito vengono descritte brevemente le periferiche attivate per utilizzare il bluetooth.

==== HSEM <sec:ble-HSEM>
Hardware Semaphore, è una periferia utilizzata per sincronizzare gli accessi dai due diversi _core_ nelle periferie condivise.

==== IPCC <sec:ble-IPCC>
L'_inter processor communication controller_ . Le i due diversi _core_ nei processori _WB_ comunicano attraverso della memoria condivisa (_SRAM2_) @fig:ble-shared-memory. E la *IPCC* è responsabile del meccanismo di messaggi tra i due _core_, ad esempio può generare degli interrupt per avvisare che un messaggio è pronto o che è stato letto.

#figure(
  image("../image/ble/shared-memory.png", width: 27%),
  caption: [Schematico in cui si osserva *IPCC* e la shared memory.],
) <fig:ble-shared-memory>

==== RTC <sec:ble-RTC>

L'*RTC* è un timer real time, esso fornisce il l'orario e la data attuale e ha la possibilità di attivare degli allarmi (interrupt). Esso può eseguire il wake-up del dispositivo dalle modalità low power

==== RF <sec:ble-RF>
_Radio Frequency_ è il modulo che effettua la comunicazione wireless per il BLE.



== Info caratteristiche

- *READ*: Quando viene creata una nuova caratteristica di _READ_ assicurarsi che sia attivato, in CubeMX sezione `Characteristic GATT event`, l'evento relativo alla lettura: `GATT_NOTIFY_READ_REQ_AND_WAIT_FOR_APPL_RESP`


