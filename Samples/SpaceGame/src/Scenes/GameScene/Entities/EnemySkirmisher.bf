using System;
using SpaceGameEngine;
using SpaceGameEngine.Graphics;

namespace SpaceGame;

class EnemySkirmisher : Enemy
{
	public class Spawner : Entity
	{
		public bool mLeftSide;

		public override void Update()
		{
			if (UpdateCount % 20 == 0)
			{
				let enemy = new EnemySkirmisher();
				enemy.Y = Y;
				if (mLeftSide)
				{
					enemy.X = -24;
					enemy.mRot = 0.0f;
					enemy.mRotAdd = -(0.001f + (float)Engine.Random.NextDouble() * 0.001f);
				}
				else
				{
					enemy.X = Engine.MainWindow.Width + 24;
					enemy.mRot = (float)-Math.PI_d;
					enemy.mRotAdd = 0.001f + (float)Engine.Random.NextDouble() * 0.001f;
				}
				
				GameScene.Instance.AddEntity(enemy);
			}

			if (UpdateCount >= 200)
				IsDeleting = true;
		}
	}

	public float mRot;
	public float mRotAdd;

	public this()
	{
		mBoundingBox = .(-20, -15, 40, 30);
		mHealth = 1;
	}

	public override void Update()
	{
		float speed = 3.0f;
		X += (float)Math.Cos(mRot) * speed;
		Y += (float)Math.Sin(mRot) * speed;

		mRot += mRotAdd;

		if (IsOffscreen(32, 32))
			IsDeleting = true;

		if (mHealth <= 0)
		{
			explode();
		}

		if (Engine.Random.NextDouble() < 0.01)
		{
			let enemyLaser = new EnemyLaser();
			enemyLaser.X = X;
			enemyLaser.Y = Y;
			enemyLaser.mVelX = ((float)Engine.Random.NextDouble() - 0.5f) * 1.0f;
			enemyLaser.mVelY = 2.0f;
			GameScene.Instance.AddEntity(enemyLaser);
		}
	}

	public override void Draw()
	{
		Drawing.DrawImage(Images.sEnemySkirmisher, X - 21, Y - 16);
	}

	private void explode()
	{
		GameScene.Instance.ExplodeAt(X, Y, 0.6f, 1.2f);
		gGameApp.PlaySound(Sounds.Explode, 0.7f, 1.2f);
		GameScene.Instance.mScore += 50;
		IsDeleting = true;
	}
}
