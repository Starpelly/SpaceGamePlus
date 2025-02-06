using SDL2;
using System;
using System.IO;

namespace SpaceGameEngine;

public class Font
{
	public SDLTTF.Font* mFont;
	public BitmapFont mBMFont;

	public this()
	{

	}

	public ~this()
	{
		if (mFont != null)
			SDLTTF.CloseFont(mFont);
		delete mBMFont;
	}

	public Result<void> Load(StringView fileName, int32 pointSize)
	{
		if (fileName.EndsWith(".fnt"))
		{
			mBMFont = new BitmapFont();

			var contents = File.ReadAllText(fileName, .. scope .());
			contents.Replace("\r", "");
			for (var line in contents.Split('\n', .RemoveEmptyEntries))
			{
				bool CheckVal(StringView text, StringView key, ref int32 val)
				{
					if (!text.StartsWith(key))
						return false;
					if (text[key.Length] != '=')
						return false;
					val = int32.Parse(text.Substring(key.Length + 1));
					return true;
				}

				bool CheckVal(StringView text, String key, String val)
				{
					if (!text.StartsWith(key))
						return false;
					if (text[key.Length] != '=')
						return false;
					StringView sv = text.Substring(key.Length + 1);
					if (sv.StartsWith('"'))
						sv.RemoveFromStart(1);
					if (sv.EndsWith('"'))
						sv.RemoveFromEnd(1);
					val.Append(sv);
					return true;
				}

				if (line.StartsWith("page"))
				{
					String imageFileName = scope .();

					for (var text in line.Split(' ', .RemoveEmptyEntries))
						CheckVal(text, "file", imageFileName);

					var dir = Path.GetDirectoryPath(fileName, .. scope .());
					var imagePath = scope $"{dir}/{imageFileName}";

					BitmapFont.Page page = new BitmapFont.Page();
					page.mImage = new Image()..Load(imagePath);
					mBMFont.mPages.Add(page);
				}
				
				if (line.StartsWith("char"))
				{
					BitmapFont.CharData* charData = null;

					for (var text in line.Split(' ', .RemoveEmptyEntries))
					{
						int32 id = 0;
						if (CheckVal(text, "id", ref id))
						{
							while (id >= mBMFont.mCharData.Count)
								mBMFont.mCharData.Add(default);
							charData = &mBMFont.mCharData[id];
						}

						if (charData != null)
						{
							CheckVal(text, "x", ref charData.mX);
							CheckVal(text, "y", ref charData.mY);
							CheckVal(text, "width", ref charData.mWidth);
							CheckVal(text, "height", ref charData.mHeight);
							CheckVal(text, "xoffset", ref charData.mXOfs);
							CheckVal(text, "yoffset", ref charData.mYOfs);
							CheckVal(text, "xadvance", ref charData.mXAdvance);
							CheckVal(text, "page", ref charData.mPage);
						}
					}
				}
			}
			return .Ok;
		}

		mFont = SDLTTF.OpenFont(fileName.ToScopeCStr!(), pointSize);
		if (mFont == null)
			return .Err;
		return .Ok;
	}
}