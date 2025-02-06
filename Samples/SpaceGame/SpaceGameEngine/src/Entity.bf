using SpaceGameEngine.Math;
namespace SpaceGameEngine;

public class Entity
{
	public Vector2 Position;

	public bool IsDeleting;
	public int32 UpdateCount;
	
	public bool IsOffscreen(float marginX, float marginY)
	{
		return ((Position.X < -marginX) || (Position.X >= Engine.WindowWidth + marginX) ||
			(Position.Y < -marginY) || (Position.Y >= Engine.WindowHeight + marginY));
	}

	public virtual void Update()
	{
	}

	public virtual void Draw()
	{
	}
}
