workspace "Game"
  architecture "x86_64"
  startproject "Game"

  configurations
  {
    "Debug",
    "Release",
    "Dist"
  }

outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

-- Include directories relative to root folder (solution directory)
IncludeDir = {}
IncludeDir["GLFW"] = "%{wks.location}/Game/vendor/GLFW/include"
IncludeDir["Vulkan"] = "C:/VulkanSDK/1.2.198.1/Include"
IncludeDir["glm"] = "%{wks.location}/Game/vendor/glm"
IncludeDir["ImGui"] = "%{wks.location}/Game/vendor/imgui"

LibDir = { Win = {} }
LibDir["Win"]["Vulkan"] = "C:/VulkanSDK/1.2.198.1/Lib/vulkan-1.lib"

group "Dependencies"
  include "Game/vendor/GLFW"
  include "Game/vendor/imgui"
group ""

project "Game"
  location "Game"
  kind "ConsoleApp"
  language "C++"
  cppdialect "C++17"
  staticruntime "off"

  targetdir ("bin/" .. outputdir .. "/%{prj.name}")
  objdir ("bin-int/" .. outputdir .. "/%{prj.name}")

  pchheader "pch.h"
  pchsource "Game/src/pch.cpp"

  files
  {
    "%{prj.name}/src/**.h",
    "%{prj.name}/src/**.cpp"
  }

  defines
  {
    "_CRT_SECURE_NO_WARNINGS"
  }

  includedirs
  {
    "%{prj.name}/src",
    "%{IncludeDir.GLFW}",
    "%{IncludeDir.Vulkan}",
    "%{IncludeDir.glm}",
    "%{IncludeDir.ImGui}"
  }

  links
  {
    "GLFW",
    "ImGui"
  }

  filter "system:windows"
    systemversion "latest"

    links
    {
      "%{LibDir.Win.Vulkan}"
    }

    defines
    {
    }

  filter "configurations:Debug"
    defines
    {
      "WG_DEBUG"
    }
    runtime "Debug"
    symbols "on"

  filter "configurations:Release"
    defines
    {
      "WG_RELEASE"
    }
    runtime "Release"
    optimize "on"

  filter "configurations:Dist"
    defines
    {
      "WG_DIST"
    }
    runtime "Release"
    optimize "on"
