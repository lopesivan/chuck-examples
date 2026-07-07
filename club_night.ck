// club_night_upgraded.ck
// Música Eletrônica/Dance - "Noite na Boate" (Versão Studio Mix)

// ==========================================================
// --- CADEIA DE ÁUDIO INDUSTRIAL (TIMBRES MELHORADOS) ---
// ==========================================================

// 1. Sintetizador Lead (SuperSaw Moderno com Filtro)
SawOsc lead => LPF leadFilter => ADSR envLead => Echo echoLead => NRev reverb => dac;
800 => leadFilter.freq; // Tira o "ardido" digital do oscilador puro

// 2. Baixo Sintetizado (Sub-Bass encorpado)
SawOsc bass => LPF bassFilter => ADSR envBass => reverb => dac;
250 => bassFilter.freq; // Filtro bem baixo para dar aquele sub de tremer o chão

// 3. Pads de Fundo (Ambiente Estéreo)
TriOsc pad1 => ADSR envPad => reverb => dac.left;
TriOsc pad2 => ADSR envPad2 => reverb => dac.right;

// 4. Gerador do KICK de Boate (A grande mudança: Onda senoidal caindo em pitch)
SinOsc kickOsc => ADSR envKick => dac;

// 5. CAIXA (Noise + Filtro Passa-Banda para dar corpo de caixa)
Noise snare => BPF snareFilter => ADSR envSnare => dac;
1200 => snareFilter.freq; // Frequência central da batida da caixa
2.0 => snareFilter.Q;

// 6. HI-HAT (Noise + Filtro Passa-Alta para deixar apenas o brilho metálico)
Noise hihat => HPF hatFilter => ADSR envHat => dac;
8000 => hatFilter.freq; // Corta todos os graves do ruído, deixando só o "tss tss"

// --- EFEITOS NO MIX ---
0.15 => reverb.mix;
0.3 => echoLead.mix;
0.4 => echoLead.gain;
250::ms => echoLead.delay;

// ==========================================================
// --- ENVELOPES ADSR (AJUSTADOS PARA SOM ELETRÔNICO) ---
// ==========================================================
(10::ms, 80::ms, 0.6, 150::ms) => envLead.set;
(5::ms, 100::ms, 0.5, 50::ms) => envBass.set;
(400::ms, 300::ms, 0.7, 400::ms) => envPad.set;
(300::ms, 200::ms, 0.6, 300::ms) => envPad2.set;

// Envelopes de Bateria muito percussivos (Sustain ZERADO para impacto puro)
(1::ms, 90::ms, 0.0, 10::ms) => envKick.set;
(5::ms, 70::ms, 0.0, 20::ms) => envSnare.set;
(1::ms, 25::ms, 0.0, 5::ms) => envHat.set;

// --- GANHOS CONTROLADOS (Evitando clipping/estouro) ---
0.25 => lead.gain;
0.45 => bass.gain;
0.12 => pad1.gain;
0.12 => pad2.gain;
0.85 => kickOsc.gain;
0.35 => snare.gain;
0.15 => hihat.gain;

// ==========================================================
// --- DADOS MUSICAIS (SUA ESTRUTURA ORIGINAL) ---
// ==========================================================
[
    60, 62, 64, 65, 67, 65, 64, 62, 60, 62, 64, 65, 67, 65, 64, 62,
    67, 69, 71, 72, 74, 72, 71, 69, 67, 69, 71, 72, 74, 72, 71, 69,
    60, 62, 64, 65, 67, 69, 71, 72, 60, 62, 64, 65, 67, 69, 71, 72,
    72, 74, 76, 77, 79, 77, 76, 74, 72, 74, 76, 77, 79, 77, 76, 74,
    79, 77, 76, 74, 72, 71, 69, 67, 79, 77, 76, 74, 72, 71, 69, 67
] @=> int melodiaLead[];

[
    36, 36, 38, 38, 40, 40, 38, 38, 36, 36, 38, 38, 40, 40, 38, 38,
    43, 43, 45, 45, 47, 47, 45, 45, 43, 43, 45, 45, 47, 47, 45, 45,
    36, 36, 38, 38, 40, 43, 45, 43, 36, 36, 38, 38, 40, 43, 45, 43,
    48, 48, 50, 50, 52, 52, 50, 50, 48, 48, 50, 50, 52, 52, 50, 50,
    55, 55, 53, 53, 52, 52, 50, 50, 55, 55, 53, 53, 52, 52, 50, 50
] @=> int melodiaBass[]; // Oitavado para baixo (Midi 36-48) para peso real de Club

