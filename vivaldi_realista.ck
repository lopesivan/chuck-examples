// vivaldi_realista.ck
// Emulação Avançada de Cordas usando STK Bowed (Versão Corrigida)

// --- ORQUESTRA DE CORDAS (Modelação Física Oficial) ---
// Violino Principal (Canal Esquerdo)
Bowed violino => JCRev rev => dac.left;

// Violoncelo / Baixo (Canal Direito)
Bowed baixo => rev => dac.right;

// --- CONFIGURAÇÃO ACÚSTICA ---
0.15 => rev.mix;       // Reverb de sala de concerto
0.7 => violino.gain;   // Ganho do violino
0.6 => baixo.gain;     // Ganho do violoncelo

// --- DADOS DA MÚSICA (VIVALDI) ---
[
    64, 67, 67, 67, 65, 64, 62, 67, 67, 67, 65, 64, 62,
    67, 69, 71, 69, 67, 71, 72, 74, 72, 71, 69, 67,    
    67, 69, 71, 69, 67, 71, 72, 74, 72, 71, 69, 67     
] @=> int melodia[];

[
    52, 55, 55, 55, 53, 52, 50, 55, 55, 55, 53, 52, 50,
    55, 57, 59, 57, 55, 59, 60, 62, 60, 59, 57, 55,
    55, 57, 59, 57, 55, 59, 60, 62, 60, 59, 57, 55
] @=> int baixoMelodia[];

// Definição dos tempos das notas
240 :: ms => dur colcheia;
480 :: ms => dur negra;
720 :: ms => dur negraPontuada;
120 :: ms => dur semicolcheia;

[
    negra, colcheia, colcheia, negraPontuada, semicolcheia, semicolcheia, negra, colcheia, colcheia, negraPontuada, semicolcheia, semicolcheia, negra,
    colcheia, colcheia, colcheia, colcheia, negra, colcheia, colcheia, colcheia, colcheia, negra, colcheia, colcheia,
    colcheia, colcheia, colcheia, colcheia, negra, colcheia, colcheia, colcheia, colcheia, negra, colcheia, colcheia
] @=> dur tempos[];

// --- FUNÇÃO DE ARTICULAÇÃO DO ARCO ---
fun void tocarFrase( int notaVln, int notaVcl, dur duracao ) {
    
    // Altera a nota através da frequência MIDI
    Std.mtof(notaVln) => violino.freq;
    Std.mtof(notaVcl) => baixo.freq;
    
    // Configura o vibrato natural do modelo físico
    0.02 => violino.vibratoGain;
    5.8 => violino.vibratoFreq;
    0.01 => baixo.vibratoGain;
    4.5 => baixo.vibratoFreq;
    
    // Inicia a fricção do arco passando a força/velocidade (Note On)
    0.6 => violino.noteOn;
    0.5 => baixo.noteOn;
    
    // Tempo em que o arco passa na corda
    duracao * 0.85 => now;
    
    // Para de passar o arco suavemente (Note Off)
    0.5 => violino.noteOff;
    0.5 => baixo.noteOff;
    duracao * 0.15 => now; 
}

// --- EXECUÇÃO ---
while( true ) {
    for( 0 => int i; i < melodia.size(); i++ ) {
        tocarFrase( melodia[i], baixoMelodia[i], tempos[i] );
    }
    1000 :: ms => now; // Pausa antes de repetir
}

