using SpaceGameEngine;
using SpaceGameEngine.Graphics;
namespace SpaceGame;

class HeroBullet : Entity
{
	public override void Update()
	{
		Y -= 8.0f;
		if (Y < -16)
			IsDeleting = true;

		for (let entity in gGameApp.CurrentScene.Entities)
		{
			if (let enemy = entity as Enemy)
			{
				if ((enemy.mBoundingBox.Contains((.)(X - entity.X), (.)(Y - entity.Y))) && (enemy.mHealth > 0))
				{
					IsDeleting = true;
					enemy.mHealth--;
					
					GameScene.Instance.ExplodeAt(X, Y, 0.25f, 1.25f);
					Engine.PlaySound(Sounds.Explode, 0.5f, 1.5f);

					break;
				}
			}
		}
	}

	public override void Draw()
	{
		Drawing.DrawImage(Images.sHeroLaser, X - 8, Y - 9);
	}
}
