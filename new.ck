// --- CONFIGURAÇÃO DO SISTEMA DE ÁUDIO E EFEITOS (MODERNO) ---
// Canal da Melodia: Sintetizador FM -> Reverb -> Saída
BeeThree synth => NRev reverbMelodia => dac;
0.08 => reverbMelodia.mix; // Mistura do efeito de sala (reverb)

// Canal do Baixo: Instrumento de Corda -> Delay (Eco) -> Saída
Mandolin baixo => Delay ecoBaixo => dac;
0.12 => reverbMelodia.mix; 

// Configurando o efeito de Eco (Delay) no baixo
0.25::second => ecoBaixo.max => ecoBaixo.delay;
0.3 => ecoBaixo.gain; // Volume do eco
ecoBaixo => ecoBaixo; // Feedback do eco (ele repete)

// --- MAPA DE NOTAS MIDI (Escala Pentatônica Menor de Lá - Muito usada em Synthwave) ---
// Notas de Baixo (Graves)
[45, 48, 50, 52, 55, 57] @=> int notasBaixo[]; 
// Notas de Melodia (Agudas)
[69, 72, 74, 76, 79, 81] @=> int notasMelodia[];

// Variável de tempo (BPM de 120 -> Batida por minuto moderna)
0.25::second => dur t; // Tempo de uma colcheia

// --- LOOP PRINCIPAL (COMPOSIÇÃO AUTOMÁTICA EM CAMADAS) ---
while( true )
{
    // 1. Geração da Linha de Baixo (Ritmo Pulsante)
    // Escolhe notas da escala baseadas no tempo para criar uma progressão moderna
    Math.random2(0, 3) => int indiceBaixo;
    Std.mtof(notasBaixo[indiceBaixo]) => baixo.freq;
    0.8 => baixo.pluck; // "Dedilhar" a corda digital com força
    
    // 2. Geração da Melodia Espacial (Probabilidade)
    // Nem todo compasso tem melodia, criando variação natural e grooves modernos
    if (Math.randomf() > 0.4) 
    {
        Math.random2(0, notasMelodia.size() - 1) => int indiceMelodia;
        Std.mtof(notasMelodia[indiceMelodia]) => synth.freq;
        Math.randomf() => synth.noteOn; // Dispara o sintetizador FM com dinâmicas diferentes
    }
    else 
    {
        1 => synth.noteOff; // Silêncio na melodia para o baixo respirar
    }
    
    // Altera sutilmente o timbre do sintetizador dinamicamente para não enjoar
    Math.randomf() => synth.controlOne; 
    
    // Avança o tempo do ChucK
    t => now;
}
