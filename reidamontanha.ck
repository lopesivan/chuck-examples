// ===================================================================
//       IN THE HALL OF THE MOUNTAIN KING (Edvard Grieg)
//               Fidelidade de Partitura e Dinâmica
// ===================================================================

// --- CONFIGURAÇÃO DO INSTRUMENTO (Pizzicato / Fagote Orquestral) ---
SawOsc oscL => LPF filtroL => ADSR env => NRev reverb => dac.left;
SawOsc oscR => LPF filtroR => env => reverb => dac.right;

// Ajustes para dar corpo ao som (remover o brilho digital áspero)
450 => filtroL.freq => filtroR.freq;
1.5 => filtroL.Q => filtroR.Q;
1.002 => float detune; // Stereo widening

// Envelope moldado para imitar o "pizzicato" de cordas/sopro curto
// (Ataque imediato, decaimento rápido, sem sustentação)
env.set(5::ms, 120::ms, 0.0, 50::ms);
0.06 => reverb.mix;

// --- NOTAS DA PARTITURA (Tema Principal em Si Menor) ---
// B=47, C#=49, D=50, E=52, F#=54, G=55, A#=46
[
    47, 49, 50, 52, 54, 50, 54, // Primeira frase
    53, 49, 53, 52, 48, 52,     // Segunda frase (tensão)
    47, 49, 50, 52, 54, 50, 54, // Terceira frase
    59, 57, 54, 52, 54, 52, 47  // Resolução do tema
] @=> int partitura[];

// Durações correspondentes de cada nota na partitura
// 1 = Semínima, 2 = Mínima (nota longa)
[
    1, 1, 1, 1, 1, 1, 2,
    1, 1, 2, 1, 1, 2,
    1, 1, 1, 1, 1, 1, 2,
    1, 1, 1, 1, 1, 1, 2
] @=> int duracoes[];


// --- VARIÁVEIS DE DINÂMICA ORQUESTRAL ---
0.45::second => dur tempoBase; // Começa lento (Andante)
0.15 => float volumeBase;      // Começa muito pianissimo (pp)

// --- LOOP PRINCIPAL (Aceleração e Crescendo da Obra) ---
for( 1 => int repeticao; repeticao <= 6; repeticao++ )
{
    <<< "Repetição:", repeticao, "| BPM:", 60 / (tempoBase / 1::second), "| Vol:", volumeBase >>>;

    for( 0 => int i; i < partitura.size(); i++ )
    {
        // 1. Define as frequências com o detune estéreo
        Std.mtof(partitura[i]) => oscL.freq;
        Std.mtof(partitura[i]) * detune => oscR.freq;
        
        // 2. Aplica a dinâmica de articulação (notas longas vs curtas)
        if (duracoes[i] == 2) {
            // Se a nota na partitura for longa, esticamos um pouco o decaimento do envelope
            env.set(5::ms, 250::ms, 0.0, 50::ms);
        } else {
            env.set(5::ms, 120::ms, 0.0, 50::ms);
        }
        
        // Aplica o volume atual da orquestra
        volumeBase => oscL.gain => oscR.gain;
        
        // Dispara a nota
        1 => env.keyOn;
        
        // 3. Gerenciamento do Tempo do ChucK
        // Faz a transição exata do tempo com base no valor da nota na partitura
        (duracoes[i] * tempoBase) => now;
    }
    
    // --- O EFEITO DA PARTITURA: ACCELERANDO E CRESCENDO ---
    // A cada repetição completa do tema, a música acelera e fica mais forte
    tempoBase * 0.82 => tempoBase; // Encurta o tempo (fica mais rápido)
    volumeBase + 0.12 => volumeBase; // Aumenta o ganho (fica mais forte)
    
    // Pequena pausa dramática entre as repetições (Staccato de transição)
    tempoBase => now;
}
