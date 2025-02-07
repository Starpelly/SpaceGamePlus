#if ENGINE_SDL2
using SDL2;
#endif

namespace SpaceGameEngine.Audio;

public class AudioManager
{
	private bool m_HasAudio = false;
	public bool HasAudio => m_HasAudio;

	public this()
	{
#if ENGINE_SDL2
		m_HasAudio = SDLMixer.OpenAudio(44100, SDLMixer.MIX_DEFAULT_FORMAT, 2, 4096) >= 0;
#endif
	}

	public ~this()
	{

	}
}