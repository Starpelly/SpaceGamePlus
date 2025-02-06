namespace SpaceGameEngine;

public abstract class App
{
	public this()
	{
		Engine.Init();
	}

	public ~this()
	{
		Engine.Shutdown();
	}

	public abstract void Init();
	public abstract void Update();
	public abstract void Draw();

	public void Run()
	{

	}
}