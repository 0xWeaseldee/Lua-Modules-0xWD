---
-- @Liquipedia
-- page=Module:MainPageLayout/data
--
-- Please see https://github.com/Liquipedia/Lua-Modules to contribute
--

local DateExt = require('Module:Date/Ext')
local Lua = require('Module:Lua')

local TournamentsTicker = Lua.import('Module:Widget/Tournaments/Ticker')

local HtmlWidgets = Lua.import('Module:Widget/Html/All')
local Div = HtmlWidgets.Div
local FilterButtonsWidget = Lua.import('Module:Widget/FilterButtons')
local MatchTicker = Lua.import('Module:Widget/MainPage/MatchTicker')
local ThisDayWidgets = Lua.import('Module:Widget/MainPage/ThisDay')
local TransfersList = Lua.import('Module:Widget/MainPage/TransfersList')
local WantToHelp = Lua.import('Module:Widget/MainPage/WantToHelp')

local CONTENT = {
	usefulArticles = {
		heading = 'Useful Articles',
		body = '{{Liquipedia:Useful Articles}}',
		padding = true,
		boxid = 1503,
	},
	wantToHelp = {
		heading = 'Want To Help?',
		body = WantToHelp{},
		padding = true,
		boxid = 1504,
	},
	transfers = {
		heading = 'Transfers',
		body = TransfersList{
			transferQuery = false,
			transferPage = 'Player Transfers/' .. os.date('%Y') .. '/' ..
				DateExt.quarterOf{ ordinalSuffix = true } .. ' Quarter'
		},
		boxid = 1509,
	},
	thisDay = {
		heading = ThisDayWidgets.Title(),
		body = ThisDayWidgets.Content(),
		padding = true,
		boxid = 1510,
	},
	specialEvents = {
		noPanel = true,
		body = '{{Liquipedia:Special Event}}',
		boxid = 1516,
	},
	filterButtons = {
		noPanel = true,
		body = Div{
			css = { width = '100%', ['margin-bottom'] = '8px' },
			children = { FilterButtonsWidget() }
		}
	},
	matches = {
		heading = 'Matches',
		body = MatchTicker{},
		padding = true,
		boxid = 1507,
	},
	tournaments = {
		heading = 'Tournaments',
		body = TournamentsTicker{
			upcomingDays = 40,
			completedDays = 40
		},
		padding = true,
		boxid = 1508,
	},
}

return {
	banner = {
		lightmode = 'Arenafps-lightmode.svg',
		darkmode = 'Arenafps-darkmode.svg',
	},
	metadesc = 'The Arena FPS esports wiki covering everything from players, teams and transfers, ' ..
		'to tournaments and results, maps, and weapons.',
	title = 'Arena FPS',
	navigation = {
		{
			file = 'Team Liquid at DH Winter 2017.jpg',
			title = 'Teams',
			link = 'Portal:Teams',
			count = {
				method = 'LPDB',
				table = 'team',
			},
		},
		{
			file = 'Rapha_at_Barcelona_KeenCon_2023.jpg',
			title = 'Players',
			link = 'Portal:Players',
			count = {
				method = 'LPDB',
				table = 'player',
			},
		},
		{
			file = 'PGL Quake Champions Open 2018 Trophy.jpg',
			title = 'Tournaments',
			link = 'Portal:Tournaments',
			count = {
				method = 'LPDB',
				table = 'tournament',
			},
		},
		{
			file = 'CYpheR and Asdtroboy at DH Winter 2017.jpg',
			title = 'Transfers',
			link = 'Portal:Transfers',
			count = {
				method = 'LPDB',
				table = 'transfer',
			},
		},
		{
			file = 'DreamHack Summer 2010.jpg',
			title = 'Statistics',
			link = 'Portal:Statistics',
		},
		{
			file = 'QL_Blood_Run.jpg',
			title = 'Maps',
			link = 'Portal:Maps',
			count = {
				method = 'CATEGORY',
				category = 'Maps',
			},
		},
		{
			file = 'Cover Quake Champions.jpg',
			title = 'Games',
			link = 'Portal:Games',
			count = {
				method = 'CATEGORY',
				category = 'Games',
			},
		},
	},
	layouts = {
		main = {
			{ -- Left
				size = 6,
				children = {
					{
						mobileOrder = 1,
						content = CONTENT.specialEvents,
					},
					{
						mobileOrder = 3,
						content = CONTENT.transfers,
					},
					{
						mobileOrder = 6,
						content = CONTENT.wantToHelp,
					},
				}
			},
			{ -- Right
				size = 6,
				children = {
					{
						mobileOrder = 2,
						children = {
							{
								children = {
									{
										noPanel = true,
										content = CONTENT.filterButtons,
									},
								},
							},
							{
								size = 6,
								children = {
									{
										noPanel = true,
										content = CONTENT.matches,
									},
								},
							},
							{
								size = 6,
								children = {
									{
										noPanel = true,
										content = CONTENT.tournaments,
									},
								},
							},
						},
					},
					{
						mobileOrder = 5,
						content = CONTENT.thisDay,
					},
					{
						mobileOrder = 4,
						content = CONTENT.usefulArticles,
					},
				},
			},
		},
	},
}
