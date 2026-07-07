// Atirei o Pau no Gato - Versão Otimizada com ADSR
// Instrumento: Oscilador Senoidal com Envelope de Amplitude
SinOsc s => ADSR env => dac;

// Configuração do Envelope (Ataque, Decaimento, Sustentação, Relaxamento)
env.set(10::ms, 10::ms, 0.8, 50::ms);

// Matriz de notas (Escala de Dó Maior - MIDI)
[60, 62, 64, 65, 67, 69, 71, 72] @=> int notas[];

0 => int C;  // Do
1 => int D;  // Re
2 => int E;  // Mi
3 => int F;  // Fa
4 => int G;  // Sol
5 => int A;  // La
6 => int B;  // Si
7 => int C2; // Do agudo

// Função para tocar uma nota usando o envelope ADSR
fun void tecla(int nota, float dur)
{
    Std.mtof(notas[nota]) => s.freq;
    0.35 => s.gain;
    
    1 => env.keyOn;              // Ativa o som (suave)
    (dur - 0.04)::second => now; // Mantém a nota tocando
    
    1 => env.keyOff;             // Desativa o som (fade-out)
    0.04::second => now;         // Tempo para o som sumir naturalmente
}

// Tempo base de uma nota (semínima)
0.30 => float t; // Um pouquinho mais rápido para combinar com a música

// --- ESTRUTURA DA MÚSICA (Atirei o Pau no Gato) ---

// A-ti-rei o pau no ga-to-to
tecla(G, t); tecla(F, t); tecla(E, t); tecla(D, t); tecla(E, t); tecla(F, t);
tecla(G, t); tecla(G, t); tecla(G, t);

// Mas o ga-to-to
tecla(A, t); tecla(G, t); tecla(F, t);
tecla(G, t); tecla(G, t); tecla(G, t);

// Não mor-reu-reu-reu
tecla(F, t); tecla(E, t); tecla(D, t);
tecla(F, t); tecla(F, t); tecla(F, t);

// Do-na Chi-ca-ca
tecla(E, t); tecla(D, t); tecla(C, t);
tecla(E, t); tecla(E, t); tecla(E, t);

// Ad-mi-rou-se-se
tecla(C, t); tecla(C, t); tecla(D, t); tecla(E, t); tecla(F, t);
tecla(G, t); tecla(G, t); tecla(G, t);

// Do be-rro, do be-rro que o gato deu:
tecla(A, t); tecla(A, t); tecla(A, 2*t);
tecla(G, t); tecla(G, t); tecla(G, 2*t);

// MIAU!
tecla(F, t); tecla(D, t); tecla(C, 3*t);
