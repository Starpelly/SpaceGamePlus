using System;

namespace SpaceGame;

static
{
	public static float NextFloat(this Random r, float min, float max, bool allowNegative = false)
	{
		let d = max - min;
		if (allowNegative)
		{
			let f = r.NextDouble() * (d * 2);
			if (f < d)
				return -(float)(f + min);
			return (float)(f - d + min);
		}
		return (float)(r.NextDouble() * d + min);
	}
}