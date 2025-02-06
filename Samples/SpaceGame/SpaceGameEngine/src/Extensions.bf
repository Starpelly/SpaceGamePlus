namespace System;

extension Random
{
	public float NextFloat(float min, float max, bool allowNegative = false)
	{
		let d = max - min;
		if (allowNegative)
		{
			let f = NextDouble() * (d * 2);
			if (f < d)
				return -(float)(f + min);
			return (float)(f - d + min);
		}
		return (float)(NextDouble() * d + min);
	}
}