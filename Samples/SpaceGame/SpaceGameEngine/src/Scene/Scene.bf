using System.Collections;

namespace SpaceGameEngine;

public abstract class Scene
{
	public readonly List<Entity> Entities = new .() ~ DeleteContainerAndItems!(_);

	protected abstract void OnLoad();
	protected abstract void OnUnload();

	protected abstract void OnUpdate();
	protected abstract void OnDraw();

	public void AddEntity(Entity entity)
	{
		Entities.Add(entity);
	}

	// ----------------
	// Internal methods
	// ----------------

	internal void Load()
	{
		OnLoad();
	}

	internal void Unload()
	{
		OnUnload();
	}

	internal void Update()
	{
		OnUpdate();

		for (let entity in Entities)
		{
			entity.UpdateCount++;
			entity.Update();
			if (entity.IsDeleting)
			{
				// '@entity' refers to the enumerator itself
		        @entity.Remove();
				delete entity;
			}
		}
	}

	internal void Draw()
	{
		OnDraw();

		for (let entity in Entities)
		{
			entity.Draw();
		}
	}

	// -----------------
	// Protected methods
	// -----------------

	protected void OnKeyPressed(KeyCode key)
	{
		for (let entity in Entities)
		{
			entity.OnKeyPressed(key);
		}
	}

	protected void OnKeyReleased(KeyCode key)
	{
		for (let entity in Entities)
		{
			entity.OnKeyReleased(key);
		}
	}

	protected void OnMouseButtonPressed(MouseButton button)
	{

	}

	protected void OnMouseButtonReleased(MouseButton button)
	{

	}
}