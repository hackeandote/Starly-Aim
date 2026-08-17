-- Starly aim - STARLY AIM
-- Creator: by@S

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Variables de Estado y Configuración del Aim
local AimbotEnabled = false
local AimKeyMode = "Siempre activo"
local TeamCheckEnabled = true
local KillCheckEnabled = true
local WallCheckEnabled = false
local HitboxEnabled = false
local HitboxGhostEnabled = false -- Opción Ghost: hitbox activa pero invisible
local SelectedHitbox = "Cabeza"
local TargetPriority = "Más cercano"
local FOVRadius = 60
local Smoothness = 3
local DistanceLimit = 500

-- Colores personalizables
local HitboxColor = Color3.fromRGB(255, 0, 0)
local FOVColor = Color3.fromRGB(255, 255, 255)

-- Variables de Visuales (ESP y Chams)
local BoxESPEnabled = false
local SkeletonEnabled = false
local PlayerInfoEnabled = false
local HealthBarEnabled = false
local SnaplineEnabled = false
local ChamsEnabled = false
local VisibleCheckColorEnabled = true
local MaxDistance = 500

-- Elemento Visual del FOV con la librería Drawing oficial de Roblox
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Thickness = 2
FOVCircle.NumSides = 60
FOVCircle.Color = FOVColor
FOVCircle.Transparency = 1
FOVCircle.Filled = false

local Window = Rayfield:CreateWindow({
   Name = "Starly Aim",
   LoadingTitle = "Cargando Starly aim...",
   LoadingSubtitle = "by@S",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "StarlyAimConfig",
      FileName = "StarlyConfig"
   },
   Discord = { Enabled = false, Invite = "noinvite", RememberJoins = true },
   KeySystem = false
})

local AimTab = Window:CreateTab("Aim", 4483362458)
local VisualsTab = Window:CreateTab("Visuals", 4483345998)
local ConfigTab = Window:CreateTab("Config", 4483362458)

-- ==================== APARTADO DE AIM ====================
AimTab:CreateSection("Aimbot & Hitbox Config")

AimTab:CreateToggle({
   Name = "Aimbot",
   CurrentValue = false,
   Flag = "AimbotToggle",
   Callback = function(Value)
      AimbotEnabled = Value
   end,
})

AimTab:CreateDropdown({
   Name = "Modo de Activación Aim",
   Options = {"Siempre activo", "Mantener pantalla"},
   CurrentOption = "Siempre activo",
   Flag = "AimModeDropdown",
   Callback = function(Option)
      AimKeyMode = Option
   end,
})

AimTab:CreateToggle({
   Name = "Team Check",
   CurrentValue = true,
   Flag = "TeamCheckToggle",
   Callback = function(Value)
      TeamCheckEnabled = Value
   end,
})

AimTab:CreateToggle({
   Name = "Kill Check (Ignorar muertos)",
   CurrentValue = true,
   Flag = "KillCheckToggle",
   Callback = function(Value)
      KillCheckEnabled = Value
   end,
})

AimTab:CreateToggle({
   Name = "WallCheck (Evita paredes)",
   CurrentValue = false,
   Flag = "WallCheckToggle",
   Callback = function(Value)
      WallCheckEnabled = Value
   end,
})

AimTab:CreateToggle({
   Name = "Hitbox Expander / Modifier",
   CurrentValue = false,
   Flag = "HitboxToggle",
   Callback = function(Value)
      HitboxEnabled = Value
   end,
})

AimTab:CreateToggle({
   Name = "Hitbox Ghost (Invisible)",
   CurrentValue = false,
   Flag = "HitboxGhostToggle",
   Callback = function(Value)
      HitboxGhostEnabled = Value
   end,
})

AimTab:CreateDropdown({
   Name = "Hitbox (Zona de impacto)",
   Options = {"Cabeza", "Cuello", "Pecho", "RootPart"},
   CurrentOption = "Cabeza",
   Flag = "HitboxDropdown",
   Callback = function(Option)
      SelectedHitbox = Option
   end,
})

