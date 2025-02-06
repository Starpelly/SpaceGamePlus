namespace SpaceGame;

class Entity
{
	public bool IsDeleting;
	public int32 UpdateCount;
	public float X;
	public float Y;
	
	public bool IsOffscreen(float marginX, float marginY)
	{
		return ((X < -marginX) || (X >= gGameApp.mWidth + marginX) ||
			(Y < -marginY) || (Y >= gGameApp.mHeight + marginY));
	}

	public virtual void Update()
	{
	}

	public virtual void Draw()
	{
	}
}
