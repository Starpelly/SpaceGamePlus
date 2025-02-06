using SpaceGameEngine;
using SpaceGameEngine.Graphics;
using SpaceGameEngine.Math;
using System;

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

	private bool mHasShot;
	private bool mHasMoved;

	public override void Draw()
	{
		if (mReviveDelay > 0)
			return;

		if ((mInvincibleDelay > 0) && ((mInvincibleDelay / 5 % 2 == 0)))
			return;

		float x = X - 29;
		float y = Y - 41;
		Image image = Images.sHero;

		Rect srcRect = .(0, 0, image.mWidth, image.mHeight);
		Rect destRect = .((int32)x, (int32)y, image.mWidth, image.mHeight);

		if (mIsMovingX)
		{
			int32 inset = (.)(srcRect.width * 0.09f);
			destRect.x += inset;
			destRect.width -= inset * 2;
		}

		Drawing.DrawImageRec(image, srcRect, destRect);
	}

	public override void Update()
	{
		HandleInputs();

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

	private void HandleInputs()
	{
		float deltaX = 0;
		float deltaY = 0;
		float moveSpeed = Hero.MOVE_SPEED;
		if (Input.IsKeyDown(.Left))
			deltaX -= moveSpeed;
		if (Input.IsKeyDown(.Right))
			deltaX += moveSpeed;

		if (Input.IsKeyDown(.Up))
			deltaY -= moveSpeed;
		if (Input.IsKeyDown(.Down))
			deltaY += moveSpeed;

		if ((deltaX != 0) || (deltaY != 0))
		{
			X = Math.Clamp(X + deltaX, 10, Engine.MainWindow.Width - 10);
			Y = Math.Clamp(Y + deltaY, 10, Engine.MainWindow.Height - 10);
			mHasMoved = true;
		}
		mIsMovingX = deltaX != 0;

		if ((Input.IsKeyDown(.Space)) && (mShootDelay == 0))
		{
			mHasShot = true;
			mShootDelay = Hero.SHOOT_DELAY;
			let bullet = new HeroBullet();
			bullet.X = X;
			bullet.Y = Y - 50;
			GameScene.Instance.AddEntity(bullet);

			gGameApp.PlaySound(Sounds.RandomShot, Engine.Random.NextFloat(0.085f, 0.1f));
		}

		if (mHasMoved && mHasShot)
		{
			GameScene.Instance.ShouldSpawnEnemies = true;
		}
	}
}
