using System.Collections;

namespace SpaceGameEngine;

public abstract class Scene
{
	protected readonly List<Entity> Entities = new .() ~ DeleteContainerAndItems!(_);

	public abstract void OnLoad();
	public abstract void OnUnload();

	public abstract void OnUpdate();
	public abstract void OnDraw();
}