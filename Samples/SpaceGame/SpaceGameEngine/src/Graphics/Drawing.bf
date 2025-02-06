using System;
using SpaceGameEngine.Math;

using internal SpaceGameEngine.Graphics.Renderer;

namespace SpaceGameEngine.Graphics;

/// Used for primitive drawing. (Shapes, Images, etc)
public static class Drawing
{
	public static void DrawImage(Image image, float x, float y)
	{
		SDL2.SDL.Rect srcRect = .(0, 0, image.mWidth, image.mHeight);
		SDL2.SDL.Rect destRect = .((int32)x, (int32)y, image.mWidth, image.mHeight);
		SDL2.SDL.RenderCopy(Engine.Renderer.SDLRenderer, image.mTexture, &srcRect, &destRect);
	}

	public static void DrawImage(Image image, float x, float y, float rot, float centerX, float centerY)
	{
		SDL2.SDL.Rect srcRect = .(0, 0, image.mWidth, image.mHeight);
		SDL2.SDL.Rect destRect = .((int32)x, (int32)y, image.mWidth, image.mHeight);
		SDL2.SDL.Point centerPoint = .((.)centerX, (.)centerY);
		SDL2.SDL.RenderCopyEx(Engine.Renderer.SDLRenderer, image.mTexture, &srcRect, &destRect, rot, &centerPoint, .None);
	}

	public static void DrawImageEx(Image image, float x, float y, float scaleX, float scaleY, uint8 alpha)
	{
		SDL2.SDL.SetTextureAlphaMod(image.mTexture, alpha);

		SDL2.SDL.Rect srcRect = .(0, 0, image.mWidth, image.mHeight);
		SDL2.SDL.FRect destRect = .(x, y, image.mWidth * scaleX, image.mHeight * scaleY);
		SDL2.SDL.RenderCopyF(Engine.Renderer.SDLRenderer, image.mTexture, &srcRect, &destRect);
	}

	public static void DrawImageRec(Image image, Rect srcRect, Rect destRect)
	{
		SDL2.SDL.Rect srcRectSDL = srcRect;
		SDL2.SDL.Rect destRectSDL = destRect;
		SDL2.SDL.RenderCopy(Engine.Renderer.SDLRenderer, image.mTexture, &srcRectSDL, &destRectSDL);
	}

	public static void DrawString(Font font, float x, float y, String str, Color color, bool centerX = false)
	{
		var x;
		if (font.mBMFont != null)
		{
			for (var page in font.mBMFont.mPages)
				SDL2.SDL.SetTextureColorMod(page.mImage.mTexture, color.R, color.G, color.B);
			
			var drawX = x;
			var drawY = y;

			if (centerX)
			{
				float width = 0;

				for (var c in str.RawChars)
				{
					if ((int32)c >= font.mBMFont.mCharData.Count)
						continue;
					var charData = ref font.mBMFont.mCharData[(int32)c];
					width += charData.mXAdvance;
				}

				drawX -= width / 2;
			}

			for (var c in str.RawChars)
			{
				if ((int32)c >= font.mBMFont.mCharData.Count)
					continue;
				var charData = ref font.mBMFont.mCharData[(int32)c];

				SDL2.SDL.Rect srcRect = .(charData.mX, charData.mY, charData.mWidth, charData.mHeight);
				SDL2.SDL.Rect destRect = .((int32)drawX + charData.mXOfs, (int32)drawY + charData.mYOfs, charData.mWidth, charData.mHeight);
				SDL2.SDL.RenderCopy(Engine.Renderer.SDLRenderer, font.mBMFont.mPages[charData.mPage].mImage.mTexture, &srcRect, &destRect);

				drawX += charData.mXAdvance;
			}
		}
		else
		{
#if !NOTTF
			SDL2.SDL.SetRenderDrawColor(Engine.Renderer.SDLRenderer, 255, 255, 255, 255);
			let surface = SDL2.SDLTTF.RenderUTF8_Blended(font.mFont, str, color);
			let texture = SDL2.SDL.CreateTextureFromSurface(Engine.Renderer.SDLRenderer, surface);
			SDL2.SDL.Rect srcRect = .(0, 0, surface.w, surface.h);

			if (centerX)
				x -= surface.w / 2;

			SDL2.SDL.Rect destRect = .((int32)x, (int32)y, surface.w, surface.h);
			SDL2.SDL.RenderCopy(Engine.Renderer.SDLRenderer, texture, &srcRect, &destRect);
			SDL2.SDL.FreeSurface(surface);
			SDL2.SDL.DestroyTexture(texture);
#endif
		}
	}
}