[
    48, 52, 55, 48, 52, 55, 48, 52, 48, 52, 55, 48, 52, 55, 48, 52,
    48, 52, 55, 48, 52, 55, 48, 52, 48, 52, 55, 48, 52, 55, 48, 52,
    48, 52, 55, 48, 52, 55, 48, 52, 48, 52, 55, 48, 52, 55, 48, 52,
    48, 52, 55, 48, 52, 55, 48, 52, 48, 52, 55, 48, 52, 55, 48, 52
] @=> int melodiaPad[];

// Ritmo cravado a 125 BPM (240ms por passo de semicolcheia)
dur tempos[melodiaLead.size()];
for(0 => int i; i < melodiaLead.size(); i++) {
    240::ms => tempos[i];
}

// ==========================================================
// --- MOTORES DE PROCESSAMENTO DE AUDIO ---
// ==========================================================

fun void tocarLead(int nota, dur duracao, float gate) {
    Std.mtof(nota) => lead.freq;
    envLead.keyOn();
    duracao * gate => now;
    envLead.keyOff();
    duracao * (1 - gate) => now;
}

fun void tocarBass(int nota, dur duracao, float gate) {
    Std.mtof(nota) => bass.freq;
    envBass.keyOn();
    duracao * gate => now;
    envBass.keyOff();
    duracao * (1 - gate) => now;
}

fun void tocarPad(int nota, dur duracao, float gate) {
    Std.mtof(nota) => pad1.freq;
    Std.mtof(nota + 7) => pad2.freq; // Quinta perfeita para harmonia rica
    envPad.keyOn(); envPad2.keyOn();
    duracao * gate => now;
    envPad.keyOff(); envPad2.keyOff();
    duracao * (1 - gate) => now;
}

// Sub-rotina para dar o soco de frequência no Kick
fun void sweepKick(dur d) {
    150.0 => float startFreq;
    45.0 => float endFreq; // Desce até o sub grave profundo
    now + d => time lateral;
    while(now < lateral) {
        // Interpolação rápida descendo o pitch da onda senoidal
        ((lateral - now) / d) * (startFreq - endFreq) + endFreq => kickOsc.freq;
        1::ms => now;
    }
}

fun void tocarBateria(int kickAtivo, int snareAtivo, int hatAtivo, dur duracao) {
    if(kickAtivo > 0) {
        envKick.keyOn();
        spork ~ sweepKick(duracao * 0.4); // Despara o efeito de queda de pitch
    }
    if(snareAtivo > 0) { envSnare.keyOn(); }
    if(hatAtivo > 0) { envHat.keyOn(); }
    
    // Deixa os gates agirem de forma percussiva
    duracao * 0.8 => now;
    envKick.keyOff(); envSnare.keyOff(); envHat.keyOff();
    duracao * 0.2 => now;
}

// --- FUNÇÃO PRINCIPAL REFORMULADA ---
fun void tocarMusica() {
    int kick, snare, hat;
    
    for(0 => int i; i < melodiaLead.size(); i++) {
        // Disparos paralelos (Threads)
        spork ~ tocarLead(melodiaLead[i], tempos[i], 0.7);
        spork ~ tocarBass(melodiaBass[i], tempos[i], 0.85);
        
        if(i % 4 == 0) {
            spork ~ tocarPad(melodiaPad[i/2], tempos[i] * 4, 0.85);
        }
        
        // --- DESIGN DE BEAT ELETRÔNICO ---
        1 => kick; // 4x4 Four-on-the-floor total
        
        // Caixa bate nas posições 4, 12, 20... (Beat 2 e 4 padrão Dance)
        if (i % 8 == 4) { 1 => snare; } else { 0 => snare; }
        
        // Hi-Hat contra-tempo (Offbeat Hat clássico do House/Techno)
        if (i % 2 == 1) { 1 => hat; } else { 0 => hat; }
        
        // A bateria agora centraliza o relógio dessa iteração!
        tocarBateria(kick, snare, hat, tempos[i]); 
    }
}

// ==========================================================
// --- LOOP DO CLUBE (EFEITOS E MACROESTRUTURA) ---
// ==========================================================
<<< "🎧 Club Night 2.0 - Studio Remaster" >>>;

int efeitosCount;
while(true) {
    efeitosCount++;
    if(efeitosCount % 3 == 0) {
        0.5 => echoLead.gain;
        0.35 => reverb.mix;
        1500 => leadFilter.freq; // Abre o filtro do lead no ápice
        <<< "🌀 Breakdown & Open Filter...">>>;
    } else if(efeitosCount % 3 == 1) {
        0.3 => echoLead.gain;
        0.15 => reverb.mix;
        750 => leadFilter.freq;
        <<< "🎵 Beat drop - Groove Limpo">>>;
    } else {
        0.2 => echoLead.gain;
        0.12 => reverb.mix;
        550 => leadFilter.freq; // Som "abafado" profundo estilo techno underground
        <<< "⚡ Groove Subterrâneo">>>;
    }
    
    tocarMusica();
    1000::ms => now;
}

