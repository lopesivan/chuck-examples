// vivaldi_primavera.ck
// Emulação de Violino no ChucK - Tema da Primavera de Vivaldi

// --- CADEIA DE ÁUDIO (SÍNTESE DE VIOLINO) ---
TriOsc violino => LPF filtro => Envelope env => JCRev reverb => dac;

// Gerador de Vibrato (LFO) para realismo do violino
SinOsc vibrato => blackhole; 
6.0 => vibrato.freq; // Velocidade do vibrato (6 vezes por segundo)
1.5 => float amplitudeVibrato; // Intensidade do vibrato

// --- CONFIGURAÇÕES DO TIMBRE ---
0.4 => violino.gain;
1100 => filtro.freq; // Filtro fecha o som para parecer acústico
1.2 => filtro.Q;
0.10 => reverb.mix; // Reverb de sala de concerto

// --- CONFIGURAÇÃO DE TEMPO ---
220 :: ms => dur colcheia;
440 :: ms => dur negra;
660 :: ms => dur negraPontuada;
110 :: ms => dur semicolcheia;

// --- MELODIA (Notas MIDI do tema da Primavera) ---
[
    64, 67, 67, 67, 65, 64, 62, 67, 67, 67, 65, 64, 62, // Frase 1
    67, 69, 71, 69, 67, 71, 72, 74, 72, 71, 69, 67,     // Frase 2 (Sobe)
    67, 69, 71, 69, 67, 71, 72, 74, 72, 71, 69, 67      // Repetição
] @=> int melodia[];

[
    negra, colcheia, colcheia, negraPontuada, semicolcheia, semicolcheia, negra, colcheia, colcheia, negraPontuada, semicolcheia, semicolcheia, negra,
    colcheia, colcheia, colcheia, colcheia, negra, colcheia, colcheia, colcheia, colcheia, negra, colcheia, colcheia,
    colcheia, colcheia, colcheia, colcheia, negra, colcheia, colcheia, colcheia, colcheia, negra, colcheia, colcheia
] @=> dur tempos[];

// --- FUNÇÃO PARA TOCAR O VIOLINO ---
fun void tocarViolino( int notaMidi, dur duracao ) {
    Std.mtof(notaMidi) => float freqBase;
    
    env.keyOn();
    
    // Loop de tempo interno para aplicar o vibrato enquanto a nota soa
    duracao * 0.85 => dur tempoNota;
    now + tempoNota => time fimNota;
    
    while( now < fimNota ) {
        // Modula a frequência base com o oscilador de vibrato
        freqBase + (vibrato.last() * amplitudeVibrato) => violino.freq;
        1 :: ms => now;
    }
    
    // Articulação do arco tirando o som (Release)
    env.keyOff();
    duracao * 0.15 => now; // Pequeno silêncio entre as notas do arco
}

// --- LOOP PRINCIPAL (CONCERTO) ---
while( true ) {
    for( 0 => int i; i < melodia.size(); i++ ) {
        tocarViolino( melodia[i], tempos[i] );
    }
    
    1000 :: ms => now; // Pausa dramática antes do loop recomeçar
}

