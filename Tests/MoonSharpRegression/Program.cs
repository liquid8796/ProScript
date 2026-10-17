using MoonSharp.Interpreter;
using MoonSharp.Interpreter.Loaders;
using System;
using System.IO;

if (!File.Exists(Path.Combine("Quests", "Quest.lua")))
{
    Console.Error.WriteLine("Run from the ProScript repository root.");
    Environment.Exit(2);
}
var tests = new[] { "Tests/test_discoverable_visit.lua", "Tests/test_rock_tunnel_route.lua" };
foreach (var test in tests)
{
    var lua = new Script(CoreModules.Preset_Complete);
    lua.Options.ScriptLoader = new FileSystemScriptLoader
    {
        ModulePaths = new[] { "?.lua", "?/init.lua" }
    };
    try
    {
        lua.DoFile(test);
        Console.WriteLine("PASS " + test);
    }
    catch (Exception ex)
    {
        Console.Error.WriteLine("FAIL " + test + ": " + ex);
        Environment.ExitCode = 1;
    }
}