AimTab:CreateDropdown({
   Name = "Color de Hitbox",
   Options = {"Rojo", "Azul", "Verde", "Blanco", "Amarillo"},
   CurrentOption = "Rojo",
   Flag = "HitboxColorDropdown",
   Callback = function(Option)
      if Option == "Rojo" then HitboxColor = Color3.fromRGB(255, 0, 0)
      elseif Option == "Azul" then HitboxColor = Color3.fromRGB(0, 0, 255)
      elseif Option == "Verde" then HitboxColor = Color3.fromRGB(0, 255, 0)
      elseif Option == "Blanco" then HitboxColor = Color3.fromRGB(255, 255, 255)
      elseif Option == "Amarillo" then HitboxColor = Color3.fromRGB(255, 255, 0)
      end
   end,
})

AimTab:CreateSlider({
   Name = "FOV Radius",
   Range = {0, 90},
   Increment = 1,
   CurrentValue = 60,
   Flag = "FOVSlider",
   Callback = function(Value)
      FOVRadius = Value
   end,
})

AimTab:CreateSlider({
   Name = "Smoothness (Suavizado)",
   Range = {1, 20},
   Increment = 0.5,
   CurrentValue = 3,
   Flag = "SmoothnessSlider",
   Callback = function(Value)
      Smoothness = Value
   end,
})

AimTab:CreateDropdown({
   Name = "Target Priority",
   Options = {"Más cercano", "Menos vida"},
   CurrentOption = "Más cercano",
   Flag = "TargetPriorityDropdown",
   Callback = function(Option)
      TargetPriority = Option
   end,
})

AimTab:CreateSlider({
   Name = "Distance Limit (Metros)",
   Range = {20, 1000},
   Increment = 10,
   CurrentValue = 500,
   Flag = "DistanceLimitSlider",
   Callback = function(Value)
      DistanceLimit = Value
   end,
})

AimTab:CreateToggle({
   Name = "Draw FOV",
   CurrentValue = false,
   Flag = "DrawFOVToggle",
   Callback = function(Value)
      DrawFOVEnabled = Value
      FOVCircle.Visible = Value
   end,
})

AimTab:CreateDropdown({
   Name = "Color de Círculo FOV",
   Options = {"Blanco", "Rojo", "Azul", "Verde", "Morado", "Cian"},
   CurrentOption = "Blanco",
   Flag = "FOVColorDropdown",
   Callback = function(Option)
      if Option == "Blanco" then FOVColor = Color3.fromRGB(255, 255, 255)
      elseif Option == "Rojo" then FOVColor = Color3.fromRGB(255, 0, 0)
      elseif Option == "Azul" then FOVColor = Color3.fromRGB(0, 0, 255)
      elseif Option == "Verde" then FOVColor = Color3.fromRGB(0, 255, 0)
      elseif Option == "Morado" then FOVColor = Color3.fromRGB(150, 0, 255)
      elseif Option == "Cian" then FOVColor = Color3.fromRGB(0, 255, 200)
      end
      FOVCircle.Color = FOVColor
   end,
})

-- ==================== APARTADO DE VISUALS ====================
VisualsTab:CreateSection("ESP Options")

VisualsTab:CreateToggle({
   Name = "Box ESP",
   CurrentValue = false,
   Flag = "BoxESPToggle",
   Callback = function(Value)
      BoxESPEnabled = Value
   end,
})

VisualsTab:CreateToggle({
   Name = "Chams (Material Visor)",
   CurrentValue = false,
   Flag = "ChamsToggle",
   Callback = function(Value)
      ChamsEnabled = Value
   end,
})

