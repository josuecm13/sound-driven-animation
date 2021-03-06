/* CASO 5 */

(
/*
SONIDO DEL CARRO:
- Sonido de los frenos
- Sonido del choque
*/
~horn = {
	arg frequency, mul = 0.4, env;
	Mix.ar([LFSaw.ar(frequency, mul: mul),LFSaw.ar(frequency - 70 - 20.rand,  mul: mul)]) * env
};

~hit = {
	arg waitingTime = 4, releaseTime = 0.9;
	var env = Env.new([0,0,45,0],[waitingTime, 0.2, releaseTime], \sin);
	WhiteNoise.kr(EnvGen.ar(env))
};

~engine = {
	arg engineTime = 5, doneAction = 0;
	var envelope = Env.new([1,1,0],[engineTime *0.9, engineTime * 0.1]);
	Mix.ar([BrownNoise.ar(0.6 * EnvGen.ar(envelope)) , (BrownNoise.ar(LFPulse.ar(12)) * 0.4 * EnvGen.ar(envelope, doneAction:doneAction)) ])
};

~brake = {
	arg waitingTime = 3, noiseFunc = PinkNoise;
	var env, snd, env2, noise;
	env = Env.new([0,0,0.8,0],[waitingTime,0.001,1.42]);
	noise = noiseFunc.ar(EnvGen.ar(env));
	noise = LPF.ar(noise,5500);
	snd = Mix.ar([PMOsc.ar(3130, 124, 1.0, mul: 0.4), PMOsc.ar(2912, 124, 1.0, mul: 0.4), PMOsc.ar(3016, 124, 1.0, mul: 0.5), noise*0.6]);
	env2 = Env.new([0,0,0.5,1,0], [waitingTime,0.001,0.5,3],\wel);
	snd * EnvGen.ar(env2)
};

SynthDef(\carro,{
	arg tmjmp = 0.05, tmshort = 0.05, tmhold = 0.4, wtm = 0.5, crasht = 2.5;
	var engine, brake, horns, envHorn, output, crash;
	envHorn = Env.new([0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0],
		[wtm,tmjmp,tmhold,tmjmp,tmhold * 0.5,tmjmp,tmshort,tmjmp,tmshort,tmjmp,tmshort,tmjmp,tmshort,tmjmp,tmshort,tmjmp,tmshort,tmjmp,tmhold,tmshort]);
	horns = ~horn.value(500,1,EnvGen.ar(envHorn));
	engine = ~engine.value(crasht+1,2);
	crash = ~hit.value(crasht,0.5);
	output = Mix.ar([engine, horns,crash]);
	Out.ar(0,Pan2.ar(output));
}).add;

/*
SONIDO GUITARRA
*/
SynthDef("plucking", {arg amp = 0.1, freq = 440, decay = 5, coef = 0.1;

var env, snd;
env = EnvGen.kr(Env.linen(0, decay, 0), doneAction: 2);
snd = Pluck.ar(
        in: WhiteNoise.ar(amp),
        trig: Impulse.kr(0),
        maxdelaytime: 0.1,
        delaytime: freq.reciprocal,
        decaytime: decay,
        coef: coef);
    Out.ar(0, [snd, snd]);
}).add;

/*
SONIDO SAX
*/
SynthDef(\sax, { |out, freq=440, amp=0.1, gate=1|
	var num = 16;
	var harms = Array.series(num, 1, 1) * Array.exprand(num, 0.995, 1.001);
	var snd = SinOsc.ar(freq * SinOsc.kr(Rand(2.0,5.0),0,Rand(0.001, 0.01),1) * harms, mul:Array.geom(num, 1, 0.63));
	snd = Splay.ar(snd);
	snd = BBandPass.ar(snd, freq * XLine.kr(0.1,4,0.01), 2);
	snd = snd * amp * EnvGen.ar(Env.adsr(0.001, 0.2, 0.7, 0.2), gate, doneAction:2);
	Out.ar(out, snd!2);
}).add;

)


