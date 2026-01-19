= STM32

== "PWM input mode" SMT32
Utilizziamo 2 canali del timer:
- Il primo misura il periodo della PWM in ingresso
- Il secondo misura _high time_ della PWM


== EXTI dai pulsanti
Per prima cosa individuare dove è connesso il pulsante, ad esempio _PC12_; Successivamente attivare nella sezione _NVIC_ le relative linee come interrupt, inoltre nella sezione _GPIO_ individuare il pin (PC12 in questo caso) e impostare su quale edge generare l'interrupt.
*ATTENZIONE*: Se il pulsante non presenta nessuna rete di pull-up, o pull-down, impostare nella _GPIO_ una rete di pull-up o pull-down per quel pin, in questo caso PC12.  

= Altre informazi
- *USART* $->$ protocollo comunicazione come il seriale
- *stlink debugger* è la parte che fa debug 
- *GPIO* (_General Purpouse Input Output_), può esserci per segnali come _timer_.