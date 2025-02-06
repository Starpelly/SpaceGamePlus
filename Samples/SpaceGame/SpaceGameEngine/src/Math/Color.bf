namespace SpaceGameEngine.Math;

typealias byte = uint8;

public struct Color
{
	public byte R = 0;
	public byte G = 0;
	public byte B = 0;
	public byte A = 0;

	/// Creates a Color with an alpha of 255.
	public this(byte r, byte g, byte b)
	{
		this.R = r;
		this.G = g;
		this.B = b;
		this.A = 255;
	}

	public this(byte r, byte g, byte b, byte a)
	{
		this.R = r;
		this.G = g;
		this.B = b;
		this.A = a;
	}

	public this(uint packedValue)
	{
		this.R = (byte)packedValue;
		this.G = (byte)(packedValue >> 8);
		this.B = (byte)(packedValue >> 16);
		this.A = (byte)(packedValue >> 24);
	}

	public byte this[int index]
	{
	    get
	    {
	        switch (index)
	        {
	            case 0: return R;
	            case 1: return G;
	            case 2: return B;
				case 3: return A;
	            default:
	                return 0;
	        }
	    }
	    set mut
	    {
	        switch (index)
	        {
	            case 0: R = value; break;
	            case 1: G = value; break;
	            case 2: B = value; break;
				case 3: A = value; break;

	            default:
	                break;
	        }
	    }
	}

	public static Color Transparent = .(0);
	public static Color Black = .(0, 0, 0, 255);

	public static operator SDL2.SDL.Color(Color color)
	{
		return .(color.R, color.G, color.B, color.A);
	}
}