(

// Selecciona el puerto
~n1 = NetAddr.new("127.0.0.1", 8080);
~anim1 = {
	// BOB
	Pbind(
		\instrument, "sax",
		\freq, Pseq([
			83, 80, 82, 83, 85, 83, 83, 82, 83, 85, 83, 76, 88, 83, 90, 82, 89, 83, 90, 85, 92, 83, 90, 83, 90, 82, 89, 83, 90, 85, 92, 83, 90, 76, 88].midicps, 2),
		\mtranspose, 1,
		\amp, 0.3,
		\decay, Pwhite(6, 10),
		\coef, Pseq([0.6], inf),
		\dur, Pseq([0.1,0.31,0.1,0.31,0.1,0.35,0.31,0.1,0.31,0.1,0.35,0.2,0.2,0.31,0.31,0.1,0.1,0.31,0.31,0.1,0.1,0.35,0.35,0.31,0.31,0.1,0.1,0.31,0.31,0.1,0.1,0.35,0.35,0.1]*3, inf)
	).play;
	~n1.sendMsg('/test', 1, 0, 0);
};


~anim2 = {
	// PATRICIO
	Pbind(
		\instrument, "sax",
		\freq, Pseq([
			63, 69, 63, 69, 63, 69, 69, 71, 69, 63, 69, 78, 63, 69, 69, 71, 63, 69, 63, 69, 78, 63, 69, 78, 71, 76, 71, 83, 70, 82, 71, 83, 73, 85, 71, 83, 76, 83, 76, 88, 80, 80, 78, 80, 78, 83, 76, 76, 71, 78, 73, 79, 79, 79, 78, 76, 71, 70, 71, 73, 71, 71, 70, 71, 73, 71, 75, 75, 76].midicps),
		\mtranspose, 1,
		\amp, 0.3,
		\decay, Pwhite(6, 10),
		\coef, Pseq([0.6], inf),
		\dur, Pseq([
0.1, 0.1, 0.3, 0.3, 0.1, 0.1, 0.35, 0.35, 0.1, 0.1, 0.35, 0.35, 0.35, 0.35, 0.73, 0.35, 0.31, 0.1, 0.35, 0.3, 0.3, 0.1, 0.73, 0.35, 0.3, 0.1, 0.35, 0.35, 0.3, 0.3, 0.1, 0.73, 0.35, 0.3, 0.45, 0.3, 0.31, 0.31, 0.1, 0.1, 0.31, 0.31, 0.1, 0.1, 0.35, 0.35, 0.35, 0.35, 0.35, 0.35, 0.31, 0.1, 0.31, 0.1, 0.35, 0.35, 0.35, 0.35, 0.31, 0.1, 0.35, 0.35, 0.35, 0.31, 0.1, 0.35, 0.31, 0.1, 0.31, 0.1, 0.73, 0.31, 0.1, 0.31, 0.1, 0.35, 0.31, 0.35, 2.83
]*1.5, inf)
	).play;

	~n1.sendMsg('/test', 0, 1, 0);
};


~anim3 = {
	~n1.sendMsg('/test', 0, 0, 1);
	Synth(\carro, [\tmjmp, 0.03 ,\tmshort, 0.05 ,\tmhold, 0.7 ,\wtm, 0.5]);
};

)


( // Ejecucion

~t = Task({

Pbind(
    \instrument, "plucking",
	\freq, Pseq([
  52, 59, 64, 68, 59, 64, 68, 68, 52, 59, 64, 68, 68, 59, 64, 68, 68, 52, 59, 64, 68, 68, 59, 64, 68, 68, 52, 59, 64, 68, 68, 59, 64, 68, 68, 52, 59, 64, 68, 68, 59, 64, 68, 68, 52, 59, 64, 68, 68, 75, 59, 59, 64, 68, 68, 71, 52, 59, 59, 64, 68, 68, 59, 59, 64, 68, 68, 52, 59, 64, 68, 59, 59, 64, 68, 68, 52, 59, 64, 68, 71, 59, 59, 64, 68, 68, 52, 64, 59, 68, 59, 64, 68, 63, 68, 72, 63, 68, 71, 63, 68, 52, 64, 59, 64, 68, 68, 59, 64, 69, 64, 69, 64, 69, 52, 64, 59, 64, 68, 68, 59, 59, 64, 68, 59, 63, 69, 63, 69, 62, 69, 66, 52, 59, 64, 59, 64, 68, 68, 59, 71, 64, 68, 68, 52, 64
].midicps),
	\mtranspose, -10,
    \amp, 0.2,
    \decay, Pwhite(6, 10),
    \coef, Pseq([0.6], inf),
    \dur, Pseq([
  0.35, 0.35, 0.35, 0.35, 0.35, 0.31, 0.31, 0.1, 0.35, 0.31, 0.31, 0.31, 0.1, 0.35, 0.31, 0.31, 0.1, 0.35, 0.31, 0.31, 0.31, 0.1, 0.35, 0.31, 0.31, 0.1, 0.35, 0.31, 0.31, 0.31, 0.1, 0.35, 0.31, 0.31, 0.1, 0.35, 0.31, 0.1, 0.35, 0.35, 0.35, 0.35, 0.35, 0.35, 0.35, 0.35, 0.31, 0.31, 0.1, 0.35, 0.31, 0.31, 0.1, 0.35, 0.35, 0.31, 0.31, 0.1, 0.1, 0.35, 0.31, 0.31, 0.31, 0.1, 0.35, 0.31, 0.31, 0.31, 0.1, 0.35, 0.31, 0.31, 0.31, 0.1, 0.35, 0.35, 0.31, 0.31, 0.35, 0.35, 0.35, 0.35, 0.35, 0.35, 0.35, 0.734, 0.734, 0.35, 0.35, 0.31, 0.31, 0.31, 0.1, 0.734, 0.35, 0.35, 0.35, 0.35, 0.734, 0.734, 0.35, 0.35, 0.31, 0.31, 0.31, 0.1, 0.35, 0.35, 0.35, 0.35, 0.35, 0.35, 0.35, 0.35, 0.35, 0.31, 0.31, 0.1, 0.35, 0.35, 0.35, 0.31, 0.31, 0.31, 0.1, 0.35, 0.35, 0.31, 0.31, 0.1, 1.57, 1.57
], inf)
).play;



4.125.wait;

~anim1.value;

20.wait;

~anim2.value;

20.wait;

//CARRO
(Task({
	~anim3.value;
	(2.5+1).wait;
	CmdPeriod.run;
}).play
)

}).play;

)


~anim1.value;
~anim2.value;
(Task({
	~anim3.value;
	(2.5+0.8).wait;
	CmdPeriod.run;
}).play
)





