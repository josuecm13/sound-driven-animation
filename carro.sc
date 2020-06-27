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

~hit = {
	arg waitingTime = 4, releaseTime = 0.9;
	var env = Env.new([0,0,45,0],[waitingTime, 0.2, releaseTime], \sin);
	WhiteNoise.kr(EnvGen.ar(env, doneAction:2))
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
	Mix.ar([SinOsc.ar(1130,mul: 0.5 *EnvGen.ar(env)), SinOsc.ar(1912,mul:0.1* EnvGen.ar(env)), SinOsc.ar(3016,mul:0.05 *EnvGen.ar(env)), noise])
};

SynthDef(\carro,{
	arg tmjmp = 0.05, tmshort = 0.05, tmhold = 0.4, wtm = 0.5;
	var engine, brake, horns, envHorn, output, crash;
	envHorn = Env.new([0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0],
		[wtm,tmjmp,tmhold,tmjmp,tmhold * 0.5,tmjmp,tmshort,tmjmp,tmshort,tmjmp,tmshort,tmjmp,tmshort,tmjmp,tmshort,tmjmp,tmshort,tmjmp,tmhold,tmshort]);
	horns = ~horn.value(500,1,EnvGen.ar(envHorn));
	engine = ~engine.value(12,2);
	crash = ~hit.value(3,0.5);
	output = Mix.ar([engine, horns,crash]);
	Out.ar(0,Pan2.ar(output));
}).add;

~car = {
	var engine, brake, horns, envHorn, tmjmp = 0.1, tmshort = 0.54, output;
	envHorn = Env.new([0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0],
		[2,tmjmp,2.19,tmjmp,0.9,tmjmp,tmshort,tmjmp,tmshort,tmjmp,tmshort,tmjmp,tmshort,tmjmp,tmshort,tmjmp,tmshort,tmjmp,2.19,tmshort]);
	horns = ~horn.value(500,1,EnvGen.ar(envHorn,doneAction:2));
	engine = ~engine.value(12,2);
	output = Mix.ar([horns,engine]);
	Pan2.ar(output)
};
)


({~car.value()}.play)


Synth(\carro, [\tmjmp, 0.03 ,\tmshort, 0.05 ,\tmhold, 0.7 ,\wtm, 0.5]);



({~hit.value(0.1,0.7)}.play)

({~brake.value}.play)


