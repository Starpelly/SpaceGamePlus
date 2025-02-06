namespace SpaceGameEngine.Math;

public struct Vector2
{
	public float X = 0.0f;
	public float Y = 0.0f;

	public this()
	{
		this.X = 0;
		this.Y = 0;
	}

	public this(float x, float y)
	{
		this.X = x;
		this.Y = y;
	}

	public this(float xy)
	{
		this.X = xy;
		this.Y = xy;
	}

	public static Vector2 zero 	=> .(0, 0);
	public static Vector2 one 	=> .(1, 1);
	public static Vector2 up 	=> .(0f, 1f);
	public static Vector2 down 	=> .(0f, -1f);
	public static Vector2 left 	=> .(-1f, 0f);
	public static Vector2 right => .(1f, 0f);

	public static Vector2 PositiveInfinity => .(float.PositiveInfinity, float.PositiveInfinity);
	public static Vector2 VegativeInfinity => .(float.NegativeInfinity, float.NegativeInfinity);

	// ------------------
	// Operator Overloads
	// ------------------

	public static Vector2 operator +(Vector2 a, Vector2 b) 	=> .(a.X + b.X, a.Y + b.Y);
	public static Vector2 operator -(Vector2 a, Vector2 b) 	=> .(a.X - b.X, a.Y - b.Y);
	public static Vector2 operator *(Vector2 a, Vector2 b) 	=> .(a.X * b.X, a.Y * b.Y);
	public static Vector2 operator /(Vector2 a, Vector2 b) 	=> .(a.X / b.X, a.Y / b.Y);
	public static Vector2 operator -(Vector2 a) 			=> .(-a.X, -a.Y);
	public static Vector2 operator +(Vector2 a, float d) 	=> .(a.X + d, a.Y + d);
	public static Vector2 operator +(float a, Vector2 d) 	=> .(a + d.X, a + d.Y);
	public static Vector2 operator -(Vector2 a, float d) 	=> .(a.X - d, a.Y - d);
	public static Vector2 operator -(float a, Vector2 d) 	=> .(a - d.X, a - d.Y);
	public static Vector2 operator *(Vector2 a, float d) 	=> .(a.X * d, a.Y * d);
	public static Vector2 operator *(float a, Vector2 d) 	=> .(a * d.X, a * d.Y);
	public static Vector2 operator /(Vector2 a, float d) 	=> .(a.X / d, a.Y / d);
	public static Vector2 operator /(float a, Vector2 d) 	=> .(a / d.X, a / d.Y);
}