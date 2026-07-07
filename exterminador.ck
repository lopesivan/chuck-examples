// --- O TEMA DO EXTERMINADOR DO FUTURO (1984) ---
// Fiel à partitura original em 13/16 e Si Bemol Menor

// 1. Sintetizador Principal (O som longo de Brass dos anos 80)
TriOsc synth => LPF filtro => ADSR env => NRev reverb => dac;
400 => filtro.freq; 
0.15 => reverb.mix;
env.set(50::ms, 200::ms, 0.7, 300::ms);

// 2. O Tambor Industrial / Timpando Metálico
Noise bombo => BPF filtroMetal => ADSR envMetal => dac;
350 => filtroMetal.freq; // Mais grave, puxado para o Timpani da partitura
15 => filtroMetal.Q;
envMetal.set(5::ms, 60::ms, 0.0, 10::ms);

// --- MAPEAMENTO MUSICAL (Si Bemol Menor - MIDI) ---
// Bb=46, Db=49, C=48, Gb=42, F=41 (Notas graves do Synth Brass)
[46, 46, 49, 48, 42, 41] @=> int melodia[];
[13, 13, 13, 13, 13, 13] @=> int duracoesFrase[]; // Cada nota grande dura 1 compasso inteiro

// O tempo de 1 semicolcheia (a base do 13/16)
// Na partitura diz semínima = 95 no trecho 13/16, o que torna a semicolcheia bem rápida
0.08::second => dur semicolcheia;

// Array que define onde o Tambor bate dentro do compasso de 13 tempos (1 = bate, 0 = silêncio)
// Grupos de 3 + 3 + 2 + 3 conforme a linha rítmica "Actual 13:16 beat"
[1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0] @=> int ritmo13_16[];

// --- FUNÇÃO DO TAMBOR (Simulando dinâmica da partitura) ---
fun void bater(int tempoAtual)
{
    if (ritmo13_16[tempoAtual] == 1)
    {
        // Acentua a primeira batida do compasso (ganho maior)
        if (tempoAtual == 0) 0.6 => bombo.gain;
        else 0.35 => bombo.gain;
        
        1 => envMetal.keyOn;
    }
}

// --- LOOP PRINCIPAL ---
0 => int notaAtual;

while( true )
{
    // Define a nota longa do Synth Brass para este compasso
    Std.mtof(melodia[notaAtual]) => synth.freq;
    0.4 => synth.gain;
    1 => env.keyOn;
    
    // Executa rigorosamente os 13 tempos do compasso 13/16
    for (0 => int tempo; tempo < 13; tempo++)
    {
        bater(tempo); // Dispara o ritmo em paralelo
        semicolcheia => now;
    }
    
    // Corta o envelope do sintetizador antes de mudar de nota
    1 => env.keyOff;
    
    // Passa para a próxima nota do tema
    (notaAtual + 1) % melodia.size() => notaAtual;
}

