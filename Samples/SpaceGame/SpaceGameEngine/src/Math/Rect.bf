namespace SpaceGameEngine.Math;

public struct Rect
{
	public int32 x;
	public int32 y;
	public int32 width;
	public int32 height;

	public this()
	{
		this = default;
	}

	public this(int32 x, int32 y, int32 width, int32 height)
	{
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
	}

	public bool Contains(int32 x, int32 y)
	{
		return (x >= this.x) && (x < this.x + this.width) &&
			(y >= this.y) && (y < this.y + this.height);
	}

	public static implicit operator SDL2.SDL.Rect(Rect rect)
	{
		return .(rect.x, rect.y, rect.width, rect.height);
	}
}