VisualsTab:CreateToggle({
   Name = "Visible Check Color (Rojo/Verde)",
   CurrentValue = true,
   Flag = "VisibleCheckColorToggle",
   Callback = function(Value)
      VisibleCheckColorEnabled = Value
   end,
})

VisualsTab:CreateToggle({
   Name = "Skeleton",
   CurrentValue = false,
   Flag = "SkeletonToggle",
   Callback = function(Value)
      SkeletonEnabled = Value
   end,
})

VisualsTab:CreateToggle({
   Name = "Player Info",
   CurrentValue = false,
   Flag = "PlayerInfoToggle",
   Callback = function(Value)
      PlayerInfoEnabled = Value
   end,
})

VisualsTab:CreateToggle({
   Name = "Health Bar",
   CurrentValue = false,
   Flag = "HealthBarToggle",
   Callback = function(Value)
      HealthBarEnabled = Value
   end,
})

VisualsTab:CreateToggle({
   Name = "Line / Snapline",
   CurrentValue = false,
   Flag = "SnaplineToggle",
   Callback = function(Value)
      SnaplineEnabled = Value
   end,
})

VisualsTab:CreateSlider({
   Name = "Max Distance",
   Range = {50, 1000},
   Increment = 25,
   CurrentValue = 500,
   Flag = "MaxDistanceSlider",
   Callback = function(Value)
      MaxDistance = Value
   end,
})

-- ==================== APARTADO DE CONFIG ====================
ConfigTab:CreateSection("Configuration Management")

ConfigTab:CreateButton({
   Name = "Save Config",
   Callback = function()
      Rayfield:SaveConfiguration()
      Rayfield:Notify({Title = "Starly aim", Content = "Configuración guardada.", Duration = 3})
   end,
})

ConfigTab:CreateButton({
   Name = "Load Config",
   Callback = function()
      Rayfield:LoadConfiguration()
      Rayfield:Notify({Title = "Starly aim", Content = "Configuración cargada.", Duration = 3})
   end,
})

ConfigTab:CreateButton({
   Name = "Reset to Default",
   Callback = function()
      Rayfield:LoadConfiguration()
      Rayfield:Notify({Title = "Starly aim", Content = "Valores restablecidos.", Duration = 3})
   end,
})

ConfigTab:CreateDropdown({
   Name = "Menu Theme / Color",
   Options = {"Default", "Amber", "Amethyst", "Blood", "DarkBlue", "Green", "Light", "Ocean"},
   CurrentOption = "Default",
   Flag = "ThemeDropdown",
   Callback = function(Option)
      print("Tema cambiado: ", Option)
   end,
})

-- ==================== FUNCIONES PRINCIPALES (MOTOR) ====================

local function GetTargetPart(character)
   if not character then return nil end
   if SelectedHitbox == "Cabeza" then
      return character:FindFirstChild("Head")
   elseif SelectedHitbox == "Cuello" then
      return character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso") or character:FindFirstChild("Head")
   elseif SelectedHitbox == "Pecho" then
      return character:FindFirstChild("LowerTorso") or character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
   else
      return character:FindFirstChild("HumanoidRootPart")
   end
end

local function IsVisible(targetPart, character)
   if not WallCheckEnabled then return true end
   if not targetPart or not LocalPlayer.Character then return false end
   
   local origin = Camera.CFrame.Position
   local direction = (targetPart.Position - origin)
   local raycastParams = RaycastParams.new()
   raycastParams.FilterType = RaycastFilterType.Exclude
   raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, character}
   raycastParams.IgnoreWater = true
   
   local result = workspace:Raycast(origin, direction, raycastParams)
   if result then
      return false
   end
   return true
end

