// Brilha, Brilha Estrelinha - Versão Otimizada com ADSR
// Instrumento: Oscilador Senoidal com Envelope de Amplitude (sem estalos)
SinOsc s => ADSR env => dac;

// Configuração do Envelope: 10ms de ataque, 10ms de decaimento, 80% de volume sustentado, 50ms de relaxamento
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
0.35 => float t;

// --- ESTRUTURA DA MÚSICA ---

// 1. Brilha, brilha estrelinha
tecla(C, t); tecla(C, t);
tecla(G, t); tecla(G, t);
tecla(A, t); tecla(A, t);
tecla(G, 2*t);

// 2. Quero ver você brilhar
tecla(F, t); tecla(F, t);
tecla(E, t); tecla(E, t);
tecla(D, t); tecla(D, t);
tecla(C, 2*t);

// 3. Lá no alto a cintilar
tecla(G, t); tecla(G, t);
tecla(F, t); tecla(F, t);
tecla(E, t); tecla(E, t);
tecla(D, 2*t);

// 4. Como um diamante no céu
tecla(G, t); tecla(G, t);
tecla(F, t); tecla(F, t);
tecla(E, t); tecla(E, t);
tecla(D, 2*t);

// 5. Brilha, brilha estrelinha
tecla(C, t); tecla(C, t);
tecla(G, t); tecla(G, t);
tecla(A, t); tecla(A, t);
tecla(G, 2*t);

// 6. Quero ver você brilhar
tecla(F, t); tecla(F, t);
tecla(E, t); tecla(E, t);
tecla(D, t); tecla(D, t);
tecla(C, 2*t);
