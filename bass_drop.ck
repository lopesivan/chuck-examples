// bass_drop_upgraded.ck
// Música Bass/Dubstep - "Drop Pesado" (Versão Studio Master)

// ==========================================================
// --- CADEIA DE ÁUDIO INDUSTRIAL (TIMBRES MELHORADOS) ---
// ==========================================================

// 1. Wobble Bass Agressivo (SawOsc + LPF controlado por LFO)
SawOsc wobble => LPF lpf => ADSR envWobble => NRev reverb => dac;
3.0 => lpf.Q; // Q alto para dar aquele som metálico e rasgado de Dubstep

// LFO Real para o Wobble (Um oscilador que controla o filtro em tempo real)
SinOsc lfo => blackhole; 
4.0 => lfo.freq; // Velocidade inicial do Wobble (4 oscilações por segundo)

// 2. Lead Synth Agudo
TriOsc lead2 => ADSR envLead2 => Echo echo2 => reverb => dac;

// 3. Sub Bass (Puro grave senoidal para dar o peso no peito)
SinOsc sub => ADSR envSub => dac;

// 4. Bateria Modelação Dubstep
SinOsc kickOsc => ADSR envKick2 => dac; // Kick com queda de pitch de sub
Noise snare2 => BPF snareFilter => ADSR envSnare2 => dac; // Caixa encorpada
1100 => snareFilter.freq; 1.5 => snareFilter.Q;

Noise hat2 => HPF hatFilter => ADSR envHat2 => dac; // Hi-hat brilhante e limpo
9000 => hatFilter.freq;

// --- CONFIGURAÇÃO DE EFEITOS ---
0.15 => reverb.mix;
0.25 => echo2.mix;
0.3 => echo2.gain;
375::ms => echo2.delay;

// ==========================================================
// --- ENVELOPES ADSR ---
// ==========================================================
(5::ms, 140::ms, 0.8, 50::ms) => envWobble.set;
(5::ms, 100::ms, 0.6, 100::ms) => envLead2.set;
(10::ms, 150::ms, 0.7, 50::ms) => envSub.set;

// Envelopes percussivos de bateria
(1::ms, 120::ms, 0.0, 10::ms) => envKick2.set;
(1::ms, 80::ms, 0.0, 20::ms) => envSnare2.set;
(1::ms, 30::ms, 0.0, 5::ms) => envHat2.set;

// --- GANHOS CONTROLADOS (Evitando clipping de graves) ---
0.40 => wobble.gain;
0.20 => lead2.gain;
0.65 => sub.gain;
0.85 => kickOsc.gain;
0.35 => snare2.gain;
0.12 => hat2.gain;

// ==========================================================
// --- ARRAYS DE MELODIA (SUA ESTRUTURA ORIGINAL) ---
// ==========================================================
[
    48, 50, 52, 48, 50, 52, 48, 50, 48, 50, 52, 48, 50, 52, 48, 50,
    52, 55, 57, 52, 55, 57, 52, 55, 52, 55, 57, 52, 55, 57, 52, 55,
    43, 45, 48, 50, 52, 48, 45, 43, 43, 45, 48, 50, 52, 48, 45, 43,
    50, 52, 55, 57, 55, 52, 50, 48, 50, 52, 55, 57, 55, 52, 50, 48
] @=> int melodiaWobble[];

[
    60, 62, 64, 60, 62, 64, 60, 62, 60, 62, 64, 60, 62, 64, 60, 62,
    64, 67, 69, 64, 67, 69, 64, 67, 64, 67, 69, 64, 67, 69, 64, 67,
    55, 57, 60, 62, 64, 60, 57, 55, 55, 57, 60, 62, 64, 60, 57, 55,
    62, 64, 67, 69, 67, 64, 62, 60, 62, 64, 67, 69, 67, 64, 62, 60
] @=> int melodiaLead2[];

[
    24, 26, 28, 24, 26, 28, 24, 26, 24, 26, 28, 24, 26, 28, 24, 26,
    28, 31, 33, 28, 31, 33, 28, 31, 28, 31, 33, 28, 31, 33, 28, 31,
    19, 21, 24, 26, 28, 24, 21, 19, 19, 21, 24, 26, 28, 24, 21, 19,
    26, 28, 31, 33, 31, 28, 26, 24, 26, 28, 31, 33, 31, 28, 26, 24
] @=> int melodiaSub[]; // Oitavado para baixo (MIDI na casa dos 20) para peso de Subwoofer real