local function GetClosestTarget()
   local bestTarget = nil
   local shortestDistance = math.huge
   local lowestHealth = math.huge

   local mousePos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

   for _, player in ipairs(Players:GetPlayers()) do
      if player ~= LocalPlayer then
         local isSameTeam = false
         if TeamCheckEnabled and player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team then
            isSameTeam = true
         end

         if not isSameTeam and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character:FindFirstChild("HumanoidRootPart") then
            local humanoid = player.Character.Humanoid
            local isDead = false
            if KillCheckEnabled and humanoid.Health <= 0 then
               isDead = true
            end

            if not isDead then
               local rootPart = player.Character.HumanoidRootPart
               local distance = (rootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude

               if distance <= DistanceLimit then
                  local targetPart = GetTargetPart(player.Character)
                  if targetPart then
                     if IsVisible(targetPart, player.Character) then
                        local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                        if onScreen then
                           local screenVector = Vector2.new(screenPos.X, screenPos.Y)
                           local mag = (screenVector - mousePos).Magnitude

                           local maxPixelFOV = (FOVRadius / 90) * (Camera.ViewportSize.X / 2)
                           
                           if mag <= maxPixelFOV then
                              if TargetPriority == "Más cercano" then
                                 if mag < shortestDistance then
                                    shortestDistance = mag
                                    bestTarget = targetPart
                                 end
                              elseif TargetPriority == "Menos vida" then
                                 if humanoid.Health < lowestHealth then
                                    lowestHealth = humanoid.Health
                                    bestTarget = targetPart
                                 end
                              end
                           end
                        end
                     end
                  end
               end
            end
         end
      end
   end
   return bestTarget
end

-- Bucle Principal de Ejecución por Frame
RunService.RenderStepped:Connect(function()
   -- Actualizar Dibujo y Posición del FOV en la Pantalla
   if DrawFOVEnabled and FOVRadius > 0 then
      FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
      FOVCircle.Radius = (FOVRadius / 90) * (Camera.ViewportSize.X / 2)
      FOVCircle.Color = FOVColor
      FOVCircle.Visible = true
   else
      FOVCircle.Visible = false
   end

   -- Lógica de Hitbox Expander y Hitbox Ghost
   if HitboxEnabled then
      for _, player in ipairs(Players:GetPlayers()) do
         if player ~= LocalPlayer then
            local isSameTeam = false
            if TeamCheckEnabled and player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team then
               isSameTeam = true
            end

            if not isSameTeam and player.Character then
               local humanoid = player.Character:FindFirstChild("Humanoid")
               if not (KillCheckEnabled and humanoid and humanoid.Health <= 0) then
                  local targetPart = GetTargetPart(player.Character)
                  if targetPart then
                     targetPart.Size = Vector3.new(4, 4, 4)
                     targetPart.CanCollide = false
                     
                     if HitboxGhostEnabled then
                        targetPart.Transparency = 1 -- Totalmente invisible (Ghost)
                        targetPart.Color = Color3.fromRGB(255, 255, 255)
                     else
                        targetPart.Transparency = 0.5 -- Visible con el color elegido
                        targetPart.Color = HitboxColor
                     end
                  end
               end
            end
         end
      end
   end

   -- Lógica de Chams (Material Visor en el personaje rival)
   for _, player in ipairs(Players:GetPlayers()) do
      if player ~= LocalPlayer and player.Character then
         for _, part in ipairs(player.Character:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
               if ChamsEnabled then
                  part.Material = Enum.Material.ForceField
               else
                  part.Material = Enum.Material.SmoothPlastic
               end
            end
         end
      end
   end

   -- Lógica de Aimbot Avanzado para PVP
   local shouldAim = AimbotEnabled
   if AimKeyMode == "Mantener pantalla" then
      shouldAim = AimbotEnabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
   end

   if shouldAim and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
      local target = GetClosestTarget()
      if target then
         local currentCamCFrame = Camera.CFrame
         local targetCFrame = CFrame.new(currentCamCFrame.Position, target.Position)
         Camera.CFrame = currentCamCFrame:Lerp(targetCFrame, 1 / math.max(Smoothness, 1))
      end
   end
end)

Rayfield:LoadConfiguration()
