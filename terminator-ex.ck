// terminator.ck
// Tema do Terminator para ChucK

// Configuração do Sintetizador
TriOsc s => Envelope e => dac;
0.2 => s.gain; // Ajusta o volume

// Definição dos tempos (em milissegundos)
250 :: ms => dur colcheia;
500 :: ms => dur negra;
1000 :: ms => dur minima;

// Mapeamento de notas para frequências MIDI
// [Dó, Ré, Mi bemol, Fá, Sol, Lá bemol, Si bemol]
[60, 62, 63, 65, 67, 68, 70] @=> int notas[]; 

// Função auxiliar para tocar uma nota com o Envelope
fun void tocar( float freq, dur tempo ) {
    freq => s.freq;
    e.keyOn();
    tempo * 0.8 => now; // Toca a nota por 80% do tempo
    e.keyOff();
    tempo * 0.2 => now; // Pausa sutil entre as notas
}

// Loop principal da música
while( true ) {
    // Primeira frase
    tocar( Std.mtof(50), negra ); // Ré grave
    tocar( Std.mtof(50), colcheia );
    tocar( Std.mtof(53), colcheia ); // Fá
    tocar( Std.mtof(55), negra ); // Sol
    tocar( Std.mtof(50), minima ); // Retorna ao Ré
    
    100 :: ms => now; // Pequena pausa dramática
    
    // Segunda frase (Variação)
    tocar( Std.mtof(50), negra ); 
    tocar( Std.mtof(50), colcheia );
    tocar( Std.mtof(53), colcheia );
    tocar( Std.mtof(56), negra ); // Sol Sustenido / Lá bemol
    tocar( Std.mtof(55), minima ); // Sol
    
    500 :: ms => now; // Pausa antes de repetir o loop
}
