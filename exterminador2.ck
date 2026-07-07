// ===================================================================
//              THE TERMINATOR THEME - VERSÃO COMPLETA (13/16)
// ===================================================================

// 1. CANAL DO SYNTH BRASS (Notas Longas e Pesadas)
SawOsc brassL => LPF filtroBrassL => ADSR envBrassL => dac.left;
SawOsc brassR => LPF filtroBrassR => ADSR envBrassR => dac.right;

// Ligeiro "detune" (desafinação) entre os osciladores para dar o efeito Stereo Gigante dos anos 80
1.003 => float detune;
600 => filtroBrassL.freq => filtroBrassR.freq;
2.0 => filtroBrassL.Q => filtroBrassR.Q;
envBrassL.set(80::ms, 300::ms, 0.6, 500::ms);
envBrassL => envBrassR;

// 2. CANAL DO FAST SYNTH / BASS RÍTMICO (O Arpejo de Perseguição)
SawOsc fastSynth => LPF filtroFast => ADSR envFast => NRev reverbFast => dac;
450 => filtroFast.freq;
0.08 => reverbFast.mix;
envFast.set(10::ms, 40::ms, 0.4, 20::ms);

// 3. CANAL DO TIMPANI METÁLICO (Batida Industrial)
Noise timpani => BPF filtroTimp => ADSR envTimp => dac;
220 => filtroTimp.freq; // Frequência mais baixa para soar como um tambor pesado
30 => filtroTimp.Q;     // Ressonância metálica alta
envTimp.set(5::ms, 80::ms, 0.0, 10::ms);


// ===================================================================
//                      ESTRUTURA MUSICAL (Si Bemol Menor)
// ===================================================================

// Definição exata das notas da linha de baixo (B♭ minor)
// Bb=46, Db=49, C=48, Gb=42, F=41
[46, 46, 49, 48, 42, 41] @=> int notasBase[];

// O compasso de 13/16 subdividido (3 + 3 + 2 + 3) conforme a partitura
// 1 = Bate o Timpani e acentua o Synth Rápido, 0 = Apenas mantém o ritmo
[1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0] @=> int padrao13_16[];

// Tempo de 1 semicolcheia (BPM ~ 95)
0.075::second => dur semicolcheia;


// ===================================================================
//                          LOOP DE EXECUÇÃO
// ===================================================================
0 => int compasso;

while( true )
{
    // Pega a nota tônica do compasso atual
    notasBase[compasso % notasBase.size()] => int notaAtual;
    
    // --- Camada 1: Disparar o SYNTH BRASS (A cada início de compasso) ---
    Std.mtof(notaAtual) => brassL.freq;
    Std.mtof(notaAtual) * detune => brassR.freq;
    0.22 => brassL.gain => brassR.gain;
    1 => envBrassL.keyOn;
    
    // --- Camada 2 e 3: Executar as 13 semicolcheias do compasso ---
    for (0 => int tempo; tempo < 13; tempo++)
    {
        // Define a nota do Fast Synth (alternando uma oitava acima para dar groove)
        int notaFast;
        if (tempo % 2 == 0) notaAtual + 12 => notaFast; // Oitava acima
        else notaAtual => notaFast;                     // Nota base
        
        Std.mtof(notaFast) => fastSynth.freq;
        
        // Se for uma cabeça de tempo (1 no padrão), o ataque é mais forte
        if (padrao13_16[tempo] == 1)
        {
            0.35 => fastSynth.gain;
            0.70 => timpani.gain; // Dispara o impacto industrial
            1 => envTimp.keyOn;
        }
        else
        {
            0.18 => fastSynth.gain; // Notas fantasmas/mais fracas ao fundo
        }
        
        1 => envFast.keyOn;
        
        // Avança o ChucK no tempo de 1 semicolcheia
        semicolcheia => now;
    }
    
    // Fecha o envelope do Brass suavemente antes de mudar de nota no próximo compasso
    1 => envBrassL.keyOff;
    
    compasso++;
}
