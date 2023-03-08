workspace "Omega Engine"
    architecture "x64"

    configurations
    {
        "Debug",
        "Release",
        "Dist"
    }


outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

project "Core"
    location "Core"
    kind "StaticLib"        -- [.dll: "SharedLib"] [.lib: "StaticLib"]
    language "C++"
    targetname ("core")

    targetdir ("bin/" .. outputdir .. "/%{prj.name}")
    objdir ("bin-obj/" .. outputdir .. "/%{prj.name}")

    files
    {
        "%{prj.name}/src/**.h",
        "%{prj.name}/src/**.cpp"
    }
    includedirs
    {

    }
    -- Filters for Windows
    filter "system.windows"
        cppdialect "C++17"
        staticruntime "on"
        systemversion "10.0.22621.755"

        defines
        {
            "OMG_PLATFORM_WINDOW",
            "OMG_BUILD_DLL"
        }

    -- Copping dll file to the [Application: 'SandBox'] targetdir
    postbuildcommands
    {
        ("{COPY} %{cfg.buildtarget.relpath} ../bin/" .. outputdir .. "SandBox"),
        ("mkdir XOX")
    }


    -- Filters for Different configurations
    filter "configurations.Debug"
        defines "OMG_DEBUG"
        symbols "on"
    
    filter "configurations.Release"
        defines "OMG_RELEASE"
        optimize "on"
    
    filter "configurations.Dist"
        defines "OMG_DIST"
        optimize "on"
        

    filter {"system.windows", "configurations.Release"}
        buildoptions "/MT"


-- Project SandBox
project "SandBox"
    location "SandBox"
    kind "ConsoleApp"        -- dll -> "SharedLib"
    language "C++"
    targetname "sandbox"

    targetdir ("bin/" .. outputdir .. "/%{prj.name}")
    objdir ("bin-obj/" .. outputdir .. "/%{prj.name}")

    files
    {
        "%{prj.name}/src/**.h",
        "%{prj.name}/src/**.cpp"
    }
    includedirs
    {
        "Core/src"
    }

    -- Linking with the Core Lib 
    links
    {
        "Core"
    }

    -- Filters for Windows
    filter "system.windows"
        cppdialect "C++17"
        staticruntime "on"
        systemversion "10.0.22621.755"

        defines
        {
            "OMG_PLATFORM_WINDOW"
        }

       
    -- Filters for Different configurations
    filter "configurations.Debug"
        defines "OMG_DEBUG"
        symbols "on"
    
    filter "configurations.Release"
        defines "OMG_RELEASE"
        optimize "on"
    
    filter "configurations.Dist"
        defines "OMG_DIST"
        optimize "on"
        

    filter {"system.windows", "configurations.Release"}
        buildoptions "/MT"