return {
	{
		uuid = "fakeUuid",
		payloads = {
			{
				type = "log",
				content = {
					values = {
						"test",
					},
					meta = {
						"test",
					},
				},
				origin = {
					file = "./tests/ray_test.lua",
					line_number = "xxx",
					hostname = "fake-hostname",
				},
			},
			{
				type = "log",
				content = {
					values = {
						"test2",
					},
					meta = {
						"test2",
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
				type = "color",
				content = {
					color = "green",
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
				type = "size",
				content = {
					size = "big",
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
