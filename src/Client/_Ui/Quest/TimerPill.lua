--[=[
    @class TimerPill

    A pill that displays a timer.
    (c) 2023 Bloxcode
]=]

local require = require(script.Parent.loader).load(script)

local Blend = require("Blend")
local BasicPane = require("BasicPane")
local SpringObject = require("SpringObject")

local RunService = game:GetService("RunService")

local TimerPill = setmetatable({}, BasicPane)
TimerPill.__index = TimerPill
TimerPill.ClassName = "TimerPill"

function TimerPill.new(obj)
    local self = setmetatable(BasicPane.new(obj), TimerPill)

    self._countdownto = Blend.State(DateTime.now())
    self._maid:GiveTask(self._countdownto)

    self._percentVisible = SpringObject.new(0,35, 1)
    self._maid:GiveTask(self._percentVisible)

    self._pop = SpringObject.new(0, 20, 0.5)
    self._maid:GiveTask(self._pop)

    self._countdown = Blend.State("")
    self._maid:GiveTask(self._countdown)

    self._maid:GiveTask(self.VisibleChanged:Connect(function(isVisible, doNotAnimate)
        if doNotAnimate then
            self._percentVisible.Value = isVisible and 1 or 0
        else
            self._percentVisible.Target = isVisible and 1 or 0
        end
    end))

    --Update countdown every second to 00:00:00 formet
    self._counter = 0
    self._maid:GiveTask(RunService.Heartbeat:Connect(function(step)
        self._counter += step
        if self._counter >= 1 then
            self._counter -= 1
            self._pop:Impulse(10)
            local timeLeft = self._countdownto.Value.UnixTimestamp - os.time()
            local formet = os.date("!*t", timeLeft)

            self._countdown.Value = string.format("%02d:%02d:%02d", formet.hour, formet.min, formet.sec)

            
        end
    end))

    self._maid:GiveTask(self:_render():Subscribe(function(gui)
        self.Gui = gui
    end))

    return self

end

function TimerPill:SetCountdownTo(time)
    self._countdownto.Value = time
    return self
end

function TimerPill:_render()
    local percentVisible = self._percentVisible:ObserveRenderStepped()
    local pop = self._pop:ObserveRenderStepped()
    local transparency = Blend.Computed(percentVisible, function(percentVisible)
        return 1 - percentVisible
    end)

    return Blend.New "Frame" {
    Name = "pill";
    Position = Blend.Computed(pop, transparency, function(pop, transparency)
        return UDim2.fromScale(0.5 - transparency * 0.3, 0.5 - pop * 0.7)
    end);
    AnchorPoint = Vector2.new(0.5, 0.5);
    Size = UDim2.fromScale(1, 1);
    BackgroundColor3 = Color3.fromRGB(255, 50, 50);
    BorderColor3 = Color3.fromRGB(27, 42, 53);
    BorderSizePixel = 1;
    BackgroundTransparency = transparency;
    [Blend.Children] = {
        Blend.New "UICorner" {
            CornerRadius = UDim.new(1, 0);
        };
        Blend.New "UIStroke" {
            Color = Color3.fromRGB(255, 255, 255);
            Thickness = 6.7;
            Transparency = transparency;
        };
        Blend.New "UIListLayout" {
            FillDirection = Enum.FillDirection.Horizontal;
            HorizontalAlignment = Enum.HorizontalAlignment.Center;
            Padding = UDim.new(0.02, 0);
            VerticalAlignment = Enum.VerticalAlignment.Center;
        };
        Blend.New "ImageLabel" {
            Name = "Icon";
            LayoutOrder = -1;
            Size = UDim2.fromScale(0.7, 0.7);
            BackgroundColor3 = Color3.fromRGB(255, 50, 50);
            BackgroundTransparency = 1;
            BorderColor3 = Color3.fromRGB(27, 42, 53);
            ImageTransparency = transparency;
            BorderSizePixel = 1;
            Image = "http://www.roblox.com/asset/?id=12402635628";
            ResampleMode = Enum.ResamplerMode.Pixelated;
            SelectionOrder = 3;
            [Blend.Children] = {
                Blend.New "UIAspectRatioConstraint" {
                    AspectRatio = 1;
                };
            };
        };
        Blend.New "TextLabel" {
            Name = "Time";
            Size = UDim2.fromScale(0, 0.8);
            AutomaticSize = Enum.AutomaticSize.X;
            BackgroundTransparency = 1;
            TextTransparency = transparency;
            BorderColor3 = Color3.fromRGB(27, 42, 53);
            BorderSizePixel = 1;
            FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json");
            Text = self._countdown;
            TextColor3 = Color3.fromRGB(255, 255, 255);
            TextScaled = true;
            TextWrapped = true;
        };
    };
}
end

return TimerPill
