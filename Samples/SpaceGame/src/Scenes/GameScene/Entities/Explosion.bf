using SpaceGameEngine;
using SpaceGameEngine.Graphics;
using SpaceGameEngine.Math;

namespace SpaceGame;

class Explosion : Entity
{
	public float mSizeScale;
	public float mSpeedScale;

	int32 Frame
	{
		get
		{
			return (int32)(mSpeedScale * UpdateCount);
		}
	}

	public override void Update()
	{
		if (Frame == 42)
			IsDeleting = true;
	}

	public override void Draw()
	{
		let image = Images.sExplosionImage;
		float x = X - (65 * mSizeScale);
		float y = Y - (65 * mSizeScale);

		let srcRect = Rect((Frame % 6) * 130, (Frame / 6) * 130, 130, 130);
		let destRect = Rect((int32)x, (int32)y, (int32)(mSizeScale * 130), (int32)(mSizeScale * 130));

		Drawing.DrawImageRec(image, srcRect, destRect);
	}
}
