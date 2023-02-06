--[=[
    @class BaseWindow

    Window For Every Ui IN THE PROJECT!!!
    (c) 2023 Bloxcode
]=]

local require = require(script.Parent.loader).load(script)

local BasicPane = require("BasicPane")
local Blend = require("Blend")
local BasicPaneUtils = require("BasicPaneUtils")
local SpringObject = require("SpringObject")

local BaseWindow = setmetatable({}, BasicPane)
BaseWindow.__index = BaseWindow
BaseWindow.ClassName = "BaseWindow"

function BaseWindow.new(obj)
    local self = setmetatable(BasicPane.new(obj), BaseWindow)

    self._displayName = Blend.State("Window!")
    self._maid:GiveTask(self._displayName)

    self._percentVisible = SpringObject.new(0,20, 0.6)
    self._maid:GiveTask(self._percentVisible)

    self._statefulIsVisible = Blend.State(self.IsVisible)
    self._maid:GiveTask(self._statefulIsVisible)

    self._numberIsVisible = Blend.State(0)
    self._maid:GiveTask(self._numberIsVisible)
    
    self._maid:GiveTask(self.VisibleChanged:Connect(function(isVisible, doNotAnimate)
        self._statefulIsVisible.Value = isVisible
        self._numberIsVisible.Value = isVisible and 1 or 0
        if doNotAnimate then
            self._percentVisible.Value = isVisible and 1 or 0
        else
            self._percentVisible.Target = isVisible and 1 or 0
        end
    end))

    return self
end

function BaseWindow:SetDisplayName(name)
    self._displayName.Value = name
    return self
end

function BaseWindow:_renderBase(props, infotip)
    local percentVisible = self._percentVisible:ObserveRenderStepped()
    local transparency = Blend.Computed(percentVisible, function(percentVisible)
        return 1 - percentVisible
    end)

    Blend.Computed(self._statefulIsVisible, function(isVisible)
        print("IsVisible", isVisible)
    end)

    return Blend.New "Frame" {
    Position = UDim2.fromScale(0.5, 0.5);
    AnchorPoint = Vector2.new(0.5, 0.5);
    Size = UDim2.fromScale(1,1);
    BackgroundTransparency = 1;
    [Blend.Children] = {
        Blend.New "UIAspectRatioConstraint" {
            AspectRatio = 1.310345;
            DominantAxis = Enum.DominantAxis.Height;
        };
        Blend.New "UIScale" {
            Scale = Blend.Computed(percentVisible, function(transparency)
                return 0.8 + transparency * 0.2
            end);
        };
        Blend.New "Frame" {
            Name = "Window";
            Position = UDim2.fromScale(0.5, 0.5);
            AnchorPoint = Vector2.new(0.5, 0.5);
            Size = UDim2.fromScale(1, 1);
            BackgroundColor3 = Color3.fromRGB(33, 35, 39);
            Transparency = transparency;
            [Blend.Children] = {
                Blend.New "UICorner" {
                    CornerRadius = UDim.new(0.065, 0);
                };
                Blend.New "UIStroke" {
                    Color = Color3.fromRGB(255, 255, 255);
                    Thickness = 6.7;
                    Transparency = Blend.Computed(transparency, function(transparency)
                        --transparency Can't be bigger than 1
                        return transparency > 1 and 1 or transparency
                    end);
                };
                Blend.New "TextLabel" {
                    Name = "Title";
                    Position = UDim2.fromScale(0.5, 0.171809);
                    AnchorPoint = Vector2.new(0.5, 0.5);
                    Size = UDim2.fromScale(0.797634, 0.121174);
                    BackgroundTransparency = 1;
                    TextTransparency = transparency;
                    FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json");
                    Text = self._displayName;
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
                    GroupTransparency = transparency;
                    BackgroundTransparency = 1;
                    [Blend.Children] = {
                        props[Blend.Children];
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
            Position = Blend.Computed(Blend.Spring(self._numberIsVisible, 10, 0.2), function(value)
                return UDim2.fromScale(0.5,0.5):Lerp(UDim2.new(0.5, 5, 0.5, 7), value)
            end);
            AnchorPoint = Vector2.new(0.5, 0.5);
            Size = UDim2.fromScale(1, 1);
            BackgroundColor3 = Color3.fromRGB(0, 0, 0);
            BackgroundTransparency = Blend.Computed(transparency, function(percent)
                return 1-(1-percent)*0.65
            end);--0.3
            BorderColor3 = Color3.fromRGB(27, 42, 53);
            BorderSizePixel = 1;
            ZIndex = 0;
            [Blend.Children] = {
                Blend.New "UICorner" {
                    CornerRadius = UDim.new(0.065, 0);
                };
                Blend.New "UIStroke" {
                    Thickness = 6.7;
                    Transparency = Blend.Computed(transparency, function(percent)
                        local value = 1-(1-percent)*0.65
                        return value > 1 and 1 or value
                    end);--0.35
                };
            };
        };
        Blend.New "Frame" {
            Name = "InfoTip";
            Position = UDim2.fromScale(0.929642, 1.000143);
            AnchorPoint = Vector2.new(1, 0.5);
            Size = UDim2.fromScale(0.48343, 0.132883);
            BackgroundTransparency = 1;
            [Blend.Children] = infotip[Blend.Children];
        };
    };
}
end

return BaseWindow
