#if TOOLS
using Godot;
using System;
using System.Diagnostics;

[Tool]
public partial class excel_utilities : EditorPlugin
{
	Godot.Collections.Dictionary dic = new Godot.Collections.Dictionary();
	public override void _EnterTree()
	{
		// Initialization of the plugin goes here.
		var file = FileAccess.Open("path", FileAccess.ModeFlags.ReadWrite);
		dic.Add("a","b");
	}

    public override void _ExitTree()
	{
		// Clean-up of the plugin goes here.
	}
}
#endif
