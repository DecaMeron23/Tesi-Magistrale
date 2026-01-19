#set page("a4")
#set text(lang: "it")

= Misurazione PWM

frequenza del clock 32MHz, misure variando duty cicle con frequenze tra 100hz e 10khz. Timer 2 con massimo 16 bit utilizzati con il contatore...

Vpp = 3.3 --> offset 3.3/2



== Dati
Utilizzo:
- Timer con 32Mhz
- Impostazione con prescaler del timer di fattore $1/8$
- Counter reset del timer: $2^16 = 65536$

Dati (non so fare le tabelle)
- $f_"in" = 100 "hz"$, $f_"mis" = 98$, duty cicle: uguale a quello impostato   
- $f_"in" = 1"khz"$, $f_"mis" = 987$, duty cicle: uguale a quello impostato   
- $f_"in" = 10"khz"$, $f_"mis" = 9900$, duty cicle: uguale a quello impostato

