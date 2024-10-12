return {
	{
		uuid = "fakeUuid",
		payloads = {
			{
				type = "log",
				content = {
					values = {
						"my value",
					},

					meta = {
						"my value",
					},
				},
				origin = {
					file = "./tests/ray_test.lua",
					line_number = "xxx",
					hostname = "fake-hostname",
				},
			},
		},
		meta = {},
	},
	{
		uuid = "fakeUuid",
		payloads = {
			{
				type = "label",
				content = {
					label = "my label",
				},
				origin = {
					file = "./tests/ray_test.lua",
					line_number = "xxx",
					hostname = "fake-hostname",
				},
			},
		},
		meta = {},
	},
}
