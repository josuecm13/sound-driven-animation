/*
SONIDO DEL CARRO:
- Sonido de los frenos
- Sonido del choque
*/

(

~horn = {
	arg frequency, mul = 0.5, env;
	Mix.ar([LFSaw.ar(frequency, mul: mul),LFSaw.ar(frequency - 70 - 20.rand,  mul: mul)]) * env
};

~engine = {
	arg engineTime = 5, doneAction = 0;
	var envelope = Env.new([1,1,0],[engineTime *0.9, engineTime * 0.1]);
	Mix.ar([BrownNoise.ar(0.6 * EnvGen.ar(envelope)) , (BrownNoise.ar(LFPulse.ar(12)) * 0.4 * EnvGen.ar(envelope, doneAction:doneAction)) ])
};

~brake = {
	arg waitingTime = 3, noiseFunc = PinkNoise;
	var env = Env.new([0,0,0.8,0],[waitingTime,0.001,1.42]), noise;
	noise = noiseFunc.ar(EnvGen.ar(env));
	noise = LPF.ar(noise,5500);
	Mix.ar([SinOsc.ar(1130,mul: 0.5), SinOsc.ar(1912,mul:0.1), SinOsc.ar(3016,mul:0.05), noise])
};

({~brake.value(0, WhiteNoise)}.play)

SynthDef(\carro,{
	var engine, brake, horns, envHorn, tmjmp = 0.1, tmshort = 0.54, output;
	envHorn = Env.new([0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0],
		[2,tmjmp,2.19,tmjmp,0.9,tmjmp,tmshort,tmjmp,tmshort,tmjmp,tmshort,tmjmp,tmshort,tmjmp,tmshort,tmjmp,tmshort,tmjmp,2.19,tmpshort]);
	horns = ~horn.value(500,1,EnvGen.ar(envHorn,doneAction:0));
	engine = ~engine.value(12,2);
	output = Mix.ar([horns,engine]);
	Out.ar(0,Pan2.ar(output));
}).add;


Synth(\carro);


)