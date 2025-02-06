namespace SpaceGameEngine;

public static class Engine
{
	public static uint32 WindowWidth { get; private set; }
	public static uint32 WindowHeight { get; private set; }

	private static Scene m_CurrentScene = null ~ delete _;

	public static void Init()
	{

	}

	public static void Shutdown()
	{

	}

	public static void Run()
	{

	}

	public static void ChangeScene<T>() where T : Scene
	{
		if (m_CurrentScene != null)
		{
			m_CurrentScene.OnUnload();
			DeleteAndNullify!(m_CurrentScene);
		}
		m_CurrentScene = new T();
		m_CurrentScene.OnLoad();
	}
}