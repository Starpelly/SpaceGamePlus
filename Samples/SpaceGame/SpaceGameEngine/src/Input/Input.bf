namespace SpaceGameEngine;

public static class Input
{
	private static bool* m_KeyboardState;

	internal static void Poll()
	{
#if ENGINE_SDL2
		m_KeyboardState = SDL2.SDL.GetKeyboardState(null);
#endif
	}

	public static bool IsKeyDown(KeyCode keycode)
	{
#if ENGINE_SDL2
		if (m_KeyboardState == null)
			return false;
		return m_KeyboardState[(int)keycode];
#elif ENGINE_RAYLIB
		return RaylibBeef.Raylib.IsKeyDown((int32)keycode);
#endif
	}

	public static bool IsKeyUp(KeyCode keycode)
	{
		return !IsKeyDown(keycode);
	}
}