
local G2L = {}

-- ─── ScreenGui ────────────────────────────────────────────────────────────────
G2L["1"] = Instance.new("ScreenGui", game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"))
G2L["1"].DisplayOrder  = 666
G2L["1"].Enabled       = true
G2L["1"].Name          = "CheatMenu"
G2L["1"].ZIndexBehavior = Enum.ZIndexBehavior.Sibling

G2L["2"] = Instance.new("LocalScript", G2L["1"])

-- ─── Shared panel builder ─────────────────────────────────────────────────────
-- Each panel (Dungeon / Combat / Others) shares the same header structure.
-- Build it once via a helper to avoid ~60 lines of repetition per panel.
local function MakePanelHeader(parent, title, iconId)
	local folder = Instance.new("Folder", parent)
	folder.Name  = "Other"

	-- Bottom decoration frames
	local b1 = Instance.new("Frame", folder)
	b1.ZIndex               = 0
	b1.BorderSizePixel      = 0
	b1.BackgroundColor3     = Color3.fromRGB(18, 11, 25)
	b1.Size                 = UDim2.new(1, 0, 0.23966, 0)
	b1.Position             = UDim2.new(0, 0, 0.97677, 0)
	b1.Name                 = "Bottom"
	b1.BackgroundTransparency = 0.2

	local b2 = Instance.new("Frame", folder)
	b2.ZIndex           = 0
	b2.BorderSizePixel  = 0
	b2.BackgroundColor3 = Color3.fromRGB(18, 11, 25)
	b2.Size             = UDim2.new(1, 0, 0.47139, 0)
	b2.Position         = UDim2.new(0, 0, 0.52861, 0)
	b2.Name             = "Bottom"

	-- Title label
	local lbl = Instance.new("TextLabel", folder)
	lbl.TextWrapped         = true
	lbl.BorderSizePixel     = 0
	lbl.TextSize            = 25
	lbl.TextXAlignment      = Enum.TextXAlignment.Left
	lbl.TextScaled          = true
	lbl.BackgroundColor3    = Color3.fromRGB(255, 255, 255)
	lbl.FontFace            = Font.new("rbxasset://fonts/families/TitilliumWeb.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
	lbl.TextColor3          = Color3.fromRGB(147, 146, 147)
	lbl.BackgroundTransparency = 1
	lbl.Size                = UDim2.new(0.39205, 0, 1, 0)
	lbl.Position            = UDim2.new(0.35795, 0, 0, 0)
	lbl.Text                = title
	Instance.new("UITextSizeConstraint", lbl).MaxTextSize = 26

	-- Icon
	local img = Instance.new("ImageLabel", folder)
	img.BorderSizePixel      = 0
	img.ScaleType            = Enum.ScaleType.Fit
	img.BackgroundColor3     = Color3.fromRGB(255, 255, 255)
	img.AnchorPoint          = Vector2.new(0.5, 0.5)
	img.Image                = "rbxassetid://" .. iconId
	img.Size                 = UDim2.new(0.11364, 0, 0.64023, 0)
	img.BackgroundTransparency = 1
	img.Position             = UDim2.new(0.30114, 0, 0.5, 0)

	-- Collapse button
	local btn = Instance.new("TextButton", folder)
	btn.Name             = "CollapseBtn"
	btn.Text             = "▼"
	btn.TextScaled       = true
	btn.BorderSizePixel  = 0
	btn.BackgroundColor3 = Color3.fromRGB(35, 20, 50)
	btn.TextColor3       = Color3.fromRGB(180, 175, 185)
	btn.Size             = UDim2.new(0.13, 0, 0.68, 0)
	btn.Position         = UDim2.new(0.845, 0, 0.16, 0)
	btn.ZIndex           = 5
	local btnCorner = Instance.new("UICorner", btn)
	btnCorner.CornerRadius = UDim.new(0, 4)
	Instance.new("UITextSizeConstraint", btn).MaxTextSize = 18

	return folder
end

-- ─── Shared toggle-button builder ────────────────────────────────────────────
local DARK_BG   = Color3.fromRGB(18, 11, 25)
local FONT_TTW  = Font.new("rbxasset://fonts/families/TitilliumWeb.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)

local function MakeToggleBtn(parent, label, btnName)
	local btn = Instance.new("TextButton", parent)
	btn.TextWrapped     = true
	btn.BorderSizePixel = 0
	btn.TextXAlignment  = Enum.TextXAlignment.Left
	btn.TextScaled      = true
	btn.TextColor3      = Color3.fromRGB(255, 255, 255)
	btn.BackgroundColor3 = DARK_BG
	btn.FontFace        = FONT_TTW
	btn.Size            = UDim2.new(0.85227, 0, 0.26506, 0)
	btn.Text            = label
	btn.Name            = btnName
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
	Instance.new("UITextSizeConstraint", btn).MaxTextSize = 23
	Instance.new("UIAspectRatioConstraint", btn).AspectRatio = 6.81818

	-- Status dot
	local dot = Instance.new("ImageLabel", btn)
	dot.BorderSizePixel     = 0
	dot.BackgroundColor3    = Color3.fromRGB(255, 0, 0)
	dot.AnchorPoint         = Vector2.new(0.5, 0.5)
	dot.Size                = UDim2.new(0.04, 0, 0.27273, 0)
	dot.Position            = UDim2.new(0.9, 0, 0.5, 0)
	dot.Image               = ""
	Instance.new("UICorner", dot).CornerRadius = UDim.new(0, 5)

	return btn
end

local function MakeScrollingFrame(parent, sizeY)
	local sf = Instance.new("ScrollingFrame", parent)
	sf.Active                = true
	sf.BorderSizePixel       = 0
	sf.BackgroundColor3      = DARK_BG
	sf.Size                  = UDim2.new(1, 0, sizeY, 0)
	sf.ScrollBarImageColor3  = Color3.fromRGB(0, 0, 0)
	sf.Position              = UDim2.new(0, 0, 1.21643, 0)
	sf.BackgroundTransparency = 0.2
	sf.AutomaticCanvasSize   = Enum.AutomaticSize.Y

	local layout = Instance.new("UIListLayout", sf)
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	layout.Padding             = UDim.new(0, 5)
	layout.SortOrder           = Enum.SortOrder.LayoutOrder

	return sf
end

local function MakePanel(name, posX, posY, aspectRatio)
	local f = Instance.new("Frame", G2L["1"])
	f.BorderSizePixel  = 0
	f.BackgroundColor3 = DARK_BG
	f.Size             = UDim2.new(0.1399, 0, 0.04755, 0)
	f.Position         = UDim2.new(posX, 0, posY, 0)
	f.Name             = name
	Instance.new("UICorner", f).CornerRadius = UDim.new(0, 15)
	Instance.new("UIAspectRatioConstraint", f).AspectRatio = aspectRatio
	Instance.new("LocalScript", f).Name = "UIDrag"
	return f
end

-- ─── DUNGEON PANEL ────────────────────────────────────────────────────────────
G2L["3"] = MakePanel("Dungeon", 0.55485, 0.0137, 5.634)
MakePanelHeader(G2L["3"], "Dungeon", "7273246917")

local DungeonSF = MakeScrollingFrame(G2L["3"], 2.72097)
DungeonSF.Name = "ScrollingFrame"

local AutoLockBtn    = MakeToggleBtn(DungeonSF, "Auto Lock",    "AutoLock")
local AutoTPBtn      = MakeToggleBtn(DungeonSF, "Auto TP",      "AutoTP")
local AutoRestartBtn = MakeToggleBtn(DungeonSF, "Auto Restart", "AutoRestart")

-- ─── COMBAT PANEL ─────────────────────────────────────────────────────────────
G2L["21"] = MakePanel("Combat", 0.69952, 0.01522, 5.634)
MakePanelHeader(G2L["21"], "Combat", "856575323")

local CombatSF = MakeScrollingFrame(G2L["21"], 7)
CombatSF.Name = "ScrollingFrame"

local AutoSpamInvBtn = MakeToggleBtn(CombatSF, "Auto Spam inv Spell", "AutoSpamInvSpell")

-- AutoUseSoul compound frame
local AutoUseSoulFrame = Instance.new("Frame", CombatSF)
AutoUseSoulFrame.BorderSizePixel  = 0
AutoUseSoulFrame.BackgroundColor3 = DARK_BG
AutoUseSoulFrame.Size             = UDim2.new(0.852, 0, 0.32278, 0)
AutoUseSoulFrame.Name             = "AutoUseSoul"
Instance.new("UICorner", AutoUseSoulFrame).CornerRadius = UDim.new(0, 5)
Instance.new("UIAspectRatioConstraint", AutoUseSoulFrame).AspectRatio = 2.94024

local AutoUseSoulBtn = Instance.new("TextButton", AutoUseSoulFrame)
AutoUseSoulBtn.TextWrapped         = true
AutoUseSoulBtn.BorderSizePixel     = 0
AutoUseSoulBtn.TextXAlignment      = Enum.TextXAlignment.Left
AutoUseSoulBtn.TextScaled          = true
AutoUseSoulBtn.TextColor3          = Color3.fromRGB(255, 255, 255)
AutoUseSoulBtn.BackgroundColor3    = DARK_BG
AutoUseSoulBtn.FontFace            = FONT_TTW
AutoUseSoulBtn.BackgroundTransparency = 1
AutoUseSoulBtn.Size                = UDim2.new(1.02083, 0, 0.41429, 0)
AutoUseSoulBtn.Text                = "Auto Soul"
AutoUseSoulBtn.Name                = "Btn"
Instance.new("UITextSizeConstraint", AutoUseSoulBtn).MaxTextSize = 23
local soulDot = Instance.new("ImageLabel", AutoUseSoulBtn)
soulDot.BorderSizePixel  = 0
soulDot.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
soulDot.AnchorPoint      = Vector2.new(0.5, 0.5)
soulDot.Size             = UDim2.new(0, 5, 0, 5)
soulDot.Position         = UDim2.new(0.9, 0, 0.5, 0)
Instance.new("UICorner", soulDot).CornerRadius = UDim.new(0, 5)

local SoulBox = Instance.new("TextBox", AutoUseSoulFrame)
SoulBox.BorderSizePixel    = 0
SoulBox.TextWrapped        = true
SoulBox.TextSize           = 14
SoulBox.TextColor3         = Color3.fromRGB(0, 0, 0)
SoulBox.TextScaled         = true
SoulBox.BackgroundColor3   = Color3.fromRGB(255, 255, 255)
SoulBox.FontFace           = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
SoulBox.PlaceholderText    = "1 / 2"
SoulBox.Size               = UDim2.new(1.02083, 0, 0.58571, 0)
SoulBox.Position           = UDim2.new(0, 0, 0.41429, 0)
SoulBox.Text               = ""
SoulBox.BackgroundTransparency = 1
SoulBox.Name               = "TextBox"

-- AutoHealSpell compound frame
local AutoHealSpellFrame = Instance.new("Frame", CombatSF)
AutoHealSpellFrame.BorderSizePixel  = 0
AutoHealSpellFrame.BackgroundColor3 = DARK_BG
AutoHealSpellFrame.Size             = UDim2.new(0.852, 0, 0.32278, 0)
AutoHealSpellFrame.Name             = "AutoHealSpell"
Instance.new("UICorner", AutoHealSpellFrame).CornerRadius = UDim.new(0, 5)
Instance.new("UIAspectRatioConstraint", AutoHealSpellFrame).AspectRatio = 2.94024

local AutoHealSpellBtn = Instance.new("TextButton", AutoHealSpellFrame)
AutoHealSpellBtn.TextWrapped         = true
AutoHealSpellBtn.BorderSizePixel     = 0
AutoHealSpellBtn.TextXAlignment      = Enum.TextXAlignment.Left
AutoHealSpellBtn.TextScaled          = true
AutoHealSpellBtn.TextColor3          = Color3.fromRGB(255, 255, 255)
AutoHealSpellBtn.BackgroundColor3    = DARK_BG
AutoHealSpellBtn.FontFace            = FONT_TTW
AutoHealSpellBtn.BackgroundTransparency = 1
AutoHealSpellBtn.Size                = UDim2.new(1.02083, 0, 0.41429, 0)
AutoHealSpellBtn.Text                = "Auto Heal Spell"
AutoHealSpellBtn.Name                = "Btn"
Instance.new("UITextSizeConstraint", AutoHealSpellBtn).MaxTextSize = 23
local healDot = Instance.new("ImageLabel", AutoHealSpellBtn)
healDot.BorderSizePixel  = 0
healDot.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
healDot.AnchorPoint      = Vector2.new(0.5, 0.5)
healDot.Size             = UDim2.new(0, 5, 0, 5)
healDot.Position         = UDim2.new(0.9, 0, 0.5, 0)
Instance.new("UICorner", healDot).CornerRadius = UDim.new(0, 5)

local HealBox = Instance.new("TextBox", AutoHealSpellFrame)
HealBox.BorderSizePixel    = 0
HealBox.TextWrapped        = true
HealBox.TextSize           = 14
HealBox.TextColor3         = Color3.fromRGB(0, 0, 0)
HealBox.TextScaled         = true
HealBox.BackgroundColor3   = Color3.fromRGB(255, 255, 255)
HealBox.FontFace           = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
HealBox.PlaceholderText    = "50%"
HealBox.Size               = UDim2.new(1.02083, 0, 0.58571, 0)
HealBox.Position           = UDim2.new(0, 0, 0.41429, 0)
HealBox.Text               = ""
HealBox.BackgroundTransparency = 1
HealBox.Name               = "TextBox"

local AutoSpellBtn = MakeToggleBtn(CombatSF, "Auto Spell", "AutoSpell")

-- AutoItem compound frame
local AutoItemFrame = Instance.new("Frame", CombatSF)
AutoItemFrame.BorderSizePixel  = 0
AutoItemFrame.BackgroundColor3 = DARK_BG
AutoItemFrame.Size             = UDim2.new(0.852, 0, 0.32278, 0)
AutoItemFrame.Name             = "AutoItem"
Instance.new("UICorner", AutoItemFrame).CornerRadius = UDim.new(0, 5)
Instance.new("UIAspectRatioConstraint", AutoItemFrame).AspectRatio = 2.94024

local AutoItemBtn = Instance.new("TextButton", AutoItemFrame)
AutoItemBtn.TextWrapped         = true
AutoItemBtn.BorderSizePixel     = 0
AutoItemBtn.TextXAlignment      = Enum.TextXAlignment.Left
AutoItemBtn.TextScaled          = true
AutoItemBtn.TextColor3          = Color3.fromRGB(255, 255, 255)
AutoItemBtn.BackgroundColor3    = DARK_BG
AutoItemBtn.FontFace            = FONT_TTW
AutoItemBtn.BackgroundTransparency = 1
AutoItemBtn.Size                = UDim2.new(1.02083, 0, 0.41429, 0)
AutoItemBtn.Text                = "Auto Item"
AutoItemBtn.Name                = "Btn"
Instance.new("UITextSizeConstraint", AutoItemBtn).MaxTextSize = 23
local itemDot = Instance.new("ImageLabel", AutoItemBtn)
itemDot.BorderSizePixel  = 0
itemDot.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
itemDot.AnchorPoint      = Vector2.new(0.5, 0.5)
itemDot.Size             = UDim2.new(0, 5, 0, 5)
itemDot.Position         = UDim2.new(0.9, 0, 0.5, 0)
Instance.new("UICorner", itemDot).CornerRadius = UDim.new(0, 5)

local ItemPercentBox = Instance.new("TextBox", AutoItemFrame)
ItemPercentBox.BorderSizePixel    = 0
ItemPercentBox.TextWrapped        = true
ItemPercentBox.TextSize           = 14
ItemPercentBox.TextColor3         = Color3.fromRGB(200, 200, 200)
ItemPercentBox.TextScaled         = true
ItemPercentBox.BackgroundColor3   = Color3.fromRGB(255, 255, 255)
ItemPercentBox.FontFace           = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
ItemPercentBox.PlaceholderText    = "HP %"
ItemPercentBox.Size               = UDim2.new(0.50, 0, 0.58571, 0)
ItemPercentBox.Position           = UDim2.new(0, 0, 0.41429, 0)
ItemPercentBox.Text               = ""
ItemPercentBox.BackgroundTransparency = 1
ItemPercentBox.Name               = "PercentBox"

local ItemSlotBtn = Instance.new("TextButton", AutoItemFrame)
ItemSlotBtn.BorderSizePixel  = 0
ItemSlotBtn.TextScaled       = true
ItemSlotBtn.TextColor3       = Color3.fromRGB(255, 255, 255)
ItemSlotBtn.BackgroundColor3 = Color3.fromRGB(45, 28, 60)
ItemSlotBtn.FontFace         = FONT_TTW
ItemSlotBtn.Size             = UDim2.new(0.50, 0, 0.58571, 0)
ItemSlotBtn.Position         = UDim2.new(0.52, 0, 0.41429, 0)
ItemSlotBtn.Text             = "Item 1 (T)"
ItemSlotBtn.Name             = "ItemSlotBtn"
Instance.new("UICorner", ItemSlotBtn).CornerRadius = UDim.new(0, 5)
Instance.new("UITextSizeConstraint", ItemSlotBtn).MaxTextSize = 14

-- ─── OTHERS PANEL ─────────────────────────────────────────────────────────────
G2L["49"] = MakePanel("Others", 0.84579, 0.01522, 5.634)
MakePanelHeader(G2L["49"], "Others", "6653989")

local OtherSF = MakeScrollingFrame(G2L["49"], 5.19761)
OtherSF.Name = "ScrollingFrame"

local SellWeaponBtn  = MakeToggleBtn(OtherSF, "Sell Weapons", "SellWeapon")
local SellArmorBtn   = MakeToggleBtn(OtherSF, "Sell Armors",  "SellArmor")
local SellSpellBtn   = MakeToggleBtn(OtherSF, "Sell Spells",  "SellSpell")
local SellTrinketBtn = MakeToggleBtn(OtherSF, "Sell Trinkets","SellTrinket")

-- Info label frame
local InfoFrame = Instance.new("Frame", OtherSF)
InfoFrame.BorderSizePixel  = 0
InfoFrame.BackgroundColor3 = DARK_BG
InfoFrame.Size             = UDim2.new(0.852, 0, 0.32278, 0)
InfoFrame.Name             = "Info"
InfoFrame.LayoutOrder      = 5
Instance.new("UICorner", InfoFrame).CornerRadius = UDim.new(0, 5)

local InfoBtn = Instance.new("TextButton", InfoFrame)
InfoBtn.TextWrapped         = true
InfoBtn.BorderSizePixel     = 0
InfoBtn.TextXAlignment      = Enum.TextXAlignment.Left
InfoBtn.TextScaled          = true
InfoBtn.TextColor3          = Color3.fromRGB(255, 255, 255)
InfoBtn.BackgroundColor3    = DARK_BG
InfoBtn.FontFace            = FONT_TTW
InfoBtn.BackgroundTransparency = 1
InfoBtn.Size                = UDim2.new(1, 0, 1, 0)
InfoBtn.Text                = "It will not sell Upgraded Armors/Weapons — for Spells it upgrades them before selling useless ones."
InfoBtn.Name                = "Btn"
Instance.new("UITextSizeConstraint", InfoBtn).MaxTextSize = 23

-- ─── MAIN LOGIC ───────────────────────────────────────────────────────────────
local function C_2()
	local RunService, ReplicatedStorage, Players, VIM, HttpService, TweenService =
		game:GetService("RunService"),
		game:GetService("ReplicatedStorage"),
		game:GetService("Players"),
		game:GetService("VirtualInputManager"),
		game:GetService("HttpService"),
		game:GetService("TweenService")

	local CONFIG_FILE = "DungeonAuto_Config.json"

	-- FIX: SellTrinket key was missing from Config, causing toggle to flip a nil value
	local Config = {
		AutoLock         = false,
		AutoTP           = false,
		AutoRestart      = false,
		AutoUseSoul      = false,
		AutoHealSpell    = false,
		AutoSpell        = false,
		AutoSpamInvSpell = false,
		AutoItem         = false,
		SellTrinket      = false,   -- was missing
		AutoHealPercent  = 50,
		AutoItemPercent  = 50,
		AutoItemSlot     = 1,
		SoulNumber       = 1,
	}

	local savePending = false
	local function SaveConfig()
		if not writefile or savePending then return end
		savePending = true
		task.delay(0.5, function()
			savePending = false
			writefile(CONFIG_FILE, HttpService:JSONEncode(Config))
		end)
	end

	if readfile and isfile and isfile(CONFIG_FILE) then
		local ok, data = pcall(HttpService.JSONDecode, HttpService, readfile(CONFIG_FILE))
		if ok and type(data) == "table" then
			for k, v in pairs(data) do
				if Config[k] ~= nil then Config[k] = v end
			end
		end
	end

	local Remotes       = ReplicatedStorage:WaitForChild("Remotes")
	local Cards         = ReplicatedStorage:WaitForChild("Cards")
	local ReplayDungeon = ReplicatedStorage:FindFirstChild("ReplayDungeon")

	local UseSpell    = Remotes:WaitForChild("UseSpell")
	local EquipSpell  = Remotes:WaitForChild("EquipSpell")
	local AscendSpell = Remotes:WaitForChild("AscendSpell")
	local SellSpell   = Remotes:WaitForChild("SellSpell")
	local SellArmor   = Remotes:WaitForChild("SellArmor")
	local SellWeapon  = Remotes:WaitForChild("SellWeapon")
	local SellTrinket = Remotes:WaitForChild("SellTrinket")

	local Player          = Players.LocalPlayer
	local PlayerCards     = Player:WaitForChild("Cards")
	local CooldownsFolder = Player:WaitForChild("Cooldowns")

	-- ─── Status-dot helpers ───────────────────────────────────────────────────
	local function SetBtnColor(btn, on)
		local img = btn:FindFirstChildOfClass("ImageLabel")
		if img then
			img.BackgroundColor3 = on and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
		end
	end

	local allToggleBtns = {
		{ AutoLockBtn,      "AutoLock"         },
		{ AutoTPBtn,        "AutoTP"            },
		{ AutoRestartBtn,   "AutoRestart"       },
		{ AutoUseSoulBtn,   "AutoUseSoul"       },
		{ AutoHealSpellBtn, "AutoHealSpell"     },
		{ AutoSpellBtn,     "AutoSpell"         },
		{ AutoSpamInvBtn,   "AutoSpamInvSpell"  },
		{ AutoItemBtn,      "AutoItem"          },
		{ SellTrinketBtn,   "SellTrinket"       },
	}

	for _, pair in ipairs(allToggleBtns) do
		SetBtnColor(pair[1], Config[pair[2]])
	end

	-- ─── Collapse / expand panels ─────────────────────────────────────────────
	local tweenIn  = TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
	local tweenOut = TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.In)

	local panelDefs = {
		{ panel = G2L["3"],  sf = DungeonSF, fullSizeY = 2.72097 },
		{ panel = G2L["21"], sf = CombatSF,  fullSizeY = 7       },
		{ panel = G2L["49"], sf = OtherSF,   fullSizeY = 5.19761 },
	}

	for _, d in ipairs(panelDefs) do
		local collapsed   = false
		local collapseBtn = d.panel:FindFirstChild("Other") and d.panel.Other:FindFirstChild("CollapseBtn")
		if not collapseBtn then continue end

		collapseBtn.Activated:Connect(function()
			collapsed = not collapsed
			if collapsed then
				collapseBtn.Text = "▶"
				TweenService:Create(d.sf, tweenOut, {
					Size                   = UDim2.new(1, 0, 0, 0),
					BackgroundTransparency = 1,
				}):Play()
			else
				collapseBtn.Text = "▼"
				d.sf.Size = UDim2.new(1, 0, 0, 0)
				TweenService:Create(d.sf, tweenIn, {
					Size                   = UDim2.new(1, 0, d.fullSizeY, 0),
					BackgroundTransparency = 0.2,
				}):Play()
			end
		end)
	end

	-- ─── Toggle bindings ──────────────────────────────────────────────────────
	for _, pair in ipairs(allToggleBtns) do
		local btn, key = pair[1], pair[2]
		btn.Activated:Connect(function()
			Config[key] = not Config[key]
			SetBtnColor(btn, Config[key])
			SaveConfig()
		end)
	end

	-- ─── Input boxes ──────────────────────────────────────────────────────────
	local function BindNumBox(box, key, min, max, integer)
		box:GetPropertyChangedSignal("Text"):Connect(function()
			local v = tonumber(box.Text)
			if not v then return end
			Config[key] = math.clamp(integer and math.floor(v) or v, min, max)
			SaveConfig()
		end)
	end

	BindNumBox(HealBox,        "AutoHealPercent", 1, 100, false)
	BindNumBox(SoulBox,        "SoulNumber",      1, 2,   true)
	BindNumBox(ItemPercentBox, "AutoItemPercent", 1, 100, false)

	HealBox.Text        = tostring(Config.AutoHealPercent)
	SoulBox.Text        = tostring(Config.SoulNumber)
	ItemPercentBox.Text = tostring(Config.AutoItemPercent)

	local function RefreshItemSlotLabel()
		ItemSlotBtn.Text = Config.AutoItemSlot == 1 and "Item 1 (T)" or "Item 2 (G)"
	end
	RefreshItemSlotLabel()

	ItemSlotBtn.Activated:Connect(function()
		Config.AutoItemSlot = Config.AutoItemSlot == 1 and 2 or 1
		RefreshItemSlotLabel()
		SaveConfig()
	end)

	-- ─── Card / cooldown cache ────────────────────────────────────────────────
	local cachedCards   = PlayerCards:GetChildren()
	local healCache     = {}
	local cooldownCache = {}

	for _, c in ipairs(CooldownsFolder:GetChildren()) do cooldownCache[c.Name] = true end

	PlayerCards.ChildAdded:Connect(function(c)
		cachedCards[#cachedCards + 1] = c
		healCache[c.Name] = nil
	end)
	PlayerCards.ChildRemoved:Connect(function(c)
		for i, v in ipairs(cachedCards) do
			if v == c then table.remove(cachedCards, i); break end
		end
		healCache[c.Name] = nil
	end)
	CooldownsFolder.ChildAdded:Connect(function(c)   cooldownCache[c.Name] = true end)
	CooldownsFolder.ChildRemoved:Connect(function(c) cooldownCache[c.Name] = nil  end)
	-- FIX: only invalidate the specific card name, not the whole cache
	Cards.ChildAdded:Connect(function(c)   healCache[c.Name] = nil end)
	Cards.ChildRemoved:Connect(function(c) healCache[c.Name] = nil end)

	-- ─── Helpers ──────────────────────────────────────────────────────────────
	local function PressKey(key)
		VIM:SendKeyEvent(true,  key, false, game)
		task.delay(0.1, function() VIM:SendKeyEvent(false, key, false, game) end)
	end

	local function FlashBtn(btn)
		SetBtnColor(btn, true)
		task.wait(0.1)
		SetBtnColor(btn, false)
	end

	local function CollectAndSell(folder, remote, btn)
		local toSell = {}
		for _, item in ipairs(folder:GetChildren()) do
			local u = item:FindFirstChild("Upgrades")
			if u and u.Value <= 0 then toSell[#toSell + 1] = item end
		end
		if #toSell > 0 then remote:InvokeServer(toSell) end
		FlashBtn(btn)
	end

	-- ─── Sell buttons ─────────────────────────────────────────────────────────
	SellArmorBtn.Activated:Connect(function()
		CollectAndSell(Player.Armor, SellArmor, SellArmorBtn)
	end)

	SellWeaponBtn.Activated:Connect(function()
		CollectAndSell(Player.Weapons, SellWeapon, SellWeaponBtn)
	end)

	SellTrinketBtn.Activated:Connect(function()
		local seen, toSell = {}, {}
		for _, item in ipairs(Player.Trinkets:GetChildren()) do
			if seen[item.Name] then
				toSell[#toSell + 1] = item
			else
				seen[item.Name] = true
			end
		end
		if #toSell > 0 then SellTrinket:InvokeServer(toSell) end
		FlashBtn(SellTrinketBtn)
	end)

	-- FIX: duplicate floating block removed — this now only runs on button click
	SellSpellBtn.Activated:Connect(function()
		local groups, sellList = {}, {}
		for _, card in ipairs(cachedCards) do
			if not card:FindFirstChild("Stars") then continue end
			local g = groups[card.Name]
			if g then g[#g + 1] = card else groups[card.Name] = {card} end
		end
		for _, cards in pairs(groups) do
			local best, bestStars = nil, -math.huge
			for _, card in ipairs(cards) do
				if card.Stars.Value > bestStars then bestStars = card.Stars.Value; best = card end
			end
			for _, card in ipairs(cards) do
				if card == best then continue end
				if bestStars >= 5 then
					sellList[#sellList + 1] = card
				else
					AscendSpell:InvokeServer(best, card)
				end
			end
		end
		if #sellList > 0 then SellSpell:InvokeServer(sellList) end
		FlashBtn(SellSpellBtn)
	end)

	-- ─── Lobby restriction notice ─────────────────────────────────────────────
	if game.PlaceId == 17387762301 then
		local notice = Instance.new("TextButton", G2L["1"])
		notice.Size                   = UDim2.new(1, 0, 1, 0)
		notice.Text                   = "Lobby restrictions active [ Dungeon, Combat ]."
		notice.TextColor3             = Color3.new(1, 0, 0)
		notice.BackgroundTransparency = 1
		notice.TextScaled             = true
		notice.Activated:Connect(function() notice:Destroy() end)
		return
	end

	-- ─── Non-lobby logic ──────────────────────────────────────────────────────
	local function IsHealSpell(cardName)
		if healCache[cardName] ~= nil then return healCache[cardName] end
		local rep    = Cards:FindFirstChild(cardName)
		local result = rep ~= nil and rep:FindFirstChild("HealSpell") ~= nil
		healCache[cardName] = result
		return result
	end

	local Character, Humanoid, HRP
	local restartFired = false

	local function RefreshCharacter()
		Character    = Player.Character or Player.CharacterAdded:Wait()
		Humanoid     = Character:WaitForChild("Humanoid")
		HRP          = Character:WaitForChild("HumanoidRootPart")
		restartFired = false
	end
	RefreshCharacter()
	Player.CharacterAdded:Connect(RefreshCharacter)

	-- ─── Enemy tracking ───────────────────────────────────────────────────────
	local TARGET_SCAN_RATE    = 1.5
	local cachedTarget        = nil
	local cachedTargetHRP     = nil
	local cachedAllTargetHRPs = {}           -- reused each cycle
	local trackedEnemies      = {}           -- [model] = hrp
	local dungeonConnection   = nil

	local function untrackEnemy(model) trackedEnemies[model] = nil end

	local function tryTrackModel(object)
		if not object:IsA("Model") then return end
		if object == Character then return end
		local hum  = object:FindFirstChildOfClass("Humanoid")
		local root = object:FindFirstChild("HumanoidRootPart")
		if not hum or not root or trackedEnemies[object] then return end

		trackedEnemies[object] = root
		object.AncestryChanged:Connect(function(_, parent)
			if not parent then untrackEnemy(object) end
		end)
		if object.Name ~= "sans" then
			hum.Died:Connect(function() untrackEnemy(object) end)
		end
	end

	local function hookDungeon(dungeon)
		for _, obj in ipairs(dungeon:GetDescendants()) do tryTrackModel(obj) end
		dungeonConnection = dungeon.DescendantAdded:Connect(function(obj)
			local model = obj:IsA("Model") and obj or obj:FindFirstAncestorOfClass("Model")
			if model then tryTrackModel(model) end
		end)
	end

	-- ─── Trigger cache (separated from enemy scan) ────────────────────────────
	-- FIX: triggers were re-scanned via GetDescendants every 1.5 s inside the
	-- enemy loop. Now maintained by a DescendantAdded/Removed connection.
	local triggerOrder     = { "TriggerFight","TriggerBoss","EventTrigger","StartHallTrigger","MoveCamTrigger","StartTrigger" }
	local triggerParts     = {}    -- [name] = part
	local currentStep      = 1    -- FIX: was implicitly global
	local nextTriggerTime  = 0

	local function hookTriggers(dungeon)
		for _, obj in ipairs(dungeon:GetDescendants()) do
			if obj:IsA("BasePart") then triggerParts[obj.Name] = obj end
		end
		dungeon.DescendantAdded:Connect(function(obj)
			if obj:IsA("BasePart") then triggerParts[obj.Name] = obj end
		end)
		dungeon.DescendantRemoving:Connect(function(obj)
			if obj:IsA("BasePart") then triggerParts[obj.Name] = nil end
		end)
	end

	task.spawn(function()
		local dungeon = workspace:FindFirstChild("CurrentDungeon") or workspace:WaitForChild("CurrentDungeon")
		wait(1)
		hookDungeon(dungeon)
		hookTriggers(dungeon)

		workspace.ChildAdded:Connect(function(child)
			if child.Name ~= "CurrentDungeon" then return end
			table.clear(trackedEnemies)
			table.clear(triggerParts)
			currentStep = 1
			if dungeonConnection then dungeonConnection:Disconnect() end
			hookDungeon(child)
			hookTriggers(child)
		end)

		workspace.ChildRemoved:Connect(function(child)
			if child.Name ~= "CurrentDungeon" then return end
			table.clear(trackedEnemies)
			table.clear(triggerParts)
			if dungeonConnection then dungeonConnection:Disconnect() end
			cachedTarget, cachedTargetHRP = nil, nil
			table.clear(cachedAllTargetHRPs)
		end)
	end)

	-- Distance-sort loop (no more GetDescendants here)
	task.spawn(function()
		while task.wait(TARGET_SCAN_RATE) do
			if not HRP then
				cachedTarget, cachedTargetHRP = nil, nil
				table.clear(cachedAllTargetHRPs)
				continue
			end
			if not workspace:FindFirstChild("CurrentDungeon") then
				cachedTarget, cachedTargetHRP = nil, nil
				table.clear(cachedAllTargetHRPs)
				continue
			end

			-- Step the trigger queue
			local now  = tick()
			local step = currentStep
			while step <= #triggerOrder and not triggerParts[triggerOrder[step]] do step += 1 end

			local triggerBoss = nil
			if step <= #triggerOrder and now >= nextTriggerTime then
				triggerBoss     = triggerParts[triggerOrder[step]]
				currentStep     = step + 1
				nextTriggerTime = now + 1
			end
			if currentStep > #triggerOrder then
				currentStep     = 1
				nextTriggerTime = now + 1
			end

			-- Find nearest enemy from pre-built tracked table; reuse allHRPs table
			local bestModel, bestDist = nil, math.huge
			table.clear(cachedAllTargetHRPs)

			for model, root in pairs(trackedEnemies) do
				local hum = model:FindFirstChildOfClass("Humanoid")
				if hum and (model.Name == "sans" or hum.Health > 1) then
					local d = (root.Position - HRP.Position).Magnitude
					if d < bestDist then bestDist, bestModel = d, model end
					cachedAllTargetHRPs[#cachedAllTargetHRPs + 1] = root
				end
			end

			local nearest    = bestModel or triggerBoss
			cachedTarget     = nearest
			cachedTargetHRP  = nearest and (nearest:IsA("BasePart") and nearest or nearest:FindFirstChild("HumanoidRootPart"))
		end
	end)

	local function IsValidSpellTarget(target)
		if not target or not target:IsA("Model") then return false end
		local hum  = target:FindFirstChildOfClass("Humanoid")
		local root = target:FindFirstChild("HumanoidRootPart")
		return hum ~= nil and root ~= nil and hum.Health >= 1
	end

	-- ─── Heartbeat ────────────────────────────────────────────────────────────
	RunService.Heartbeat:Connect(function()
		if not Character or not HRP then return end
		if Config.AutoRestart and not restartFired and ReplayDungeon then
			restartFired = true
			ReplayDungeon:FireServer()
		end
		if Config.AutoLock and cachedTargetHRP then
			HRP.CFrame = CFrame.new(HRP.Position, Vector3.new(cachedTargetHRP.Position.X, HRP.Position.Y, cachedTargetHRP.Position.Z))
		end
	end)

	-- ─── AutoTP ───────────────────────────────────────────────────────────────
	task.spawn(function()
		while true do
			task.wait(0.1)   -- 0-rate: run as fast as safe
			if not (Character and HRP and Config.AutoTP) then continue end
			for _, tHRP in ipairs(cachedAllTargetHRPs) do
				if not tHRP or not tHRP.Parent then continue end
				HRP.CFrame = tHRP.CFrame * CFrame.new(0, 0, 3)
				local tool = Character:FindFirstChildOfClass("Tool")
				if tool then tool:Activate() end
				task.wait()
			end
			if cachedTargetHRP and cachedTargetHRP.Parent then
				HRP.CFrame  = cachedTargetHRP.CFrame * CFrame.new(0, 0, 0)
				cachedTargetHRP = nil
			end
		end
	end)

	-- ─── AutoSpamInvSpell ─────────────────────────────────────────────────────
	-- FIX: simplified slot-split arithmetic
	local function castPart(cards, slot)
		for _, card in ipairs(cards) do
			if not card or cooldownCache[card.Name] then continue end
			if Config.AutoHealSpell and IsHealSpell(card.Name) then continue end
			EquipSpell:InvokeServer(card, slot)
			UseSpell:FireServer(card)
			task.wait(0.05)
		end
	end

	task.spawn(function()
		while task.wait(1) do
			if not (Character and Config.AutoSpamInvSpell and IsValidSpellTarget(cachedTarget)) then continue end
			local cards = cachedCards
			local n     = #cards
			if n == 0 then continue end
			local third = math.ceil(n / 3)
			-- Split into three roughly equal buckets
			local p1, p2, p3 = {}, {}, {}
			for i, card in ipairs(cards) do
				if i <= third       then p1[#p1+1] = card
				elseif i <= third*2 then p2[#p2+1] = card
				else                     p3[#p3+1] = card
				end
			end
			task.spawn(castPart, p1, 1)
			task.spawn(castPart, p2, 2)
			task.spawn(castPart, p3, 3)
		end
	end)

	-- ─── AutoHealSpell ────────────────────────────────────────────────────────
	task.spawn(function()
		while task.wait(0.1) do
			if not (Character and Humanoid and Config.AutoHealSpell) then continue end
			if (Humanoid.Health / Humanoid.MaxHealth) * 100 > Config.AutoHealPercent then continue end
			for _, card in ipairs(cachedCards) do
				if (Humanoid.Health / Humanoid.MaxHealth) * 100 >= 100 then break end
				if IsHealSpell(card.Name) and not cooldownCache[card.Name] then
					if card:FindFirstChild("Equipped") then
						EquipSpell:InvokeServer(card, 4)
						UseSpell:FireServer(card)
					end
				end
			end
		end
	end)

	-- ─── AutoSpell ────────────────────────────────────────────────────────────
	task.spawn(function()
		while task.wait(0.1) do
			if not (Character and Config.AutoSpell) then continue end
			for _, card in ipairs(cachedCards) do
				if not card then continue end
				local eq = card:FindFirstChild("Equipped")
				if eq and eq.Value >= 1 and not cooldownCache[card.Name] then
					UseSpell:FireServer(card)
				end
			end
		end
	end)

	-- ─── AutoSoul ─────────────────────────────────────────────────────────────
	task.spawn(function()
		while task.wait(0.1) do
			if not (Character and Config.AutoUseSoul) then continue end
			PressKey(Config.SoulNumber == 1 and Enum.KeyCode.Z or Enum.KeyCode.X)
		end
	end)

	-- ─── AutoItem ─────────────────────────────────────────────────────────────
	task.spawn(function()
		while task.wait(0.1) do
			if not (Character and Humanoid and Config.AutoItem) then continue end
			if (Humanoid.Health / Humanoid.MaxHealth) * 100 > Config.AutoItemPercent then continue end
			local slotStr = tostring(Config.AutoItemSlot)
			for _, item in ipairs(Player.Items:GetChildren()) do
				if item.HotKey.Value == slotStr then
					Remotes.UseItem:InvokeServer(item)
				end
			end
		end
	end)

	print("[DungeonAuto] Loaded")
end

task.spawn(C_2)

-- ─── UIDrag ───────────────────────────────────────────────────────────────────
-- FIX: no need to task.spawn non-yielding calls
local function MakeDrag(frame)
	local UIS = game:GetService("UserInputService")
	local dragToggle, dragStart, startPos

	frame.InputBegan:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1
		and input.UserInputType ~= Enum.UserInputType.Touch then return end
		dragToggle = true
		dragStart  = input.Position
		startPos   = frame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragToggle = false end
		end)
	end)

	UIS.InputChanged:Connect(function(input)
		if not dragToggle then return end
		if input.UserInputType ~= Enum.UserInputType.MouseMovement
		and input.UserInputType ~= Enum.UserInputType.Touch then return end
		local delta = input.Position - dragStart
		game:GetService("TweenService"):Create(frame, TweenInfo.new(0.25), {
			Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			),
		}):Play()
	end)
end

MakeDrag(G2L["3"])   -- Dungeon
MakeDrag(G2L["21"])  -- Combat
MakeDrag(G2L["49"])  -- Others

return G2L["1"]
