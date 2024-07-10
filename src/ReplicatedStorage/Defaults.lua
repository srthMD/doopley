return {
    Lighting = {
        Ref = game.Lighting;
        Ambient = Color3.fromRGB(0, 0, 0);
        Brightness = 2;
        ColorShift_Bottom = Color3.fromRGB(0, 0, 0);
        ColorShift_Top = Color3.fromRGB(0, 0, 0);
        EnvironmentDiffuseScale = 0;
        EnvironmentSpecularScale = 0;
        OutdoorAmbient = Color3.fromRGB(127, 127, 127);
        ShadowSoftness = 0.5;
        ClockTime = 10.4;
        GeographicLatitude = 41.733;
        ExposureCompensation = 0;
    },

   	Atmosphere = {
        Ref = game.Lighting.Atmosphere;
        Color = Color3.fromRGB(199, 170, 107);
        Decay = Color3.fromRGB(92, 60, 13);
        Glare = 0;
        Haze = 0;
    },

	Blur = {
        Ref = game.Lighting.Blur;
        Enabled = false;
    },

	ColorCorrection = {
        Ref = game.Lighting.ColorCorrection;
        Enabled = false;
    },

	SunRays = {
        Ref = game.Lighting.SunRays;
        Enabled = false;
    },

	Bloom = {
        Ref = game.Lighting.Bloom;
        Enabled = false;
	},
	
	Clouds = {
		Ref = workspace.Terrain.Clouds;
		Enabled = false;
	}
}