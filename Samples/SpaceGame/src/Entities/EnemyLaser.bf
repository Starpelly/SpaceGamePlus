namespace SpaceGame;

class EnemyLaser : EnemyProjectile
{
	public float mVelX;
	public float mVelY;

	public override void Update()
	{
		base.Update();

		X += mVelX;
		Y += mVelY;

		if (IsOffscreen(16, 16))
			IsDeleting = true;
	}

	public override void Draw()
	{
		gGameApp.Draw(Images.sEnemyLaser, X - 10, Y - 13);
	}
}
