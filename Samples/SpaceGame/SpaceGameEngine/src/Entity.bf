using SpaceGameEngine.Math;
namespace SpaceGameEngine;

public class Entity
{
	public Vector2 Position;
	public float X
	{
		get
		{
			return Position.X;
		}
		set
		{
			Position.X = value;
		}
	}
	public float Y
	{
		get
		{
			return Position.Y;
		}
		set
		{
			Position.Y = value;
		}
	}

	public bool IsDeleting;
	public int32 UpdateCount;
	
	public bool IsOffscreen(float marginX, float marginY)
	{
		return ((Position.X < -marginX) || (Position.X >= Engine.MainWindow.Width + marginX) ||
			(Position.Y < -marginY) || (Position.Y >= Engine.MainWindow.Height + marginY));
	}

	public virtual void Update()
	{
	}

	public virtual void Draw()
	{
	}
}
