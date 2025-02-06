using internal SpaceGameEngine.Engine;

namespace SpaceGameEngine;

public abstract class App
{
	private readonly WindowProps m_InitialWindowProperties;

	public Scene CurrentScene => Engine.CurrentScene;

	// --------------
	// Public methods
	// --------------

	public this(WindowProps windowProperties)
	{
		m_InitialWindowProperties = windowProperties;
	}

	public ~this()
	{
		Engine.Shutdown();
	}

	public void Init()
	{
		Engine.Init(this, m_InitialWindowProperties);
		OnInit();
	}

	public void Run()
	{
		Engine.Run();
	}

	// ----------------
	// Abstract methods
	// ----------------

	public abstract void OnInit();
	public abstract void OnUpdate();
	public abstract void OnDraw();
}