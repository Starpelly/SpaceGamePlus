using System;
using SDL2;
using System.Collections;

using SpaceGameEngine;

namespace SpaceGame;

static class Sounds
{
	public static Sound BeepMed;
	public static Sound BeepHigh;
	public static Sound BeepHighLong;
	public static Sound Fail;
	public static Sound Laser;
	public static Sound Explode;

	public static Sound Shoot01;
	public static Sound Shoot02;
	public static Sound Shoot03;
	public static Sound Shoot04;

	public static Sound Explosion01;
	public static Sound Explosion02;
	public static Sound Explosion03;
	public static Sound Explosion04;
	public static Sound Explosion05;
	public static Sound Explosion06;
	public static Sound Explosion07;
	public static Sound Explosion08;

	private static List<Sound> s_sounds = new .() ~ delete _;

	private static List<Sound> m_shotSounds = new .() ~ delete _;
	private static List<Sound> m_explosionSounds = new .() ~ delete _;

	public static Sound RandomShot => m_shotSounds[Engine.Random.Next(m_shotSounds.Count)];
	public static Sound RandomExplosion => m_explosionSounds[Engine.Random.Next(m_explosionSounds.Count)];

	public static void Dispose()
	{
		ClearAndDeleteItems(s_sounds);
	}

	public static Result<Sound> Load(StringView fileName)
	{
		Sound sound = new Sound();
		if (sound.Load(fileName) case .Err)
		{
			delete sound;
			return .Err;
		}
		s_sounds.Add(sound);
		return sound;
	}

	public static Result<void> Init()
	{
		BeepMed = Try!(Load("sounds/beep_med.wav"));
		BeepHigh = Try!(Load("sounds/beep_high.wav"));
		BeepHighLong = Try!(Load("sounds/beep_high_long.wav"));
		Fail = Try!(Load("sounds/fail.wav"));
		Laser = Try!(Load("sounds/laser01.wav"));
		Explode = Try!(Load("sounds/explode01.wav"));

		Shoot01 = Try!(Load("content/sounds/shoot-01.wav"));
		Shoot02 = Try!(Load("content/sounds/shoot-02.wav"));
		Shoot03 = Try!(Load("content/sounds/shoot-03.wav"));
		Shoot04 = Try!(Load("content/sounds/shoot-04.wav"));

		m_shotSounds.Add(Shoot01);
		m_shotSounds.Add(Shoot02);
		m_shotSounds.Add(Shoot03);
		m_shotSounds.Add(Shoot04);

		Explosion01 = Try!(Load("content/sounds/explosion-01.wav"));
		Explosion02 = Try!(Load("content/sounds/explosion-02.wav"));
		Explosion03 = Try!(Load("content/sounds/explosion-03.wav"));
		Explosion04 = Try!(Load("content/sounds/explosion-04.wav"));
		Explosion05 = Try!(Load("content/sounds/explosion-05.wav"));
		Explosion06 = Try!(Load("content/sounds/explosion-06.wav"));
		Explosion07 = Try!(Load("content/sounds/explosion-07.wav"));
		Explosion08 = Try!(Load("content/sounds/explosion-08.wav"));

		m_explosionSounds.Add(Explosion01);
		m_explosionSounds.Add(Explosion02);
		m_explosionSounds.Add(Explosion03);
		m_explosionSounds.Add(Explosion04);
		m_explosionSounds.Add(Explosion05);
		m_explosionSounds.Add(Explosion06);
		m_explosionSounds.Add(Explosion07);
		m_explosionSounds.Add(Explosion08);

		return .Ok;
	}
}
