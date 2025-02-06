namespace SpaceGameEngine;

public static class Input
{
	private static bool* m_KeyboardState;

	internal static void Poll()
	{
		m_KeyboardState = SDL2.SDL.GetKeyboardState(null);
	}

	public static bool IsKeyDown(KeyCode keycode)
	{
		if (m_KeyboardState == null)
			return false;
		return m_KeyboardState[(int)keycode];
	}

	public static bool IsKeyUp(KeyCode keycode)
	{
		return !IsKeyDown(keycode);
	}
}