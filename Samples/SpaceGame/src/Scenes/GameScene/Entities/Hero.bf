using SpaceGameEngine;
using SpaceGameEngine.Graphics;

namespace SpaceGame;

class Hero : Entity
{
	public const int SHOOT_DELAY = 10; // How many frames to delay between shots
	public const float MOVE_SPEED = 4.0f;

	public int mHealth = 1;
	public bool mIsMovingX;
	public int mShootDelay;

	public int mReviveDelay = 0;
	public int mInvincibleDelay = 0;

	public override void Draw()
	{
		if (mReviveDelay > 0)
			return;

		if ((mInvincibleDelay > 0) && ((mInvincibleDelay / 5 % 2 == 0)))
			return;

		float x = X - 29;
		float y = Y - 41;
		Image image = Images.sHero;

		SDL2.SDL.Rect srcRect = .(0, 0, image.mWidth, image.mHeight);
		SDL2.SDL.Rect destRect = .((int32)x, (int32)y, image.mWidth, image.mHeight);

		if (mIsMovingX)
		{
			int32 inset = (.)(srcRect.w * 0.09f);
			destRect.x += inset;
			destRect.w -= inset * 2;
		}

		Drawing.DrawImageRec(image, srcRect, destRect);
	}

	public override void Update()
	{
		if (mReviveDelay > 0)
		{
			if (--mReviveDelay == 0)
				GameScene.Instance.mScore = 0;
			return;
		}

		if (mInvincibleDelay > 0)
			mInvincibleDelay--;

		base.Update();
		if (mShootDelay > 0)
			mShootDelay--;

		if (mHealth < 0)
		{
			GameScene.Instance.ExplodeAt(X, Y, 1.0f, 0.5f);
			gGameApp.PlaySound(Sounds.Explode, 1.2f, 0.6f);
			GameScene.Instance.mDifficulty = 0;

			mHealth = 1;
			mReviveDelay = 100;
			mInvincibleDelay = 100;
		}
	}
}
