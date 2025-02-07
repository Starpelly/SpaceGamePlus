using System;

#if ENGINE_SDL2
using SDL2;
#elif ENGINE_RAYLIB
using RaylibBeef;
#endif

namespace SpaceGameEngine.Audio;

public class Sound
{
#if ENGINE_SDL2
	public SDLMixer.Chunk* mChunk;
#elif ENGINE_RAYLIB
	private RaylibBeef.Sound m_Sound;
	public RaylibBeef.Sound Sound;
#endif

	public ~this()
	{
#if ENGINE_SDL2
		if (mChunk != null)
			SDLMixer.FreeChunk(mChunk);
#elif ENGINE_RAYLIB
		Raylib.UnloadSound(m_Sound);
#endif
	}

	public Result<void> Load(StringView fileName)
	{
#if ENGINE_SDL2
		mChunk = SDLMixer.LoadWAV(fileName);
		if (mChunk == null)
			return .Err;
#elif ENGINE_RAYLIB
		m_Sound = Raylib.LoadSound(fileName.Ptr);

		if (m_Sound == default)
			return .Err;
#endif
		return .Ok;
	}
}