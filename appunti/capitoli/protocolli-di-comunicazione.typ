#import "@preview/subpar:0.2.2" // Sottofigure (subfigure)

= Protocolli

== Protocollo SPI

Il protocollo SPI è un protocollo sincrono _full-duplex_, dove i dati sono sincronizzati dai fronti di salita del clock. Esso nella vesrione più usata presenta 4 cavi:
- *CS*: _Chip Selector_ senale per selezionare il subnode, il segnale di attivazione tipicamente è un segnale _LOW_;
- *SCLK*: _SPI Clock_ clock di trasmissione;
- *MOSI*: _Master Output Slave Input_ (_Main Output Subnode Input_) canale di trasmissione dal main al subnode.
- *MISO*: _Master Input Slave Output_ (_Main Input Subnode Output_) canale di trasmissione dal subnode al main;

A differenza dell'$"I"^2 "C"$, *SPI* presenta un solo _master_ (o _main_),colui che genera il _clock_, e può lavorare a frequenze più elevate. Una configurazione tipica è rappresentata a @fig:spi-connessioni-main-subnodes

#figure(
  image("../image/protocollo-spi/collegamento-main-subnodes.png", width: 60% ),
  caption: [Esempio di collegamento tra il _main_ e tre _subnodes_]
) <fig:spi-connessioni-main-subnodes>

Per avviare una comunicazione è necessario avviare il clock e impostare a _LOW_ il relativo _CS_.
Il _clock_ determina la frequenza di trasmissione in particolare è presente un registro scorrevole il quale scorre ad ogni fronte si salita (o di discesa#footnote("Dipende dall'implementazione")) del _clock_ trasmettendo il bit sul canale *MISO* o *MOSI*.

La *polarità* (_CPOL_) e la fase del *clock* (_CPHA_) caratterizzano la comunicazione:
- *Mode 0*: _CPOL_ $= 0$ e _CPHA_ $= 0$
- *Mode 1*: _CPOL_ $= 0$ e _CPHA_ $= 1$
- *Mode 2*: _CPOL_ $= 1$ e _CPHA_ $= 0$
- *Mode 3*: _CPOL_ $= 1$ e _CPHA_ $= 1$

In particolare quando la polarità è pari a $0$ vuol dire che il _clock_ in stato di _idle_ sarà a livello logico _LOW_, _HIGH_ viceversa. Mentre la fase indica su quale fronte si effettua il sample e di conseguenza lo shift del registro. Nel caso 0 è come se ci fosse una fase di $0°$ ovvero il samplig viene effettuato sul fronte che va da idle $->$ #overline("idle"), nel caso contrario va da #overline("idle") $->$ idle, di conseguenza lo _shift_ verrà effettuato al fornte successivo (ovvero a quello opposto del _sampling_).
Ad esempio con _CPOL_ = 1 il clock è in idle con valore _HIGH_ quindi con _CPHA_ = 0 il samplig si effettua sulla transizione 1 $->$ 0, mentre nel caso _CPHA_ = 1, 0 $->$ 1.  


== Protocollo $"I"^2 "C"$

Il protocollo $"I"^2 "C"$ utilizza due canali per la trasmissione:
- *SDA*: _Serial Data Line_ utilizzato per inviare i dati;
- *SCL*: _Serial Clock Line_ utilizzato dal _controller device_ il quale ha lo scopo di sincornizzare di dati con il _target device_.

Il _controller device_ inizia e termina la comunicazione. Per indirizzare la trasmissione a uno specifico target si utilizza un *indirizzo unico* che identifica il target. 

Esso supporta la comunicazione multipla tra diversi dispositivi e anche tra diversi controllori che inviano segnali di _send_ e _recive_ in modalità _half-duplex_. Le comunicazioni avvengono per pacchetti di byte.
Esso ha diverse modalità di comunicazione, @fig:speed-mode-i2c.

Il layer fisico del $"I"^2 "C"$ è composto da due cavi *SDA* e *SCL* con una resistenza di _pull-up_ per entrambe che va a $"V"_("DD")$. La presenza delle resistenze di _pull-up_ è data dalla presenza della connessione, per ogni dispositivi, di _open-drain_ al bus, @fig:connessione-open-drain. Da notare le resitenze di _pull-up_ hanno due impatti sulla trasmissione:
- *Velocità di risalita*: le linee _SDA_ o _SCL_ per "tornare su" impiegano un certo tempo (costante $R C$) che dipende dalle _capacità parassite_ e dalla resistenza di _pull-up_. Maggiore è la resistenze più lenta sarà la risalita;
- *Consumo di potenza*: Con una resistenza di _pull-up_ più piccola la potenza necessaria aumenterà con la coseguenza di maggiori consumi.
Valori tipici per le resistenze sono tra $1K Omega$ e $ 10 Kappa Omega$.

#figure(
  image("../image/protocollo-i2c/trasmission-rate.png", width: 60% ),
  caption: [Diverse modalità di trasmissione del protocollo $"I"^2 "C"$]
) <fig:speed-mode-i2c>

#figure(
  image("../image/protocollo-i2c/connsessione-open-drain.png", width: 60% ),
  caption: [Connessione _open-drain_.]
) <fig:connessione-open-drain>


L'inizio e la fine di una comunicazione viene effettuata tramite una specifica sequenza. In particolare per iniziare la comunicazione il _controller device_ deve prima mettere _SDA = _LOW_ e successivamente _SCL = _LOW_ per la chiusura della comunicazione: _SCL = HIGH_ e poi _SDA = HIGH_. Come mostrato in @fig:i2c-start-stop.

La trasmissione del singolo bit avviene secondo lo schema riportato a figura @fig:i2c-zero-uno.

Una comunicazione avviene sempre con un ordine definito, in particolare ogni volta si invia un byte (8 bit) alla volta più un bit di _ACK_, eccetto per _start_ e _stop_:
+ *Avvio* della comunicazione;
+ *Invio* dell'indirizzo di destinazione (7 bit) e un bit se il controllore deve leggere (_LOW_) o scrivere (HIGH), in seguito un bit di _ACK_: se pari a 0 allora il messaggio è stato ricevuto altrimenti no.
+ A questo punto ci sono solo *byte* di dati che possono essere inviati o solo dal _controller device_, caso scrittura, o solo dal _target device_, nel caso di lettura, essi sono sempre seguiti da un _ACK_.
+ *Chiusura* della comunicazione  

Esempio a @fig:i2c-esempio-comunicazione. 

#subpar.grid(
    
  figure(
    image("../image/protocollo-i2c/start-stop.png"),
    caption: [Start e Stop della comunicazione $"I"^2 "C"$],
  ), 
  <fig:i2c-start-stop>,
  
  figure(
      image("../image/protocollo-i2c/zero-e-uno.png"),
      caption: [comunicazione di uno e zero],
  ), 
  <fig:i2c-zero-uno>,
  columns: (1fr , 1fr),
  caption: [Linee del protocollo $"I"^2 "C"$],
)


#figure(
  image("../image/protocollo-i2c/esempio-trasmissione.png", width: 100% ),
  caption: [Esempio di comunicazione $"I"^2 "C"$.]
) <fig:i2c-esempio-comunicazione>

