--[=[
    @class BaseWindow

    Window For Every Ui IN THE PROJECT!!!
    (c) 2023 Bloxcode
]=]

local require = require(script.Parent.Loader).load(script)

local BasicPane = require("BasicPane")
local Blend = require("Blend")
local BasicPaneUtils = require("BasicPaneUtils")

local BaseWindow = setmetatable({}, BasicPane)
BaseWindow.__index = BaseWindow
BaseWindow.ClassName = "BaseWindow"

function BaseWindow.new(obj)
    local self = setmetatable(BasicPane.new(obj), BaseWindow)

    self._displayName = Blend.State("Window!")
    self._maid:GiveTask(self._displayName)

    return self
end

function BaseWindow:SetDisplayName(name)
    self._displayName:Set(name)
    return self
end

function BaseWindow:_renderBase()
    return Blend.New "Frame" {
    Position = UDim2.fromScale(0.5, 0.5);
    AnchorPoint = Vector2.new(0.5, 0.5);
    Size = UDim2.fromScale(0.6, 0.6);
    BackgroundTransparency = 1;
    BorderColor3 = Color3.fromRGB(27, 42, 53);
    BorderSizePixel = 1;
    [Blend.Children] = {
        Blend.New "UIAspectRatioConstraint" {
            AspectRatio = 1.310345;
            DominantAxis = Enum.DominantAxis.Height;
        };
        Blend.New "UIScale" {
            Scale = 1;
        };
        Blend.New "ImageLabel" {
            Position = UDim2.fromScale(-0.01385, -0.015124);
            Size = UDim2.fromScale(1.039243, 1.099818);
            BackgroundTransparency = 1;
            BorderColor3 = Color3.fromRGB(27, 42, 53);
            BorderSizePixel = 1;
            Image = "http://www.roblox.com/asset/?id=12399488564";
            ImageTransparency = 0.5;
            Visible = false;
            ZIndex = 3;
        };
        Blend.New "Frame" {
            Name = "Window";
            Position = UDim2.fromScale(0.5, 0.5);
            AnchorPoint = Vector2.new(0.5, 0.5);
            Size = UDim2.fromScale(1, 1);
            BackgroundColor3 = Color3.fromRGB(33, 35, 39);
            BorderColor3 = Color3.fromRGB(27, 42, 53);
            BorderSizePixel = 1;
            [Blend.Children] = {
                Blend.New "UICorner" {
                    CornerRadius = UDim.new(0.065, 0);
                };
                Blend.New "UIStroke" {
                    Color = Color3.fromRGB(255, 255, 255);
                    Thickness = 6.7;
                };
                Blend.New "TextLabel" {
                    Name = "Title";
                    Position = UDim2.fromScale(0.5, 0.171809);
                    AnchorPoint = Vector2.new(0.5, 0.5);
                    Size = UDim2.fromScale(0.797634, 0.121174);
                    BackgroundTransparency = 1;
                    BorderColor3 = Color3.fromRGB(27, 42, 53);
                    BorderSizePixel = 1;
                    FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json");
                    Text = "Quest!";
                    TextColor3 = Color3.fromRGB(255, 255, 255);
                    TextScaled = true;
                    TextSize = 100;
                    TextWrapped = true;
                    TextXAlignment = Enum.TextXAlignment.Left;
                };
                Blend.New "CanvasGroup" {
                    Name = "Content";
                    Position = UDim2.fromScale(0.497692, 0.598306);
                    AnchorPoint = Vector2.new(0.5, 0.5);
                    Size = UDim2.fromScale(0.798, 0.596975);
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                    BackgroundTransparency = 1;
                    BorderSizePixel = 0;
                    [Blend.Children] = {
                        Blend.New "UICorner" {
                            CornerRadius = UDim.new(0.045, 0);
                        };
                        Blend.New "UIGradient" {
                            Rotation = 90;
                            Transparency = NumberSequence.new({
                                NumberSequenceKeypoint.new(0, 0),
                                NumberSequenceKeypoint.new(0.741015, 0),
                                NumberSequenceKeypoint.new(0.878435, 0.551913),
                                NumberSequenceKeypoint.new(1, 1)
                            });
                        };
                    };
                };
            };
        };
        Blend.New "Frame" {
            Name = "DropShadow";
            Position = UDim2.new(0.5, 7, 0.5, 7);
            AnchorPoint = Vector2.new(0.5, 0.5);
            Size = UDim2.fromScale(1, 1);
            BackgroundColor3 = Color3.fromRGB(0, 0, 0);
            BackgroundTransparency = 0.35;
            BorderColor3 = Color3.fromRGB(27, 42, 53);
            BorderSizePixel = 1;
            ZIndex = 0;
            [Blend.Children] = {
                Blend.New "UICorner" {
                    CornerRadius = UDim.new(0.065, 0);
                };
                Blend.New "UIStroke" {
                    Thickness = 6.7;
                    Transparency = 0.35;
                };
            };
        };
        Blend.New "Frame" {
            Name = "InfoTip";
            Position = UDim2.fromScale(0.929642, 1.000143);
            AnchorPoint = Vector2.new(1, 0.5);
            Size = UDim2.fromScale(0.48343, 0.132883);
            BackgroundTransparency = 1;
            BorderColor3 = Color3.fromRGB(27, 42, 53);
            BorderSizePixel = 1;
        };
    };
}
end

return BaseWindow
