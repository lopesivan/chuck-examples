// terminator.ck
// "On the Run" - Timecop1983 Style (Modern Synthwave)

// --- CADEIA DE ÁUDIO (SONORIDADE MODERNA) ---
// 3 SawOsc em paralelo para criar um "SuperSaw" encorpado
SawOsc s1 => LPF filtro => Delay dly => dac;
SawOsc s2 => filtro;
SawOsc s3 => filtro;

// Feedback do Delay (Eco moderno)
dly => dly; 

// --- CONFIGURAÇÕES DE SOM ---
0.15 => s1.gain;
0.15 => s2.gain;
0.15 => s3.gain;

// Ajuste do Filtro (Corta o "chiado" de videogame e deixa o som macio)
800 => filtro.freq; 
0.7 => filtro.Q;

// Ajuste do Delay (Eco espelhado no tempo da música)
350 :: ms => dly.delay;
0.4 => dly.gain; // Volume do eco

// --- TEMPO E NOTAS ---
350 :: ms => dur tempo; // BPM aproximado da música

// Notas da melodia principal (Mapeamento MIDI)
[67, 69, 71, 74, 71, 69, 67, 64] @=> int melodia[];

// --- FUNÇÃO PARA DETUNING (Efeito Analógico Moderno) ---
fun void definirFreq( float baseFreq ) {
    baseFreq => s1.freq;
    baseFreq + 1.2 => s2.freq; // Levemente acima
    baseFreq - 1.2 => s3.freq; // Levemente abaixo
}

// --- LOOP PRINCIPAL ---
while( true ) {
    
    // Toca a sequência inspirada no lead de "On the Run"
    for( 0 => int i; i < melodia.size(); i++ ) {
        
        // Converte MIDI para Frequência e aplica o SuperSaw
        definirFreq( Std.mtof( melodia[i] ) );
        
        // Abre o filtro levemente durante a nota para dar dinâmica
        filtro.freq() + 50 => filtro.freq;
        
        // Tempo que a nota fica soando
        tempo => now;
        
        // Fecha o filtro de volta
        filtro.freq() - 50 => filtro.freq;
    }
    
    // Transposição para a segunda parte da frase (Sobe o tom)
    for( 0 => int i; i < melodia.size(); i++ ) {
        definirFreq( Std.mtof( melodia[i] + 2 ) ); // +2 semitons
        tempo => now;
    }
}

