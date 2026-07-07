// sonhos_de_inverno.ck
// Composição Original: "Sonhos de Inverno" 
// Estilo: Barroco/Neoclássico com cordas

// --- ORQUESTRA DE CORDAS ---
Bowed violino1 => JCRev reverb => dac.left;
Bowed violino2 => reverb => dac.right;
Bowed violoncelo => reverb => dac;

// --- CONFIGURAÇÃO ACÚSTICA ---
0.2 => reverb.mix;
0.7 => violino1.gain;
0.6 => violino2.gain;
0.5 => violoncelo.gain;

// --- PARÂMETROS DE EXPRESSÃO ---
0.015 => violino1.vibratoGain;
0.018 => violino2.vibratoGain;
0.012 => violoncelo.vibratoGain;

6.0 => violino1.vibratoFreq;
5.8 => violino2.vibratoFreq;
4.2 => violoncelo.vibratoFreq;

// --- MELODIA PRINCIPAL (Violino 1) ---
[
    // Frase A - Tema do Inverno
    72, 74, 76, 77, 79, 77, 76, 74,
    72, 74, 76, 77, 79, 77, 76, 74,
    
    // Frase B - Desenvolvimento
    79, 81, 82, 81, 79, 77, 76, 74,
    76, 77, 76, 74, 72, 71, 69, 67,
    
    // Frase A' - Variação
    72, 74, 76, 77, 79, 81, 79, 77,
    72, 74, 76, 77, 79, 81, 82, 81,
    
    // Frase C - Climax
    84, 82, 81, 79, 81, 79, 77, 76,
    84, 82, 81, 79, 77, 76, 74, 72
] @=> int melodia1[];

// --- SEGUNDA VOZ (Violino 2 - Harmonia) ---
[
    // Frase A
    60, 62, 64, 65, 67, 65, 64, 62,
    60, 62, 64, 65, 67, 65, 64, 62,
    
    // Frase B
    67, 69, 70, 69, 67, 65, 64, 62,
    64, 65, 67, 65, 64, 62, 60, 59,
    
    // Frase A'
    60, 62, 64, 65, 67, 69, 67, 65,
    60, 62, 64, 65, 67, 69, 70, 69,
    
    // Frase C
    72, 70, 69, 67, 69, 67, 65, 64,
    72, 70, 69, 67, 65, 64, 62, 60
] @=> int melodia2[];

// --- LINHA DE BAIXO (Violoncelo) ---
[
    // Baixo contínuo
    48, 50, 52, 53, 55, 53, 52, 50,
    48, 50, 52, 53, 55, 53, 52, 50,
    
    // Desenvolvimento
    55, 57, 58, 57, 55, 53, 52, 50,
    52, 53, 55, 53, 52, 50, 48, 47,
    
    // Variação
    48, 50, 52, 53, 55, 57, 55, 53,
    48, 50, 52, 53, 55, 57, 58, 57,
    
    // Climax
    60, 58, 57, 55, 57, 55, 53, 52,
    60, 58, 57, 55, 53, 52, 50, 48
] @=> int melodiaBaixo[];

// --- DURAÇÃO DAS NOTAS (em milissegundos) ---
[
    // Frase A (marcato)
    400, 200, 200, 400, 400, 200, 200, 400,
    400, 200, 200, 400, 400, 200, 200, 400,
    
    // Frase B (legato)
    600, 200, 400, 400, 400, 200, 200, 400,
    400, 200, 400, 200, 200, 200, 200, 400,
    
    // Frase A' (variado)
    400, 200, 200, 400, 400, 200, 200, 400,
    400, 200, 200, 400, 400, 200, 200, 400,
    
    // Frase C (intenso)
    300, 200, 200, 200, 400, 200, 200, 400,
    300, 200, 200, 200, 200, 200, 200, 600
] @=> int temposMs[];

// Converter temposMs para array de dur
dur tempos[temposMs.size()];
for(0 => int i; i < temposMs.size(); i++) {
    temposMs[i] :: ms => tempos[i];
}

// --- FUNÇÃO PARA TOCAR NOTA COM DINÂMICA ---
fun void tocarNota(Bowed instrument, int nota, dur duracao, float intensidade) {
    Std.mtof(nota) => instrument.freq;
    intensidade => instrument.noteOn;
    duracao * 0.9 => now;
    0.5 => instrument.noteOff;
    duracao * 0.1 => now;
}

// --- FUNÇÃO PARA TOCAR A MÚSICA COMPLETA ---
fun void tocarMusica() {
    for(0 => int i; i < melodia1.size(); i++) {
        // Define intensidade variável para expressividade
        float dinamica;
        if(i >= 48 && i < 64) {
            // Seção C - mais intensa
            0.8 => dinamica;
        } else if(i % 16 < 8) {
            // Frases A - forte
            0.7 => dinamica;
        } else {
            // Frases B - mezzo-forte
            0.6 => dinamica;
        }
        
        // Toca todas as vozes simultaneamente
        spork ~ tocarNota(violino1, melodia1[i], tempos[i], dinamica);
        spork ~ tocarNota(violino2, melodia2[i], tempos[i], dinamica * 0.8);
        spork ~ tocarNota(violoncelo, melodiaBaixo[i], tempos[i], dinamica * 0.7);
        
        tempos[i] => now;
    }
}

// --- EXECUÇÃO PRINCIPAL ---
<<< "🎻 Tocando: Sonhos de Inverno" >>>;
<<< "🎵 Inspirado no estilo de Vivaldi" >>>;

while(true) {
    tocarMusica();
    <<< "⏸️  Pausa... Próxima execução em 3 segundos" >>>;
    3000 :: ms => now;
}