[
    200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200,
    200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200,
    140, 140, 140, 140, 140, 140, 140, 140, 140, 140, 140, 140, 140, 140, 140, 140,
    200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200
] @=> int temposMs2[];

dur tempos2[temposMs2.size()];
for(0 => int i; i < temposMs2.size(); i++) {
    temposMs2[i] :: ms => tempos2[i];
}

// ==========================================================
// --- MOTORES DE PROCESSAMENTO (THREADS/SPORKS) ---
// ==========================================================

// Esta função atualiza o filtro em tempo real enquanto a nota dura
fun void aplicarFiltroWobble(dur d) {
    now + d => time limite;
    while(now < limite) {
        // Captura o ciclo do LFO e joga na frequência do LPF de forma contínua
        (lfo.last() * 600) + 800 => lpf.freq;
        1::samp => now; // Amostragem ultrarrápida para o filtro não estalar
    }
}

fun void tocarWobble(int nota, dur duracao, float gate) {
    Std.mtof(nota) => wobble.freq;
    envWobble.keyOn();
    
    // Dispara em paralelo o modulador do filtro para esta nota específica
    spork ~ aplicarFiltroWobble(duracao);
    
    duracao * gate => now;
    envWobble.keyOff();
    duracao * (1 - gate) => now;
}

fun void tocarLead2(int nota, dur duracao, float gate) {
    Std.mtof(nota) => lead2.freq;
    envLead2.keyOn();
    duracao * gate => now;
    envLead2.keyOff();
    duracao * (1 - gate) => now;
}

fun void tocarSub(int nota, dur duracao, float gate) {
    Std.mtof(nota) => sub.freq;
    envSub.keyOn();
    duracao * gate => now;
    envSub.keyOff();
    duracao * (1 - gate) => now;
}

fun void sweepKick(dur d) {
    160.0 => float startFreq;
    50.0 => float endFreq;
    now + d => time lateral;
    while(now < lateral) {
        ((lateral - now) / d) * (startFreq - endFreq) + endFreq => kickOsc.freq;
        1::ms => now;
    }
}

fun void tocarBateria2(int kickOn, int snareOn, int hatOn, dur duracao) {
    if(kickOn > 0) {
        envKick2.keyOn();
        spork ~ sweepKick(duracao * 0.4);
    }
    if(snareOn > 0) { envSnare2.keyOn(); }
    if(hatOn > 0) { envHat2.keyOn(); }
    
    duracao * 0.8 => now;
    envKick2.keyOff(); envSnare2.keyOff(); envHat2.keyOff();
    duracao * 0.2 => now;
}

// ==========================================================
// --- LOOP PRINCIPAL DO DROP ---
// ==========================================================
<<< "🔥 Bass Drop 2.0 - Dubstep Wobble Fixed" >>>;

int kick, snare, hat;

while(true) {
    for(0 => int i; i < melodiaWobble.size(); i++) {
        
        // --- DINÂMICA DE VELOCIDADE DO WOBBLE (LFO) ---
        if(i < 32) {
            3.5 => lfo.freq; // Introdução: Wobble cadenciado em semínimas (Wuuub... Wuuub...)
        } else {
            // No Drop o Wobble acelera violentamente e varia em tripletos automáticos
            if (i % 4 == 0) { 12.0 => lfo.freq; } // Muito rápido (Wb-wb-wb-wb)
            else { 6.0 => lfo.freq; }             // Médio
        }
        
        // Disparos paralelos sincronizados
        spork ~ tocarWobble(melodiaWobble[i], tempos2[i], 0.8);
        spork ~ tocarLead2(melodiaLead2[i], tempos2[i], 0.7);
        spork ~ tocarSub(melodiaSub[i], tempos2[i], 0.85);
        
        // --- PADRÃO DE BATERIA DUBSTEP ---
        if(i % 4 == 0) { 1 => kick; } else { 0 => kick; }
        if(i % 8 == 4) { 1 => snare; } else { 0 => snare; }
        1 => hat; 
        
        // Síncopes e Kicks agressivos nas variações do Drop (A partir da nota 32)
        if(i >= 32) {
            if(i % 3 == 0) { 0 => hat; }
            if(i % 6 == 2) { 1 => kick; } 
        }
        
        // O relógio mestre deste passo avança dentro da bateria
        tocarBateria2(kick, snare, hat, tempos2[i]);
    }
    
    <<< "⏸️  Recarregando as energias..." >>>;
    1500 :: ms => now;
}
