using System;

using SpaceGameEngine;
using SpaceGameEngine.Graphics;

namespace SpaceGame;

class EnemyGolaith : Enemy
{
	enum State
	{
		Lowering,
		Firing,
		Raising,

		Death
	}

	State mState;
	int mStateTick;
	float mAlpha = 1.0f;

	public this()
	{
		mBoundingBox = .(-60, -150, 120, 300);
		mHealth = 20;
	}

	public override void Update()
	{
		if ((mHealth <= 0) && (mState != .Death))
		{
			mState = .Death;
			mStateTick = 0;
			GameScene.Instance.mScore += 500;
		}

		switch (mState)
		{
		case .Lowering:
			Y += 2.0f;
			if (Y >= 300)
				mState++;
		case .Firing:
			mStateTick++;
			if (mStateTick % 4 == 0)
			{
				let enemyLaser = new EnemyLaser();
				enemyLaser.X = X;
				enemyLaser.Y = Y;
				float angle = ((float)Engine.Random.NextDouble() - 0.5f) * 3.0f + (float)Math.PI_d/2;
				float speed = 3.0f;
				enemyLaser.mVelX = (float)Math.Cos(angle) * speed;
				enemyLaser.mVelY = (float)Math.Sin(angle) * speed;
				GameScene.Instance.AddEntity(enemyLaser);
			}
			if (mStateTick == 200)
				mState++;
		case .Raising:
			Y -= 2.0f;
			if (Y < -300)
				IsDeleting = true;

		case .Death:
			mStateTick++;
			if (mStateTick % 6 == 0)
			{
				GameScene.Instance.ExplodeAt(X + (float)Engine.Random.NextDoubleSigned() * 40, Y + (float)Engine.Random.NextDoubleSigned() * 40, 1.0f, 0.4f);
				Engine.PlaySound(Sounds.Explode, 1.0f, 1.0f);
			}
			mAlpha = Math.Max(0.0f, mAlpha - 0.015f);
			if (mAlpha <= 0)
				IsDeleting = true;
		}
	}

	public override void Draw()
	{
		// SDL.SetTextureAlphaMod(Images.sEnemyGoliath.mTexture, (.)(255 * mAlpha));
		Drawing.DrawImage(Images.sEnemyGoliath, X - 63, Y - 168);
		// SDL.SetTextureAlphaMod(Images.sEnemyGoliath.mTexture, 255);
	}
}
