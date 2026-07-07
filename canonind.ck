// ===================================================================
//                 CANON IN D (Johann Pachelbel)
//          Arranjo Polifónico Fiel à Partitura Clássica
// ===================================================================

// --- VOZ 1: Violoncelo (Baixo Ostinato) ---
SawOsc cello => LPF filtroCello => ADSR envCello => NRev reverb => dac;
280 => filtroCello.freq; // Som bem grave e aveludado
1.2 => filtroCello.Q;
envCello.set(30::ms, 400::ms, 0.5, 200::ms); // Ataque mais lento do arco

// --- VOZ 2: Violino (Melodia) ---
SawOsc violin => LPF filtroViolin => ADSR envViolin => reverb => dac;
550 => filtroViolin.freq; // Som mais aberto e brilhante
1.5 => filtroViolin.Q;
envViolin.set(20::ms, 300::ms, 0.4, 150::ms);

0.08 => reverb.mix; // Reverb de igreja/sala de concerto

// ===================================================================
//                        DADOS DA PARTITURA
// ===================================================================

// O famoso Baixo Ostinato de Pachelbel (Notas semínimas de 1 tempo cada)
// D=50, A=45, B=47, F#=42, G=43, D=38, G=43, A=45
[50, 45, 47, 42, 43, 38, 43, 45] @=> int baixoPachelbel[];

// Melodia Principal do Violino (Entra na segunda secção)
[
    62, 61, 59, 57, 55, 54, 55, 57, // Frase 1 (Notas longas de 1 tempo)
    50, 54, 57, 55, 54, 50, 54, 52, // Frase 2
    50, 49, 50, 54, 57, 62, 61, 64  // Frase 3 (Subida)
] @=> int melodiaViolino[];

// Tempo de uma Semínima (Largo / Moderato)
0.65::second => dur tempoNota;


// ===================================================================
//                    LOOP PRINCIPAL (POLIFONIA)
// ===================================================================

0 => int contadorBaixo;
0 => int contadorMelodia;
false => int violinoAtivo; // O violino só entra após o baixo se apresentar

while( true )
{
    // 1. PROCESSAR O VIOLONCELO (Sempre ativo, 1 nota por ciclo)
    baixoPachelbel[contadorBaixo] => int notaCello;
    Std.mtof(notaCello) => cello.freq;
    0.35 => cello.gain;
    1 => envCello.keyOn;
    
    // Condição da partitura: O violino começa após o baixo tocar 2 vezes o ciclo completo
    if (contadorBaixo == 8 && !violinoAtivo)
    {
        true => violinoAtivo;
    }
    
    // 2. PROCESSAR O VIOLINO (Se já tiver entrado no tempo da partitura)
    if (violinoAtivo)
    {
        melodiaViolino[contadorMelodia] => int notaViolin;
        Std.mtof(notaViolin) => violin.freq;
        0.28 => violin.gain;
        1 => envViolin.keyOn;
        
        // Avança o ponteiro da melodia
        (contadorMelodia + 1) % melodiaViolino.size() => contadorMelodia;
    }
    
    // Avança o ponteiro do baixo
    (contadorBaixo + 1) => contadorBaixo;
    if(contadorBaixo >= baixoPachelbel.size() && !violinoAtivo) {
        0 => contadorBaixo; // Faz o loop do baixo enquanto espera o violino
    } else if (violinoAtivo) {
        contadorBaixo % baixoPachelbel.size() => contadorBaixo;
    }
    
    // O ChucK avança o tempo exato de 1 nota da partitura
    tempoNota => now;
    
    // Desliga os envelopes suavemente no final do tempo para articular o som das cordas
    1 => envCello.keyOff;
    if (violinoAtivo) 1 => envViolin.keyOff;
}

